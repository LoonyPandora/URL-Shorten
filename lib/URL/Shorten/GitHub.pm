package URL::Shorten::GitHub;

# ABSTRACT: Shorten GitHub URLs using GitHub's URL shortener - git.io

use common::sense;
use utf8;
use Moo;

use Carp;

with 'URL::Shorten';


sub shorten {
    my $self = shift;

    if ($self->url->host !~ m/^(gist\.)?github\.com$/) {
        carp 'GitHub only shortens github.com URLs. You tried to shorten: ' . $self->url->host;
    }

    $self->response(
        $self->ua->post('http://git.io', {
            url => $self->url->as_string,
        })
    );

    if ($self->response->is_success) {
        return $self->response->header('Location');
    }

    return $self->url;
}


1;

=head1 CAVEATS

Git.io only shortens URLs on github.com and its subdomains.

It is not a general purpose URL shortener.

=head1 SEE ALSO

L<URL::Shorten>, L<http://git.io/help>

=head1 AUTHOR

James Aitken <jaitken@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by James Aitken.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
