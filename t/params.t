
use strict;
use warnings;

use Test::Most tests => 7;
use_ok('XML::XSLT');

my $parser;
lives_ok
{
    $parser = XML::XSLT->new( <<'EOS', warnings => 'Active' );
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="a"><xsl:apply-templates>
  <xsl:with-param name="param1">value1</xsl:with-param>
</xsl:apply-templates></xsl:template>

<xsl:template match="b"><xsl:param name="param1">undefined</xsl:param>[ param1=<xsl:value-of select="$param1"/> ]</xsl:template>

</xsl:stylesheet>
EOS
}
"New from literal stylesheet";

ok( $parser, "Parser is defined" );

lives_ok
{
    $parser->transform( \<<EOX);
<?xml version="1.0"?><doc><a><b/></a><b/></doc>
EOX
}
"transform from on literal XML";

my $outstr;

lives_ok { $outstr = $parser->toString } "toString works";

ok( $outstr, "toString created output" );

my $correct = '[ param1=value1 ][ param1=undefined ]';

is( $correct, $outstr, "Output is as expected" );
