use strict;
use warnings;
use utf8;
use 5.10.0;

package CPANDiff::API;
use Smart::Args;
use LWP::UserAgent;
use JSON;
use Data::Dumper;

sub instance {
    my $class = shift;
    state $self;
    $self //= $class->new();
}

sub new {
    my $class = shift;
    bless {
    }, $class;
}

sub create_request {
    my ( $self, $path, $search ) = @_;

    my $endpoint = 'http://api.beta.metacpan.org/';
    my $url      = $endpoint . $path;
    my $request  = HTTP::Request->new( 'POST', $url );
    if ($search) {
        $request->content( encode_json($search) );
        $request->content_type('application/json');
    }
    $request->content_length( length $request->content );
    return $request;
}

sub ua {
    my $self = shift;
    $self->{ua} //= LWP::UserAgent->new();
}

sub request {
    my ( $self, $path, $args ) = @_;

    my $request = $self->create_request($path, $args);
    $self->ua->request($request);
}

sub get_file_list {
    args my $self,
         my $release,
         my $author,
         ;

    my $res = $self->request(
        '/v0/file/_search' => {
            query => {
                filtered => {
                    query  => { match_all => {} },
                    filter => {
                        and => [
                            { term => { release   => $release } },
                            { term => { author    => $author } },
                            { term => { directory => 0 } },
                        ]
                    }
                }
            },
            fields => [qw/path/],
            size   => 2000,
        }
    );
    $res->is_success or die "Cannot get list of files for '$release' by '$author' : " . $res->status_line;
    my $dat = decode_json($res->decoded_content);
    my @paths = grep { $_ ne '' } map { $_->{fields}->{path} } @{$dat->{hits}->{hits}};
    return @paths;
}

sub get_source {
    args my $self,
         my $release,
         my $author,
         my $path,
         ;

    # http://api.metacpan.org/source/OVID/Text-Diff-1.41/README
    my $uri = "http://api.metacpan.org/source/$author/$release/$path";
    my $res = $self->ua->get($uri);
    $res->is_success or die "Cannot get $uri: " . $res->status_line;
    return $res->decoded_content;
}

1;

