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

sub get_filelist {
    args my $self,
         my $release,
         my $version,
         ;

    my $res = $self->request(
        '/v0/file/_search' => {
            query => {
                filtered => {
                    query  => { match_all => {} },
                    filter => {
                        and => [
                            { term => { release   => "Moose-2.0002" } },
                            { term => { author    => "DOY" } },
                        ]
                    }
                }
            },
            fields => [qw/path/],
            size   => 2000,
        }
    );
    my @paths = map { $_->{fields}->{path} } @{$dat->{hits}->{hits}};
}

1;

