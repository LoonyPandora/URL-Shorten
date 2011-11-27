package URL::Shorten::Google;

# ABSTRACT: Shorten URLs using Google (goo.gl)

use utf8;
use strict;

use Moo;
use Carp;
use HTTP::Request;
use JSON;

with 'URL::Shorten';


sub shorten {
    my $self = shift;

    my $request = HTTP::Request->new;
    $request->method('POST');
    $request->uri('https://www.googleapis.com/urlshortener/v1/url');
    $request->content_type('application/json');
    $request->content( encode_json({ longUrl => $self->url->as_string }) );

    $self->response(
        $self->ua->request($request)
    );

    if ($self->response->is_success) {
        my $content = decode_json $self->response->content;

        return $content->{id};
    }

    return $self->url;
}


1;
