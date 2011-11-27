package URL::Shorten::TinyURL;

# ABSTRACT: Shorten URLs using TinyURL

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    my $self = shift;

    $self->response(
        $self->ua->post('http://tinyurl.com/api-create.php', {
            url => $self->url->as_string,
        })
    );

    if ($self->response->is_success && $self->response->content !~ /^Error/) {
        return $self->response->content;
    }

    return $self->url;
}


1;
