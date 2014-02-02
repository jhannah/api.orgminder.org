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
my @all_data = API::Model::Ents->new->_get_data;

my $response = get '/ents';

my @ents = @{from_json($response)->{data}};
is(@ents, @all_data, "ent count match");

for ( my $i=0 ; $i < @all_data; $i++ ) {
  is(keys %{$ents[$i]}, 2, "[$i] has 2 data fields");
  is($ents[$i]->{name}, $all_data[$i]->{name}, "[$i] name match");
  is($ents[$i]->{id},   $all_data[$i]->{id},   "[$i] id match");
}

done_testing();

