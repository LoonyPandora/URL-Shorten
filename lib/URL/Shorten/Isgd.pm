package URL::Shorten::Isgd;

use utf8;

# ABSTRACT: Shorten URLs using is.gd 

use strict;

use Moo;
use Carp;
use JSON;
use URI;
use URI::QueryParam;

with 'URL::Shorten';

# Auto stringifies and returns the url
use overload ('""' => sub { shift->url });



has domain    => ( is => 'rw', default => sub { 'is.gd' } );
has format    => ( is => 'ro', default => sub { 'json' }  );
has shorturl  => ( is => 'rw' );
has longstats => ( is => 'rw' );




sub shorten {
    my $self = shift;

    my $endpoint = URI->new('http://' . $self->domain . '/create.php');
    
    $endpoint->query_form({
        format => $self->format,
        url    => $self->url->as_string,
    });

    $endpoint->query_param( shorturl  => $self->shorturl  ) if $self->shorturl;
    $endpoint->query_param( longstats => $self->longstats ) if $self->longstats;

    $self->response(
        $self->ua->post($endpoint)
    );

    if ($self->response->is_error) {
        croak "Error from is.gd API: " . $self->response->status_line;
    }

    my $content = decode_json $self->response->content;

    if ($content->{errorcode}) {
        croak "Error shortening URL: " . $content->{errormessage};
    }

    $self->url( $content->{shorturl} );
}



sub lookup {
    my $self = shift;

    my $endpoint = URI->new('http://' . $self->domain . '/forward.php');
    
    $endpoint->query_form({
        format   => $self->format,
        shorturl => $self->url->as_string,
    });

    $self->response(
        $self->ua->post($endpoint)
    );

    if ($self->response->is_error) {
        croak "Error from is.gd API: " . $self->response->status_line;
    }

    my $content = decode_json $self->response->content;

    if ($content->{errorcode}) {
        croak "Error looking up URL: " . $content->{errormessage};
    }

    $self->url( $content->{url} );
}


sub _accepted_domain {
    my $domain = shift;

    my @accepted_domains = qw( is.gd v.gd );

    croak "Invalid domain specified" unless grep $_ eq $domain, @accepted_domains;
}



1;
