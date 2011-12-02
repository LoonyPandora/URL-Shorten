use Test::More;

use utf8;
use strict;
use warnings;

use URL::Shorten::Bitly;


plan skip_all => "Env BITLY_API_KEY required to run google tests"
    unless $ENV{BITLY_API_KEY};

plan tests => 5;


my $long_urls = {
    'Canonical URL'       => 'http://www.example.com',
    'Coerced URL'         => 'www.example.com',
    'Canonical UTF-8 URL' => 'http://例え.テスト/メインページ',
    'Coerced UTF-8 URL'   => '例え.テスト/メインページ',
    'Punycode URL'        => 'http://xn--r8jz45g.xn--zckzah'
};

my $short_urls = {
    'Canonical URL'       => 'http://tinyurl.com/d9kp',
    'Coerced URL'         => 'http://tinyurl.com/d9kp',
    'Canonical UTF-8 URL' => 'http://tinyurl.com/d9tke8j',
    'Coerced UTF-8 URL'   => 'http://tinyurl.com/d9tke8j',
    'Punycode URL'        => 'http://tinyurl.com/cctaswl'
};


for my $url_type (keys %$long_urls) {
    is(
        URL::Shorten::Bitly->new({
            url => $long_urls->{$url_type},
            key => $ENV{BITLY_API_KEY}
        })->shorten,
        $short_urls->{$url_type},
        "$url_type"
    );
}

