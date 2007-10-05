use Test::More tests => 1;
use XML::XSLT;
use warnings;
use strict;

my $xslt = XML::XSLT->new ('tt.xsl',debug => 0);
$xslt->open_xsl('tt.xsl');
$xslt->transform('f.xml');

TODO:
{
   local $TODO = "open_xsl() doesn't work a second time";
   ok($xslt->toString,"open_xsl()");
}
