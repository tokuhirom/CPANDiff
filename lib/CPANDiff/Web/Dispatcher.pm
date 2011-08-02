package CPANDiff::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;
use AnyEvent::HTTP;

any '/' => sub {
    my ($c) = @_;
    $c->render('index.tt');
};

any '/api/get_filelist' => sub {
    my $c = shift;

};

sub create_request {
    my ( $self, $path, $search ) = @_;

    my $endpoint = 'http://api.beta.metacpan.org/';
    my $url      = $endpoint . $path;

    my $request = HTTP::Request->new( 'POST', $url );
    if ($search) {
        $request->content( encode_json($search) );
        $request->content_type('application/json');
    }
    $request->content_length( length $request->content );
    warn $request->as_string;
    return $request;
}

1;
