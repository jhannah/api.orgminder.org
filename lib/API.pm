package API;
use Dancer ':syntax';
use DBI;

our $VERSION = '0.1';

my $dbh = DBI->connect("dbi:SQLite:dbname=db/db.sqlite","","");

get '/' => sub {
    return "hello. docs should go here I suppose";
};

get '/hello/:name' => sub {
    return "Why, hello there " . param('name');
};

# select
get '/groups' => sub {
  content_type 'application/json' ;
  my $items = $dbh->selectall_arrayref("select * from entity");
  return to_json($items) ;
};

# update
post '/groups/:item_id' => sub {
  content_type 'application/json';
  # $dbh->do(...) ;
  return to_json({updated => 1});
};

# insert
put '/groups' => sub { 
  content_type 'application/json';
  # $dbh->do(...) ;
  return to_json({added => 1}) ;
};

# delete
del '/groups/:item_id' => sub {
  content_type 'application/json';
  # $dbh->do(...) ;
  return to_json({deleted => 1}) ;
};

true;

