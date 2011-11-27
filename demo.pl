#!/usr/bin/env perl

use common::sense;
use lib 'lib';

use URL::Shorten qw(makeashorterlink);
use URL::Shorten::GitHub;
use URL::Shorten::TinyURL;
use URL::Shorten::TinyArrows;
use URL::Shorten::Metamark;
use URL::Shorten::Google;
use utf8;

# TEST WITH: http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains#Internationalized_country_code_top-level_domains

# Known Issues:
#   URLs with no scheme, that start with a unicode character (WORKAROUND)
#   URLs with no scheme, and a user:pass@example.com (doesn't work, can't fix due to ambiguous nature of that construct)
#   URLs with no scheme, and a port number (doesn't work, can't fix due to ambiguous nature of that construct)

my @urls = (
    'http://例子.測試/首頁',
    'git.io/help',
    'http://fb.me/1rdYzVLbl',
    'https://github.com/blog/985-git-io-github-url-shortener',
    'http://www.google.com/asdf?quest=asdf#sdfsad',
    'http://✪df.ws',
    '✪df.ws',
    'müller.example.org',
    '例子.測試/首頁',
    '例子.測試',
    'www.google.com/asdf?quest=asdf#sdfsad',
    'http://user:pass@www.google.com/asdf?quest=asdf#sdfsad',
    # 'user:pass@www.google.com/asdf?quest=asdf#sdfsad',        # Known issue, skip it
    'https://user:pass@www.google.com/asdf?quest=asdf#sdfsad',
    'http://www.google.com:80/asdf?quest=asdf#sdfsad',
    'www.google.com:80/asdf?quest=asdf#sdfsad',
    'https://metacpan.org/module/Moo::Role',
    'apple',
    # 'apple.com:80', # Known issue, skip it
    'http://www.github.com',
    'http://github.com',
    'ftp://ftp.apple.com',
    'http://daringfireball.net/markdown',
    'http://t.co/gm8daj3D',
    'http://➡.ws/abcb',
    'http://➡.ws/뒑ፊ',
);


for my $original (@urls) {
    my $url = URL::Shorten::Google->new();
    $url->url($original);

    my $short = $url->shorten;
    my $long  = $url->unshorten;

    say 'Original: ' . $original;
    say 'Short:    ' . $short;
    say 'Long:     ' . $long;
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
