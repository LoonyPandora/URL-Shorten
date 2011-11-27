package URL::Shorten::Twitter;

# ABSTRACT: Get long URLs from the Twitter shortener, t.co

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "Twitter is a lengthen-only service";
}


1;
