package URL::Shorten::Bitly;

# ABSTRACT: Shorten URLs using Bit.ly

use utf8;
use strict;

use Moo;
use Carp;
use JSON;
use URI;

with 'URL::Shorten';


has apikey => (
    is       => 'rw',
    isa      => \&_valid_api_key,
    required => 1,
);

has login => (
    is       => 'rw',
    isa      => \&_valid_login,
    required => 1,
);

has domain => (
    is       => 'rw',
    isa      => \&_accepted_domain,
    default  => sub { 'bit.ly' },
);


sub shorten {
    my $self = shift;

    $self->response(
        $self->ua->post('http://api.bitly.com/v3/shorten', {
            login   => $self->login,
            apiKey  => $self->apikey,
            longUrl => $self->url->as_string,
            domain  => $self->domain,
        })
    );

    if ($self->response->is_success) {
        my $content = decode_json $self->response->content;

        # Bitly responds with a 200 OK even if there is an error
        # And puts the REAL error code in the JSON.
        if ($content->{status_code} != '200') {
            return $self->url;
        }

        return $content->{data}->{url};
    }

    return $self->url;
}


sub clicks {
    my $self = shift;

    my $endpoint = URI->new('http://api.bitly.com/v3/clicks');

    $endpoint->query_form({
        login    => $self->login,
        apiKey   => $self->apikey,
        shortUrl => $self->url->as_string,
    });

    $self->response(
        $self->ua->get($endpoint)
    );

    if ($self->response->is_success) {
        my $content = decode_json $self->response->content;

        if ($content->{status_code} != '200') {
            return undef;
        }

        return $content->{data}->{clicks};
    }

    return $self->url;
}


sub referrers {
    my $self = shift;

    my $endpoint = URI->new('http://api.bitly.com/v3/referrers');

    $endpoint->query_form({
        login    => $self->login,
        apiKey   => $self->apikey,
        shortUrl => $self->url->as_string,
    });

    $self->response(
        $self->ua->get($endpoint)
    );

    if ($self->response->is_success) {
        my $content = decode_json $self->response->content;

        if ($content->{status_code} != '200') {
            return undef;
        }

        return $content->{data}->{referrers};
    }

    return $self->url;
}



sub _valid_api_key {
    my $api_key = shift || croak 'No API key specified';

    if ($api_key !~ /^[-\w]{34}$/) {
        croak "API key provided doesn't appear valid. Given: $api_key";
    }
}

sub _valid_login {
    my $login = shift || croak 'No Login specified';

    if ($login !~ /^[-\w]+$/) {
        croak "Login key provided doesn't appear valid. Given: $login";
    }
}

sub _accepted_domain {
    my $domain = shift;

    # List is current as of 2011-11-27.
    # See: http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/shorten
    my @accepted_domains = qw( bit.ly j.mp bitly.com );

    # Could use smart match, but want compatibility <v5.10
    croak "Invalid domain specified. Given: $domain" unless grep $_ eq $domain, @accepted_domains;
}



1;
