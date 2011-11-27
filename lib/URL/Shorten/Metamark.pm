package URL::Shorten::Metamark;

# ABSTRACT: Shorten URLs using Metamark (xrl.us) 

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';



sub shorten {
    my $self = shift;

    $self->response(
        $self->ua->post('http://metamark.net/api/rest/simple', {
            long_url => $self->url->as_string,
        })
    );

    if ($self->response->is_success && $self->response->content !~ /^ERROR/) {
        return $self->response->content;
    }

    return $self->url;
}

1;
