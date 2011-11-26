#!/usr/bin/env perl

use common::sense;
use lib 'lib';

use URL::Shorten qw(makeashorterlink);
use utf8;

# TEST WITH: http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains#Internationalized_country_code_top-level_domains


my @urls = (
    'http://www.google.com/asdf?quest=asdf#sdfsad',
    'http://✪df.ws',
    '✪df.ws',
    'müller.example.org',
    'http://例子.測試/首頁',
    '例子.測試/首頁',
    '例子.測試',
    'www.google.com/asdf?quest=asdf#sdfsad',
    'user:pass@www.google.com/asdf?quest=asdf#sdfsad',
    'https://user:pass@www.google.com/asdf?quest=asdf#sdfsad',
    'http://www.google.com:999/asdf?quest=asdf#sdfsad',
    'www.google.com:999/asdf?quest=asdf#sdfsad',
    'https://metacpan.org/module/Moo::Role',
    'apple',
    'apple.com:80',
);


for my $url (@urls) {
   my $short = URL::Shorten->new();
   $short->url($url);

    say 'Original: ' . $url;
    say 'OldSkool: ' . makeashorterlink($url);
    say 'NewSkool: ' . $short->shorten;

    say '----';
}


# Getters / Setters
# url     => gets and sets the original "long" url
#
# Eventually will have more, and custom ones for authentication etc


# Methods
# shorten   => shortens the url. Returns original URL on failure, and carps
# unshorten => checks the url, and reutrns the longer original version.


1;
