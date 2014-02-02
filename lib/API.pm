package API;
use Dancer ':syntax';
use DBI;

our $VERSION = '0.1';

my $dbh = DBI->connect("dbi:SQLite:dbname=db/db.sqlite","","");

set serializer => 'JSON';

get '/' => sub {
    return "hello. docs should go here I suppose";
};

get '/hello/:name' => sub {
    return "Why, hello there " . param('name');
};

# select
get '/ents' => sub {
  content_type 'application/json' ;
  my $items = $dbh->selectall_arrayref("select * from entity");
  return to_json($items) ;
};

# update
post '/ents/:id' => sub {
  content_type 'application/json';
  # $dbh->do(...) ;
  return to_json({updated => 1});
};

put '/jsondata' => sub {
    request->body;
};

# insert
put '/ents' => sub {
  my $details = to_json(request->body);
  $dbh->do(
    "insert into ents (type, name, details) values (?, ?, ?)", 
    "person", "Jay Hannah", $details
  );
  # return to_json({added => 1}) ;
  # return to_json("jay rules");
  return $dbh->last_insert_id;
};


# delete
del '/ents/:id' => sub {
  content_type 'application/json';
  # $dbh->do(...) ;
  return to_json({deleted => 1}) ;
};

true;

