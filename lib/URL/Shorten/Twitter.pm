package URL::Shorten::Twitter;

# ABSTRACT: Get long URLs from Twitter's shortener, t.co

use common::sense;
use utf8;
use Moo;

use Carp;

with 'URL::Shorten';


sub shorten {
    carp "Twitter is a lengthen-only shortener";
}

1;
