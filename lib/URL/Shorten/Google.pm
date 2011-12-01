package URL::Shorten::Google;

use utf8;

# ABSTRACT: Shorten URLs using Google (goo.gl)

use strict;

use Moo;
use Carp;
use JSON;
use URI;

with 'URL::Shorten';


has key        => ( is  => 'rw', isa => \&_valid_key, required => 1 );
has projection => ( is  => 'rw', isa => \&_accepted_projection, default => sub { 'FULL' } );


sub shorten {
    my $self = shift;

    my $endpoint = URI->new('https://www.googleapis.com/urlshortener/v1/url');

    $endpoint->query_form({ key => $self->key });

    $self->response(
        $self->ua->post($endpoint,
            'Content-Type' => 'application/json',
            'Content'      => encode_json ({
                longUrl => $self->url->as_string,
            }),
        )
    );

    if ($self->response->is_error) {
        croak "Error from Google API: " . $self->response->status_line;
    }

    my $content = decode_json $self->response->content;

    return $content->{id};
}



sub analytics {
    my $self = shift;

    my $endpoint = URI->new('https://www.googleapis.com/urlshortener/v1/url');

    $endpoint->query_form({
        projection => $self->projection,
        shortUrl   => $self->url->as_string,
        key        => $self->key,
    });

    $self->response(
        $self->ua->get($endpoint)
    );

    if ($self->response->is_error) {
        croak "Error from Google API: " . $self->response->status_line;
    }

    my $content = decode_json $self->response->content;

    return $content;
}




sub _valid_key {
    my $key = shift || croak 'No API key specified';

    if ($key !~ /^[-\w]{39}$/) {
        croak "API key provided doesn't appear valid. Given: $key";
    }
}

sub _accepted_projection {
    my $projection = shift || croak 'No Projection specified';

    my @accepted_projections = qw( FULL ANALYTICS_CLICKS ANALYTICS_TOP_STRINGS );

    croak "Invalid projection specified. Given: $projection"
        unless grep $_ eq $projection, @accepted_projections;
}


1;
