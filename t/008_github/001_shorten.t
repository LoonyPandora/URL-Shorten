use Test::More;

use utf8;
use strict;
use warnings;

use URL::Shorten::GitHub;


plan tests => 3;


my $long_urls = {
    'Canonical URL'  => 'https://github.com/blog/985-git-io-github-url-shortener',
    'Coerced URL'    => 'github.com/blog/985-git-io-github-url-shortener',
    'Non Github URL' => 'http://www.example.com/'
};

my $short_urls = {
    'Canonical URL'  => 'http://git.io/help',
    # Coerced URL gives us the http version - hence the different shortURL
    'Coerced URL'    => 'http://git.io/_G2AnQ',
    'Non Github URL' => 'http://www.example.com/'
};


for my $url_type (keys %$long_urls) {
    is(
        URL::Shorten::GitHub->new({
            url => $long_urls->{$url_type},
        })->shorten,
        $short_urls->{$url_type},
        "$url_type"
    );
}

