#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use JSON;

use Catalyst::Test 'API';
use HTTP::Request::Common qw/DELETE GET POST/;
use Test::Deep;
use API::Model::Ents;
use List::MoreUtils qw/none/;

my @ents = @{from_json(get '/ents')->{data}};
my $item = shift @ents;
my $item_url = '/ents/' . $item->{id};

# Delete an item
request DELETE $item_url;

# Item id is no longer in the list
@ents = @{from_json(get '/ents')->{data}};
ok( none { $_->{id} == $item->{id} } @ents);

# Request for the item returns an error
my $res = request GET $item_url;
ok(! $res->is_success, 'fail to get deleted item' );
done_testing();



