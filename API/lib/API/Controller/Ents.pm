package API::Controller::Ents; 
use Moose; 
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }
 
__PACKAGE__->config(
  action => {
    '*' => {
      # Attributes common to all actions
      # in this controller
      Consumes => 'JSON',
      Path => '',
    }
  }
);
 
# end action is always called at the end of the route
sub end :Private {
  my ( $self, $c ) = @_;
# Render the stash using our JSON view
  $c->forward($c->view('JSON'));
}
 
# We use the error action to handle errors
sub error :Private {
  my ( $self, $c, $code, $reason ) = @_;
  $reason ||= 'Unknown Error';
  $code ||= 500;
 
  $c->res->status($code);
# Error text is rendered as JSON as well
  $c->stash->{data} = { error => $reason };
}
 
 
 
 
# List all ents in the collection
# GET /ents
sub list :GET Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{data} = $c->model('Ents')->all;
}
 
# Get info on a specific item
# GET /ents/:id
sub retrieve :GET Args(1) {
  my ( $self, $c, $id ) = @_;
  my $e = $c->model('Ents')->retrieve($id);
 
# In case of an error, call error action and abort
  $c->detach('error', [404, "No such ent: $id"]) if ! $e;
 
# If we're here all went well, so fill the stash with our item
  $c->stash->{data} = $e;
}
 
# Create a new item
# POST /ents
sub create :POST Args(0) {
  my ( $self, $c ) = @_;
  my $data = $c->req->body_data;
 
  my $id = $c->model('Ents')->add_new($data);
 
  $c->detach('error', [400, "Invalid ent data"]) if ! $id;
 
# Location header is the route to the new item
  $c->res->location("/ents/$id");
}
 
# Update an existing item
# POST /ents/:id
sub update :POST Args(1) {
  my ( $self, $c, $id ) = @_;
  my $data = $c->req->body_data;
 
  my $ok = $c->model('Ents')->update($id, $data);
  $c->detach('error', [400, "Fail to update ent: $id"]) if ! $ok;
}
 
# Delete an item
# DELETE /ents/:id
sub delete :DELETE Args(1) {
  my ( $self, $c, $id ) = @_;
  my $ok = $c->model('Ents')->delete_ent($id);
  $c->detach('error', [400, "Invalid ent id: $id"]) if ! $ok;
}


