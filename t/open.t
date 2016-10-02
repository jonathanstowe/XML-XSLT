use strict;
use warnings;

use Test::Most tests => 2;
use XML::XSLT;

use FindBin qw($Bin);

my $xslt;

lives_ok {
 local $^W = 0; # don't understand the Expat warning yet
 $xslt = XML::XSLT->new(Source => "$Bin/test_data/open.xsl",debug => 0);
 $xslt->open_xsl("$Bin/test_data/open.xsl");
 $xslt->transform("$Bin/test_data/open.xml");
} "open_xsl";

TODO:
{
   local $TODO = "open_xsl() doesn't work a second time see https://github.com/jonathanstowe/XML-XSLT/issues/3";
   ok($xslt->toString,"open_xsl()");
}
