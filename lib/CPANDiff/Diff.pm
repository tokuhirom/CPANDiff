use strict;
use warnings;
use utf8;

package CPANDiff::Diff;
use Smart::Args;
use Mouse;
use Text::Diff ();
use CPANDiff::API;

has src_author => (
    is => 'ro',
    required => 1,
);

has src_release => (
    is => 'ro',
    required => 1,
);

has dst_author => (
    is => 'ro',
    required => 1,
);

has dst_release => (
    is => 'ro',
    required => 1,
);

has src_files => (is => 'rw');
has dst_files => (is => 'rw');
has added => ( is => 'rw' );
has removed => ( is => 'rw' );
has duped => ( is => 'rw' );

sub BUILD {
    my $self = shift;

    my $api = CPANDiff::API->instance;
    my @src_files = sort $api->get_file_list(
        release => $self->src_release,
        author  => $self->src_author,
    );
    $self->src_files(\@src_files);
    my @dst_files = sort $api->get_file_list(
        release => $self->dst_release,
        author  => $self->dst_author,
    );
    $self->dst_files(\@dst_files);

    my @added = do {
        my %src = map { $_ => 1 } @src_files;
        grep { not exists $src{$_} } @dst_files;
    };
    $self->added(\@added);

    my @removed = do {
        my %dst = map { $_ => 1 } @dst_files;
        grep { not exists $dst{$_} } @src_files;
    };
    $self->removed(\@removed);

    my @duped = do {
        my %src = map { $_ => 1 } @src_files;
        grep { exists $src{$_} } @dst_files;
    };
    $self->duped(\@duped);
}

sub get_diff {
    my ($self, $path) = @_;

    my $api = CPANDiff::API->instance;
    my $src = $api->get_source(
        author  => $self->src_author,
        release => $self->src_release,
        path    => $path
    );
    my $dst = $api->get_source(
        author  => $self->dst_author,
        release => $self->dst_release,
        path    => $path
    );
    my $diff = Text::Diff::diff(\$src, \$dst);
    return $diff;
}

1;

