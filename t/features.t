use strict;
use warnings;

use Test::Most tests => 4;

use_ok('XML::XSLT');

my $sheet =<<EOS;
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">   
   <xsl:template match="/">
      <xsl:message terminate="yes">
         <xsl:text>Prepare to die!</xsl:text>
      </xsl:message>
  </xsl:template>
</xsl:stylesheet>
EOS

my $parser;

lives_ok {
   ok $parser = XML::XSLT->new(\$sheet), "get parser";
}  "Testing parse of <xsl:message> and <xsl:text>";

my $xml = '<data>foo</data>';

TODO:
{
  local $TODO = "Message not implemented";
  throws_ok {
    $parser->transform($xml);
  } "Message";
}
