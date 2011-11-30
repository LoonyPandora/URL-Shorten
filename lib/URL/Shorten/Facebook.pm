package URL::Shorten::Facebook;

use utf8;

# ABSTRACT: Get long URLs from the Facebook shortener, fb.me

use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "Facebook is a lengthen-only service";
}


1;
