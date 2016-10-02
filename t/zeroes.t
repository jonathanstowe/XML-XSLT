use Test::Most tests => 7;

use strict;
use warnings;

use_ok('XML::XSLT');

my $parser;

lives_ok { 
$parser = XML::XSLT->new (<<'EOS', warnings => 'Active');
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/"><d><xsl:apply-templates/></d></xsl:template>
<xsl:template match="p">0</xsl:template>
<xsl:template match="q"><xsl:text>0</xsl:text></xsl:template>
<xsl:template match="r"><xsl:value-of select="."/></xsl:template>
<xsl:template match="s"><d size="{@size}"><xsl:apply-templates /></d></xsl:template>
</xsl:stylesheet>
EOS
} "New from literal stylesheet";
ok($parser,"Parser is a defined value");

lives_ok {
$parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p /><q /><r>0</r><s size="0">0</s></doc>
EOX
} "transform a literal XML document";


my $outstr;
lives_ok {
    $outstr= eval { $parser->toString };
} "toString";


ok($outstr,"toString produced output");

my $correct='<d>000<d size="0">0</d></d>';

is( $outstr, $correct,"The expected output was produced");
