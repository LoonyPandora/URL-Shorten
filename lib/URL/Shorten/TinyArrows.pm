package URL::Shorten::TinyArrows;

# ABSTRACT: Shorten URLs using TinyArrows 

use utf8;
use strict;

use Moo;
use Carp;
use URI;
use URI::QueryParam;

with 'URL::Shorten';


has host => (
    is  => 'rw',
    isa => \&_accepted_domain,
);

has suggest => (
    is => 'rw',
);


sub shorten {
    my $self = shift;

    # The order of params is important to this API
    my $endpoint = URI->new('http://tinyarro.ws/api-create.php');
    $endpoint->query_param( utfpure => '1' );
    $endpoint->query_param( host    => $self->host )            if $self->host;
    $endpoint->query_param( suggest => $self->suggest )         if $self->suggest;
    $endpoint->query_param( url     => $self->url->as_string );

    $self->response(
        $self->ua->get($endpoint)
    );

    if ($self->response->is_success && $self->response->content !~ /^Error/) {
        return $self->response->content;
    }

    return $self->url;
}



sub _accepted_domain {
    my $domain = shift;

    # List is current as of 2011-11-27. See: http://tinyarrows.com/info/api
    my @accepted_domains = qw(
        xn--ogi.ws    xn--vgi.ws    xn--3fi.ws    xn--egi.ws
        xn--9gi.ws    xn--5gi.ws    xn--1ci.ws    xn--odi.ws
        xn--rei.ws    xn--cwg.ws    xn--bih.ws    xn--fwg.ws
        xn--l3h.ws    ta.gd
    );

    # Could use smart match, but want compatibility <v5.10
    croak "Invalid host specified" unless grep $_ eq $domain, @accepted_domains;
}


1;
