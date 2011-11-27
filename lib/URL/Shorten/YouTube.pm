package URL::Shorten::YouTube;

# ABSTRACT: Get long URLs from the YouTube shortener, youtu.be

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "YouTube is a lengthen-only service";
}


1;
