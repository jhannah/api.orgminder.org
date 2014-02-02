use Test::More tests => 2;
use strict;
use warnings;
 
use API;
use Dancer::Test;
use JSON;
 
 response_content_is [PUT => '/jsondata', { body => 42 }], 42,
    "a request with a body looks good";

 response_content_is [ PUT => '/ents', { body => { Jay => 'Hannah' }}] , 42,
    "a request with a body looks good";


#my $response = dancer_response('PUT', '/ents', 
#   { body => 42 }   # to_json({ Jay => 'Hannah' }) }
#);
#is $response->{status}, 201, "PUT /ents is 201";
#is $response->{content}, "jay rules";

