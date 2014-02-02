#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use JSON;

use Catalyst::Test 'API';
use HTTP::Request::Common;
use Test::Deep;
use API::Model::Ents;
use List::MoreUtils qw/any/;
##########
# Test adding a new ent
#

my $new_ent = { name => 'TV', img => '/my/tv.png', to => 'me' };

# Request to add $new_ent
my $response = request POST '/ents',
                        Content_Type => 'application/json',
                        Content => to_json($new_ent);


my $new_item_url = $response->header('Location');

# Read new item info
my $new_item_from_server = from_json(get $new_item_url)->{data};

# Make sure the new item is what we put in there
cmp_deeply($new_item_from_server, { %$new_ent, id => ignore() });

# Get all items list
my @all_ents = @{ from_json(get '/ents')->{data} };
my $needle = { name => $new_ent->{name}, id => $new_item_from_server->{id} };

# Make sure our new item is in the list
ok( any { eq_deeply($_ , $needle) } @all_ents, 'New item in list');

done_testing();
