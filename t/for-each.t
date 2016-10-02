use strict;
use warnings;

use Test::Most tests => 7;

our $DEBUGGING = 0;

use_ok('XML::XSLT');

lives_ok
{

    my $stylesheet = <<EOS;
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc">
<out>
    <xsl:for-each select="processing-instruction()">
     <pi><xsl:value-of select="." />
     </pi>
    </xsl:for-each>
</out>
</xsl:template>
</xsl:stylesheet>
EOS

    my $xml = <<EOX;
<?xml version="1.0"?>
<doc>
<?PITarget Processing-Instruction 1 type='text/xml'?>
<?PITarget Processing-Instruction 2 type='text/xml'?>
</doc>
EOX

    my $parser = XML::XSLT->new( \$stylesheet, debug => $DEBUGGING );

    $parser->transform( \$xml );

    my $wanted = q%<out><pi>Processing-Instruction 1 type='text/xml'</pi><pi>Processing-Instruction 2 type='text/xml'</pi></out>%;
    my $outstr = $parser->toString;
    is $outstr , $wanted, "got right output";
}
"select multiple processing-instruction()";

lives_ok
{
    my $stylesheet = <<EOS;
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc">
    <xsl:apply-templates select="comment()"/>
</xsl:template>
                                                                                
<xsl:template match="comment()">
  <out>
  <xsl:value-of select="."/>
  </out>
</xsl:template>
</xsl:stylesheet>
EOS

    my $xml = <<EOX;
<?xml version="1.0"?>
<doc>
<!-- TEST COMMENT -->
</doc>
EOX

    my $parser = XML::XSLT->new( \$stylesheet, debug => $DEBUGGING );

    $parser->transform( \$xml );

    my $wanted = q%<out> TEST COMMENT </out>%;
    my $outstr = $parser->toString;
    is $outstr , $wanted, "got required output";
}
"select single comment()";

lives_ok
{
    my $stylesheet = <<EOS;
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc">
    <xsl:apply-templates select="text()"/>
</xsl:template>
                                                                                
<xsl:template match="text()">
  <out>
   <xsl:value-of select="."/>
  </out>
</xsl:template>
</xsl:stylesheet>
EOS

    my $xml = <<EOX;
<?xml version="1.0"?>
<doc>TEST TEXT</doc>
EOX

    my $parser = XML::XSLT->new( \$stylesheet, debug => $DEBUGGING );

    $parser->transform( \$xml );

    my $wanted = q%<out>TEST TEXT</out>%;
    my $outstr = $parser->toString;
    is $outstr , $wanted, "got required output";
}
"select text()";
