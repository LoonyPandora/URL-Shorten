use Test::More tests => 5;

use utf8;
use strict;
use warnings;

use URL::Shorten::Google;


my $long_urls = {
    'Canonical URL'       => 'http://www.example.com',
    'Coerced URL'         => 'www.example.com',
    'Canonical UTF-8 URL' => 'http://例え.テスト/メインページ',
    'Coerced UTF-8 URL'   => '例え.テスト/メインページ',
    'Punycode URL'        => 'http://xn--r8jz45g.xn--zckzah'
};

my $short_urls = {
    'Canonical URL'       => 'http://goo.gl/U98s',
    'Coerced URL'         => 'http://goo.gl/U98s',
    'Canonical UTF-8 URL' => 'http://goo.gl/LIzi',
    'Coerced UTF-8 URL'   => 'http://goo.gl/LIzi',
    'Punycode URL'        => 'http://goo.gl/Jg474'
};


for my $url_type (keys %$long_urls) {
    is(
        URL::Shorten::Google->new({
            url => $long_urls->{$url_type},
            key => ''
        })->shorten,
        $short_urls->{$url_type},
        "$url_type"
    );
}

