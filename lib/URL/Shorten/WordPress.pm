package URL::Shorten::WordPress;

# ABSTRACT: Get long URLs from the WordPress shortener, wp.me

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "WordPress is a lengthen-only service";
}


1;
