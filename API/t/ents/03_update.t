#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use JSON;

use Catalyst::Test 'API';
use HTTP::Request::Common;
use Test::Deep;
use API::Model::Ents;

##########
# Test initial ent list includes all the ents
#
my @ents = @{from_json(get '/ents')->{data}};
my $first = shift @ents;
my $item_url = '/ents/' . $first->{id};

my $to_update = from_json(get $item_url)->{data};

$to_update->{name} = 'new name';
$to_update->{img} = 'new image';

# Send update request for item
request POST '/ents/' . $to_update->{id},
        Content_Type => 'application/json',
        Content => to_json($to_update);

# Read item info after update
my $after_update = from_json(get $item_url)->{data};

# Make sure our changes are stored
is($after_update->{name}, 'new name', 'new name match');
is($after_update->{img}, 'new image', 'new image match');


done_testing();


