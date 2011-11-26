package URL::Shorten;

# ABSTRACT: Shorten URLs using many URL shorteners

use common::sense;
use utf8;
use Moo::Role;

use LWP;
use URI;
use URI::Heuristic qw(uf_uri);

use Carp;

use Exporter;

our @EXPORT_OK = qw(makeashorterlink makealongerlink);
our $VERSION = '0.1.0';


has url => (
    is     => 'rw',
    coerce => \&_into_url,
    isa    => \&_url,
);

has ua => (
    is      => 'ro',
    default => \&_ua,
);

has response => (
    is => 'rw',
);



sub shorten { croak 'Use the subclass directly.'; }




sub unshorten {
    my $self = shift;

    $self->response(
        $self->ua->get($self->url->as_string)
    );

    if ($self->response->is_redirect) {
        return $self->response->header('Location');
    }

    return $self->url;
}




# Aliases for compatiblity with WWW::Shorten
sub makeashorterlink {
    return URL::Shorten->new({
        url => shift,
    })->shorten;
}

sub makealongerlink {
    return URL::Shorten->new({
        url => shift,
    })->unshorten;
}



# Provides the LWP::UserAgent object everywhere.
sub _ua {
    return LWP::UserAgent->new(
        env_proxy   => 1,
        timeout     => 30,
        agent       => __PACKAGE__ . "/" . __PACKAGE__->VERSION(),
        requests_redirectable => [],
    );
}


# Checks we have a valid URL after coercion
sub _url {
    my $uri = shift || croak 'No URL specified';

    # Coerce gives everything a scheme,
    # but to be a sane URL we need more than just a scheme
    if (!$uri->scheme || !$uri->opaque) {
        croak "URL provided doesn't appear valid. Was given: $uri";
    }

    return $uri;
}


# Coerces input into a url. Also does punycode conversion for IDN support
sub _into_url {
    my $uri = uf_uri($_[0]);

    # If the heuristic doesn't provide a good guess to the scheme
    # Just blast it to http. Useful because the heuristic doesn't
    # add a scheme to URLs that start with a non-ASCII character
    # so some URL shorteners would never work without forcing http.
    if (!$uri->scheme) {
        return uf_uri('http://' . $_[0]);
    }

    return $uri->canonical;
}


1;

