package URL::Shorten::DaringFireball;

# ABSTRACT: Get long URLs from the Daring Fireball shortener, ✪df.ws

use utf8;
use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "Daring Fireball is a lengthen-only service";
}


1;
