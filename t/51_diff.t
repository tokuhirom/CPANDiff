use strict;
use warnings;
use utf8;
use Test::More;
use Test::LongString;

use CPANDiff::Diff;

my $diff = CPANDiff::Diff->new(
    src_author  => 'MIYAGAWA',
    src_release => 'RPC-XML-Parser-LibXML-0.04',

    dst_author  => 'TOKUHIROM',
    dst_release => 'RPC-XML-Parser-LibXML-0.07',
);
isa_ok $diff, 'CPANDiff::Diff';

is render($diff->added), 'inc/Module/Install/AuthorTests.pm, inc/Module/Install/ReadmeMarkdownFromPod.pm, inc/Module/Install/Repository.pm, inc/Pod/Markdown.pm, t/passwd, xt/97_podspell.t, xt/98_perlcritic.t, xt/99_pod.t', 'added';
is render($diff->removed), 'inc/Module/Install/Include.pm, inc/Module/Install/TestBase.pm, inc/Spiffy.pm, inc/Test/Base.pm, inc/Test/Base/Filter.pm, inc/Test/Builder.pm, inc/Test/Builder/Module.pm, inc/Test/More.pm, inc/YAML.pm', 'removed';
is render($diff->duped), 'Changes, MANIFEST, META.yml, Makefile.PL, README, inc/Module/Install.pm, inc/Module/Install/Base.pm, inc/Module/Install/Can.pm, inc/Module/Install/Fetch.pm, inc/Module/Install/Makefile.pm, inc/Module/Install/Metadata.pm, inc/Module/Install/Win32.pm, inc/Module/Install/WriteAll.pm, lib/RPC/XML/Parser/LibXML.pm, t/00_compile.t, t/RPC-XML-Parser-LibXML.t', 'duped';

is_string $diff->get_diff('Changes'), <<'...';
@@ -1,5 +1,23 @@
 Revision history for Perl extension RPC::XML::Parser::LibXML
 
+0.07
+
+    - do not use /etc/passwd for testing(tokuhirom)
+
+0.06
+
+        - Don't allow external entities to be injected
+          Bump LibXML to 1.70 (because we need to specify %param to new() and
+          LibXML changed that method signature in a recent version)
+          (yannk)
+
+0.05  Mon Sep 27 18:08:24 JST 2010
+
+        - Fixed a testing issue in dateTime.iso8601.
+          (Tokuhiro Matsuno)
+        - Depend to latest RPC::XML.
+          (Tokuhiro Matsuno)
+
 0.04  Fri Oct 24 17:59:12 PDT 2008
         - Fixed a bug where <value>foo</value> is not treated as <string> as in XMLRPC spec.
           (Benjamin Trott, Tatsuhiko Miyagawa)
...

done_testing;

sub render {
    my @args = @_==1 && ref($_[0]) eq 'ARRAY' ? @{$_[0]} : @_;
    join ', ', sort @args;
}

