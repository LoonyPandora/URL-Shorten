package URL::Shorten::Facebook;

# ABSTRACT: Get long URLs from the Facebook shortener, fb.me

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "Facebook is a lengthen-only service";
}


1;
