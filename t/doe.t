use strict;
use warnings;

use Test::Most tests => 7;
use_ok('XML::XSLT');

my $parser;

lives_ok { 
my $stylesheet =<<EOS;
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><d><xsl:value-of select="p" disable-output-escaping="yes"/></d><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><d><xsl:text disable-output-escaping="yes">&lt;&amp;</xsl:text></d><e><xsl:value-of select="."/></e><e>&lt;<xsl:text>&amp;</xsl:text></e></xsl:template>
</xsl:stylesheet>
EOS
  $parser = XML::XSLT->new($stylesheet,warnings => 'Active');
} "new from stylsheet text";

ok($parser,"new successful");

lives_ok {
$parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p>&lt;&amp;</p></doc>
EOX
} "transform xml";


my $outstr;
lives_ok { $outstr = $parser->toString } "toString works";

ok($outstr,"Output is expected");

my $correct='<doc><d><&</d><d><&</d><e>&lt;&amp;</e><e>&lt;&amp;</e></doc>';

is($outstr , $correct,"Output is what we expected it to be");
