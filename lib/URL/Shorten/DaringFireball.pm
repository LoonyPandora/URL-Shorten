package URL::Shorten::DaringFireball;

use utf8;

# ABSTRACT: Get long URLs from the Daring Fireball shortener, ✪df.ws

use strict;

use Moo;
use Carp;

with 'URL::Shorten';


sub shorten {
    carp "Daring Fireball is a lengthen-only service";
}


1;
