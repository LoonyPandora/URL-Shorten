use Test::More;

use utf8;
use strict;
use warnings;

use URL::Shorten::Metamark;


plan tests => 5;


my $long_urls = {
    'Canonical URL'       => 'http://www.example.com',
    'Coerced URL'         => 'www.example.com',
    'Canonical UTF-8 URL' => 'http://例え.テスト/メインページ',
    'Coerced UTF-8 URL'   => '例え.テスト/メインページ',
    'Punycode URL'        => 'http://xn--r8jz45g.xn--zckzah'
};

my $short_urls = {
    'Canonical URL'       => 'http://xrl.us/bejo8g',
    'Coerced URL'         => 'http://xrl.us/bejo8g',
    'Canonical UTF-8 URL' => 'http://xrl.us/bmjyea',
    'Coerced UTF-8 URL'   => 'http://xrl.us/bmjyea',
    'Punycode URL'        => 'http://xrl.us/bmjyd8'
};


for my $url_type (keys %$long_urls) {
    is(
        URL::Shorten::Metamark->new({
            url => $long_urls->{$url_type},
        })->shorten,
        $short_urls->{$url_type},
        "$url_type"
    );
}

