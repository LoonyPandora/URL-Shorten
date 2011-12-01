package URL::Shorten::Bitly;

use utf8;

# ABSTRACT: Shorten URLs using Bit.ly

use strict;

use Moo;
use Carp;
use JSON;
use URI;
use URI::QueryParam;

with 'URL::Shorten';


has apikey   => ( is => 'rw', isa => \&_valid_api_key,   required => 1 );
has login    => ( is => 'rw', isa => \&_valid_login,     required => 1 );
has domain   => ( is => 'rw', isa => \&_accepted_domain, default  => sub { 'bit.ly' } );
has days     => ( is => 'rw', isa => \&_valid_day,       default  => sub { 7 }        );
has format   => ( is => 'ro', isa => \&_valid_format,    default  => sub { 'json' }   );
has hash     => ( is => 'rw', isa => \&_valid_hash    );
has x_apikey => ( is => 'rw', isa => \&_valid_api_key );
has x_login  => ( is => 'rw', isa => \&_valid_login   );


sub shorten {
    my $self = shift;

    $self->response(
        $self->ua->post('http://api.bitly.com/v3/shorten', {
            login   => $self->login,
            apiKey  => $self->apikey,
            longUrl => $self->url->as_string,
            domain  => $self->domain,
            format  => $self->format,
        })
    );

    if ($self->response->is_error) {
        carp "Error shortening URL: " . $self->response->status_line;
        carp "Returning original URL";
        return $self->url;
    }

    my $content = decode_json $self->response->content;

    # Bitly responds with a 200 OK if the HTTP request was successful but
    # there was a problem shortening the link - putting an error in the JSON
    if ($content->{status_code} != '200') {
        carp "Error shortening URL: " . $content->{status_txt};
        carp "Returning original URL";
        return $self->url;
    }

    # Return just the URL. Use the shorten_api method to get the full response
    return $content->{data}->{url};
}



sub shorten_api {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/shorten', {
        longUrl => $self->url->as_string,
        domain  => $self->domain,
    });
}

sub expand {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/expand', {
        shortUrl => $self->url->as_string,
    });
}

sub validate {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/validate', {
        x_login  => $self->x_login,
        x_apiKey => $self->x_apikey,
    });
}

sub clicks {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/clicks', {
        shortUrl => $self->url->as_string,
    });
}

sub referrers {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/referrers', {
        shortUrl => $self->url->as_string,
    });
}

sub countries {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/countries', {
        shortUrl => $self->url->as_string,
    });
}

sub clicks_by_minute {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/clicks_by_minute', {
        shortUrl => $self->url->as_string,
    });
}

sub clicks_by_day {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/countries', {
        shortUrl => $self->url->as_string,
        days     => $self->days,
    });
}

sub bitly_pro_domain {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/bitly_pro_domain', {
        domain => $self->domain,
    });
}

sub lookup {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/lookup', {
        url => $self->url->as_string,
    });
}

sub info {
    my $self = shift;

    $self->_call_api_and_return('http://api.bitly.com/v3/info', {
        shortUrl => $self->url->as_string,
    });
}




sub _call_api_and_return {
    my ($self, $endpoint, $extra_params) = @_;

    $endpoint = URI->new($endpoint);

    $endpoint->query_form({
        format => $self->format,
        login  => $self->login,
        apiKey => $self->apikey,
    });

    for my $param (keys %$extra_params) {
        $endpoint->query_param( $param => $extra_params->{$param} );
    }

    $self->response(
        $self->ua->get($endpoint)
    );

    if ($self->response->is_error) {
        croak "Error from Bitly API: " . $self->response->status_line;
    }

    my $content = decode_json $self->response->content;

    return $content->{data};
}


sub _valid_api_key {
    my $api_key = shift || croak 'No API key specified';

    if ($api_key !~ /^[-\w]{34}$/) {
        croak "API key provided doesn't appear valid. Given: $api_key";
    }
}

sub _valid_login {
    my $login = shift || croak 'No Login key specified';

    if ($login !~ /^[-\w]+$/) {
        croak "Login key provided doesn't appear valid. Given: $login";
    }
}

sub _valid_hash {
    my $hash = shift || croak 'No Hash specified';

    if ($hash !~ /^[-\w]+$/) {
        croak "Login key provided doesn't appear valid. Given: $hash";
    }
}

sub _valid_day {
    my $day = shift || croak 'No Day specified';

    if ($day < 1 || $day > 30) {
        croak "Day must be between 1-30. Given: $day";
    }
}

sub _valid_format {
    my $format = shift || croak 'No Format specified';

    my @accepted_formats = qw( json xml txt );

    croak "Invalid format specified. Given: $format"
        unless grep $_ eq $format, @accepted_formats;
}

sub _accepted_domain {
    my $domain = shift;

    # List is current as of 2011-11-27.
    # See: http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/shorten
    my @accepted_domains = qw( bit.ly j.mp bitly.com );

    croak "Invalid domain specified. Given: $domain"
        unless grep $_ eq $domain, @accepted_domains;
}


1;
