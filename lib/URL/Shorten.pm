package URL::Shorten;

# ABSTRACT: Shorten URLs using many URL shorteners

use common::sense;
use utf8;
use Moo;

use URI;
use URI::Heuristic qw(uf_uri);

use Carp;

use Exporter 'import';
our @EXPORT_OK = qw(makeashorterlink makealongerlink);


has url => (
    is     => 'rw',
    coerce => \&_into_url,
    isa    => \&_url,
);


sub shorten {
    my $self = shift;

    return $self->url->canonical;
}

sub unshorten {
    my $self = shift;
}






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


sub _url {
    my $uri = shift || croak 'No URL specified';

    # Coerce gives everything a scheme,
    # but to be a sane URL we need more than just a scheme
    if (!$uri->scheme || !$uri->opaque) {
        croak "URL provided doesn't appear valid. Was given: $uri";
    }

    return $uri->canonical;
}

sub _into_url {
    my $uri = uf_uri($_[0]);

    # If the heuristic doesn't provide a good guess to the scheme
    # Just blast it to http. Useful because the heuristic doesn't
    # add a scheme to URLs that start with a non-ASCII character
    # so some URL shorteners would never work without forcing http.
    if (!$uri->scheme) {
        return uf_uri('http://' . $_[0]);
    }

    return $uri;
}


1;

