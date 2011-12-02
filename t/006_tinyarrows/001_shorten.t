use Test::More;

use utf8;
use strict;
use warnings;

use URL::Shorten::TinyArrows;
use Encode;

plan tests => 2;


# Tiny Arrows doesn't support shortening IDN's Or UTF8 path names.
# Odd for a URL shortener that relies on Unicode...

my $long_urls = {
    'Canonical URL'       => 'http://www.example.com',
    'Coerced URL'         => 'www.example.com',
};

my $short_urls = {
    'Canonical URL'       => 'http://➡.ws/薟',
    'Coerced URL'         => 'http://➡.ws/薟',
};


for my $url_type (keys %$long_urls) {
    is(
        URL::Shorten::TinyArrows->new({
            url => $long_urls->{$url_type},
        })->shorten,
        Encode::encode_utf8 $short_urls->{$url_type},
        "$url_type"
    );
}

