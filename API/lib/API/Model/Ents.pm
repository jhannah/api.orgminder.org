package API::Model::Ents;

use strict;
use base 'Catalyst::Model';
use List::Util qw/first max/;
use List::MoreUtils qw/first_index/;
 
my @data = (
  { id => 0, name => 'Car', img => 'http://placekitten.com/200/300', to => 'Joe' },
  { id => 1, name => 'Headphones', img => 'http://placekitten.com/200/300', to => 'Bob' },
  { id => 2, name => 'Snowman', img => 'http://placekitten.com/200/300', to => 'Mike' },
);
 
sub all {
  return [ map { id => $_->{id}, name => $_->{name} }, @data ];
}
 
sub retrieve {
  my ( $self, $id ) = @_;
  return first { $_->{id} == $id } @data;
}
 
sub add_new {
  my ( $self, $entdata ) = @_;
  # Verify all fields in place
  return if ! $entdata->{name} || ! $entdata->{img};
 
  my $next_id = max(map $_->{id}, @data) + 1;
  push @data, { %$entdata, id => $next_id };
  return $#data;
}
 
sub update {
  my ( $self, $id, $entdata ) = @_;
  return if ! defined($entdata->{name}) ||
            ! defined($entdata->{id})   ||
            ! defined($entdata->{img});
 
  my $idx = first_index { $_->{id} == $id } @data;
  return if ! defined($idx);
 
  $data[$idx] = { %$entdata, id => $id };
  return 1;
}
 
sub delete_ent {
  my ( $self, $id ) = @_;
  my $idx = first_index { $_->{id} == $id } @data;
 
  return if ! defined($idx);
 
  splice @data, $idx, 1;
}
 
# Used for testing purposes
sub _get_data { return @data }

