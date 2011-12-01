use Test::More tests => 4;

use utf8;
use strict;
use warnings;

use URL::Shorten::Generic;

my $urls = {
    'Canonical URL'       => 'http://git.io/LoonyPandora',
    'Coerced URL'         => 'git.io/LoonyPandora',
    'Canonical UTF-8 URL' => 'http://☁.ws/変な牛',
    'Coerced UTF-8 URL'   => '☁.ws/変な牛',
};


for my $url_type (keys %$urls) {
    is(
        URL::Shorten::Generic->new({ url => $urls->{$url_type} })->unshorten,
        'https://github.com/LoonyPandora',
        "$url_type"
    );
}

