use Test::More;

use utf8;
use strict;
use warnings;

use URL::Shorten::Google;


plan skip_all => "Env GOOGLE_API_KEY required to run google tests"
    unless $ENV{GOOGLE_API_KEY};

plan tests => 4;


my $url = URL::Shorten::Google->new({
    url => 'http://goo.gl/U98s',
    key => $ENV{GOOGLE_API_KEY},
});


is($url->analytics->{status}, 'OK', 'Basic Analytics');

$url->projection('FULL');
is($url->analytics->{status}, 'OK', 'Full Analytics');

$url->projection('ANALYTICS_CLICKS');
is($url->analytics->{status}, 'OK', 'Click Analytics');

$url->projection('ANALYTICS_TOP_STRINGS');
is($url->analytics->{status}, 'OK', 'Top Strings Analytics');
