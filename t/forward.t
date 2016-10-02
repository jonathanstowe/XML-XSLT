use strict;
use warnings;

our $DEBUGGING = 0;

use Test::Most tests => 12;

use_ok('XML::XSLT');

my $stylesheet = <<EOS;
<?xml version="1.0" ?>
<xsl:stylesheet version="17.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="system-property('xsl:version') >= 17.0">
         <xsl:some-funky-17.0-feature />
      </xsl:when>
      <xsl:otherwise>
        <html>
        <head>
          <title>XSLT 17.0 required</title>
        </head>
        <body>
          <p>Sorry, this stylesheet requires XSLT 17.0.</p>
        </body>
        </html>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
EOS

my $parser;

lives_ok
{
    $parser = XML::XSLT->new( \$stylesheet, debug => $DEBUGGING );
    ok $parser, "got a parser";
}
'Forward compatibility as per 1.1 Working Draft';

my $xml = '<doc>Test data</doc>';

my $outstr;

lives_ok
{
    $parser->transform($xml);
    ok $outstr = $parser->toString(), "got output";
}
'Check it can process this';

my $wanted = <<EOW;
<html><head><title>XSLT 17.0 required</title></head><body><p>Sorry, this stylesheet requires XSLT 17.0.</p></body></html>
EOW

chomp($wanted);

is( $outstr, $wanted, 'Check it makes the right output' );

$stylesheet = <<EOS;
<?xml version="1.0" ?>
<xsl:stylesheet version="18.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">   
  <xsl:some-18.0-feature />
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="system-property('xsl:version') &lt; 17.0">
        <xsl:message terminate="yes">
          <xsl:text>Sorry, this stylesheet requires XSLT 17.0.</xsl:text>
        </xsl:message>
      </xsl:when>
      <xsl:otherwise>
         <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
EOS

lives_ok
{
    $parser->dispose();
}
'dispose';

lives_ok
{
    ok $parser = XML::XSLT->new( \$stylesheet, debug => $DEBUGGING ), "got the parser";
}
'Another forward compat test';

lives_ok
{
    $parser->transform($xml);
    ok $outstr = $parser->toString(), "got output";
}
'Transform this';

$wanted = 'Test data';

chomp($wanted);

is( $outstr, $wanted, 'Check it makes the right output' );
