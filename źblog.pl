use Bailador; Bailador::import;
use DBIish;

my $db = DBIish.connect('SQLite', database => 'blog.db');

sub get-articles {
    my $sth = $db.prepare: 'SELECT * FROM articles';
    $sth.execute;
    return $sth.fetchall_arrayref.map: {
        { title => $_[0],
          pubdate => $_[1],
          text => $_[2] }
    };
}

get '/' => sub {
    template 'index.tt', { articles => get-articles };
}

post '/post' => sub {
    my $p = request.params;
    my $sth = $db.prepare: 'INSERT INTO articles VALUES (?, datetime(?), ?)';
    $sth.execute($p<title>, DateTime.now.posix, $p<text>);
    "ok, done";
}

baile;
