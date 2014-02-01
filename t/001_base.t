use Test::More tests => 2;
use strict;
use warnings;
 
use API;
use Dancer::Test;
 
response_status_is [GET => '/'], 200, "GET / is found";
response_content_like [GET => '/'], qr/hello/, "content looks good for /";

