package CPANDiff::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;
use AnyEvent::HTTP;
use CPANDiff::Diff;

any '/' => sub {
    my ($c) = @_;
    
    my @keys = qw(src_author src_release dst_author dst_release);
    if ((grep { $c->req->param($_) } @keys) == @keys) { # form filled
        # fill current data
        $c->fillin_form($c->req);

        my $diff = CPANDiff::Diff->new(
            map { $_ => scalar($c->req->param($_)) } @keys
        );

        return $c->render('index.tt', { diff => $diff });
    } else {
        # sample input data
        $c->fillin_form(+{
            src_author  => 'MIYAGAWA',
            src_release => 'RPC-XML-Parser-LibXML-0.04',

            dst_author  => 'TOKUHIROM',
            dst_release => 'RPC-XML-Parser-LibXML-0.07',
        });

        return $c->render('index.tt');
    }
};

1;
