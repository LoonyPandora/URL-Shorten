#!/usr/bin/env perl

use common::sense;
use lib 'lib';

use URL::Shorten;
use URL::Shorten::GitHub;
use URL::Shorten::TinyURL;
use URL::Shorten::TinyArrows;
use URL::Shorten::Metamark;
use URL::Shorten::Google;
use URL::Shorten::Generic;
use URL::Shorten::Bitly;
use URL::Shorten::Isgd;
use Data::Dumper;
use utf8;

# TEST WITH: http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains#Internationalized_country_code_top-level_domains

# Known Issues:
#   URLs with no scheme, that start with a unicode character (WORKAROUND)
#   URLs with no scheme, and a user:pass@example.com (doesn't work, can't fix due to ambiguous nature of that construct)
#   URLs with no scheme, and a port number (doesn't work, can't fix due to ambiguous nature of that construct)

my @urls = (

#    'goo.gl/fkAI1',

    'http://www.example.com',
#    'www.example.com',
#    'http://例え.テスト/メインページ',
#    '例え.テスト/メインページ',
#    'http://xn--r8jz45g.xn--zckzah'




    # 'http://例え.テスト/メインページ',
    # '☁.ws/変な牛',
    # #'goo.gl/fkAI1',
    # #'http://bit.ly/1YKMfY',
    # 'http://例子.測試/首頁',
    # 'git.io/help',
    # 'http://fb.me/1rdYzVLbl',
    # 'https://github.com/blog/985-git-io-github-url-shortener',
    # 'http://www.google.com/asdf?quest=asdf#sdfsad',
    # 'http://✪df.ws',
    # '✪df.ws',
    # 'müller.example.org',
    # '例子.測試/首頁',
    # '例子.測試',
    # 'www.google.com/asdf?quest=asdf#sdfsad',
    # 'http://user:pass@www.google.com/asdf?quest=asdf#sdfsad',
    # # 'user:pass@www.google.com/asdf?quest=asdf#sdfsad',        # Known issue, skip it
    # 'https://user:pass@www.google.com/asdf?quest=asdf#sdfsad',
    # 'http://www.google.com:80/asdf?quest=asdf#sdfsad',
    # 'www.google.com:80/asdf?quest=asdf#sdfsad',
    # 'https://metacpan.org/module/Moo::Role',
    # 'apple',
    # # 'apple.com:80', # Known issue, skip it
    # 'http://www.github.com',
    # 'http://github.com',
    # 'ftp://ftp.apple.com',
    # 'http://daringfireball.net/markdown',
    # 'http://t.co/gm8daj3D',
    # 'http://➡.ws/abcb',
    # 'http://➡.ws/뒑ፊ',
);


for my $original (@urls) {

    # my $url = URL::Shorten::Bitly->new({
    #     login  => 'loonypandora',
    #     apikey => 'R_849f8773774524a136ee158dc0bad585',
    #      domain => 'j.mp',
    #     url    => $original,
    # });
    # 
     # my $url = URL::Shorten::Google->new({
     #     key => 'AIzaSyBpfgD1LEXv5pAg9BXt_ARVDm37PCtiCC8',
     #     url => $original,
     #     projection => 'ANALYTICS_CLICKS',
     # });


    my $url = URL::Shorten::Isgd->new({
        url => $original,
    });


    $url->shorten;

    die Dumper $url->response;

#    my $short = $url->shorten;
#    my $long  = $url->unshorten;

#    say 'Original: ' . $original;
#    say 'Short:    ' . $short;

    say 'short:              ' . Dumper $url->shorten;
   # say 'long:               ' . Dumper $url->unshorten;
   #  say 'anal:               ' . Dumper $url->analytics;
    # say 'short API:          ' . Dumper $url->shorten_api;

    # say 'referrers:        ' . Dumper $url->referrers;
    # say 'countries:        ' . Dumper $url->countries;
    # say 'clicks_by_minute: ' . Dumper $url->clicks_by_minute;
    # say 'bitly_pro_domain: ' . Dumper $url->bitly_pro_domain;
    # say 'lookup:           ' . Dumper $url->lookup;
    # say 'info:             ' . Dumper $url->info;
    # say '----';

#    die;
}


# Getters / Setters
# url     => gets and sets the original "long" url
#
# Eventually will have more, and custom ones for authentication etc


# Methods
# shorten   => shortens the url. Returns original URL on failure, and carps
# unshorten => checks the url, and reutrns the longer original version.


1;
