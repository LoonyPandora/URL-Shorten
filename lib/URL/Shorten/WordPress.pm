package URL::Shorten::WordPress;

use utf8;

# ABSTRACT: Get long URLs from the WordPress shortener, wp.me

use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "WordPress is a lengthen-only service";
}


1;
