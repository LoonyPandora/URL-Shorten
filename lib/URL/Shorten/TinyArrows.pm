package URL::Shorten::TinyArrows;

# ABSTRACT: Shorten URLs using TinyArrows 

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    my $self = shift;

    $self->response(
        # Their API uses a naive parsing algorithm, so we have to manually
        # create a query string, rather than setting the params via LWP
        $self->ua->get('http://tinyarro.ws/api-create.php?utfpure=1;url='.
            $self->url->as_string
        )
    );

    if ($self->response->is_success && $self->response->content !~ /^Error/) {
        return $self->response->content;
    }

    return $self->url;
}


1;
