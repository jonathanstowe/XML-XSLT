use strict;
use warnings;

use Test::Most tests => 10;

our $DEBUGGING = 0;

use_ok('XML::XSLT');

my $stylesheet = <<EOS;
<?xml version="1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns="http://www.w3.org/TR/xhtml1/strict"
               version="1.0">

  <xsl:output method="xml"
       encoding="ISO-8859-1"
       doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
       indent="yes"/>

<xsl:template match="/">
<foo><xsl:apply-templates /></foo>
</xsl:template>
</xsl:transform>
EOS

my $xml = <<EOX;
<?xml version="1.0"?>
<foo>This is a test</foo>
EOX

my $parser;

lives_ok
{
    ok $parser = XML::XSLT->new( $stylesheet, debug => $DEBUGGING ), "got a parser";
}
"new from literal stylesheet";

lives_ok
{
    $parser->transform( \$xml );
}
"transform";

my $correct = "<foo>This is a test</foo>";

my $outstr;

warn $outstr if $DEBUGGING;

lives_ok
{
    ok $outstr = $parser->toString(), "got some output";
}
"toString works";

is( $outstr, $correct, "Output meets expectations - with toString" );

$correct = <<EOC;
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "">
<foo>This is a test</foo>
EOC

chomp($correct);

lives_ok
{
    ok $outstr = $parser->serve( \$xml, http_headers => 0 ), "serve with http_headers";
}
"serve(), works";

is( $outstr, $correct, "Output meets expectations with declarations" );

