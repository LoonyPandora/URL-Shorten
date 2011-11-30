package URL::Shorten::Google;

use utf8;

# ABSTRACT: Shorten URLs using Google (goo.gl)

use strict;

use Moo;
use Carp;
use JSON;
use URI;

with 'URL::Shorten';

has key => (
    is  => 'rw',
    isa => \&_valid_key,
);


sub shorten {
    my $self = shift;

    # Google will most likely require the use of an API key when Goo.gl
    # exits from lab / beta status. Until then, it's optional
    my $endpoint = URI->new('https://www.googleapis.com/urlshortener/v1/url');
    $endpoint->query_param( key => $self->key ) if $self->key;

    $self->response(
        $self->ua->post($endpoint,
            'Content-Type' => 'application/json',
            'Content'      => encode_json ({
                longUrl => $self->url->as_string,
            }),
        )
    );

    if ($self->response->is_success) {
        my $content = decode_json $self->response->content;

        return $content->{id};
    }

    return $self->url;
}


sub _valid_key {
    my $key = shift || croak 'No API key specified';

    if ($key !~ /^[-\w]{39}$/) {
        croak "API key provided doesn't appear valid. Given: $key";
    }
}


1;
