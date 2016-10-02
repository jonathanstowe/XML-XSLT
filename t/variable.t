#!/usr/bin/perl

use strict;
use warnings;

use Test::Most tests => 25;

our $DEBUGGING = 0;

use_ok('XML::XSLT');

# Test literal value in select

my $stylesheet = <<'EOS';
<?xml version="1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xsl:version="1.0">
  <xsl:output method="text" />
  <xsl:template match="/">
     <xsl:variable name="Test" select="'*This is a test*'" />
     <xsl:value-of select="$Test" />
  </xsl:template>
</xsl:transform>
EOS

my $xml = <<EOX;
<?xml version="1.0"?>
<foo />
EOX

my $correct = '*This is a test*';
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

my $outstr;

lives_ok
{
    ok $outstr = $parser->toString(), "got some output";
}
"toString works";

is( $outstr, $correct, "Output meets expectations - with toString" );

$stylesheet = <<'EOS';
<?xml version="1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xsl:version="1.0">
  <xsl:output method="text" />
  <xsl:template match="/">
     <xsl:variable name="Test">*This is a test*</xsl:variable>
     <xsl:value-of select="$Test" />
  </xsl:template>
</xsl:transform>
EOS

lives_ok
{
    ok $parser = XML::XSLT->new( \$stylesheet, debug => $DEBUGGING ), "got parser";
}
'Can parse template value as variable';

lives_ok
{
    $parser->transform( \$xml );
}
'transform';

lives_ok
{
    ok $outstr = $parser->toString(), "got some output";
}
'toString';

is( $outstr, $correct, 'Got expected output' );

$stylesheet = <<'EOS';
<?xml version="1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xsl:version="1.0">
  <xsl:output method="text" />
  <xsl:template match="/">
     <xsl:variable name="Test" select="foo/@attr" />
     <xsl:value-of select="$Test" />
  </xsl:template>
</xsl:transform>
EOS

$xml = <<EOX;
<?xml version="1.0"?>
<foo attr="*This is a test*" />
EOX

lives_ok
{
    ok $parser = XML::XSLT->new( \$stylesheet, debug => $DEBUGGING ), "got a parser";
}
'Can parse template';

lives_ok
{
    $parser->transform( \$xml );
}
'transform';

lives_ok
{
    ok $outstr = $parser->toString(), "got some output";
}
'got some output';

is( $outstr, $correct, 'Got expected output' );

lives_ok
{
    $stylesheet = <<'EOS';
<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
<xsl:param name='param1'/>
<xsl:param name='param2'/>
<xsl:template match='test'><p>param1 = <xsl:value-of select="$param1"/></p><p>param2 = <xsl:value-of select="$param2"/></p>
</xsl:template>
</xsl:stylesheet>
EOS

    $xml = <<EOX;
<?xml version='1.0' encoding='utf-8'?>
<doc><test comment='testing...'/></doc>
EOX

    $parser = XML::XSLT->new(
        $stylesheet,
        debug     => $DEBUGGING,
        variables => { param1 => "One", param2 => "Two" }
    );

    $parser->transform( \$xml );

    $outstr = $parser->toString();

    $correct = '<p>param1 = One</p><p>param2 = Two</p>';
    is $outstr , $correct, "got expected output";
}
"external variables work as expected";

$xml = <<EOX;
<?xml version='1.0' encoding='utf-8'?>
<doc></doc>
EOX

$stylesheet = <<'EOS';
<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

<xsl:variable name='param1' select="test"/>


<xsl:template match='doc'>
 <xsl:if test='$param1'>
  <p>param1 exists</p>
  <p>param1's value is: <xsl:value-of select='$param1'/></p>
  <xsl:if test="$param1 = 'test'">
   <p>param1 is equal to "test"</p>
  </xsl:if>
  <xsl:if test="$param1 != 'test'">
   <p>param1 is not equal to "test"</p>
  </xsl:if>
 </xsl:if>
</xsl:template>
</xsl:stylesheet>
EOS

lives_ok
{
    $parser = XML::XSLT->new( $stylesheet, debug => $DEBUGGING );

    $parser->transform( \$xml );

    $outstr = $parser->toString();

    $correct = q%<p>param1 exists</p><p>param1's value is: test</p><p>param1 is equal to "test"</p>%;
    is $outstr, $correct, "got expected output";
}
'Variables work in tests';

$xml = <<EOXML;
<?xml version="1.0" encoding="iso-8859-1"?>
<test/>
EOXML

$stylesheet = <<'EOXSLT';
<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="x" select="'foo'"/>
<xsl:template match="/">
<test><xsl:value-of select="$x"/></test>
</xsl:template>
</xsl:stylesheet>
EOXSLT

lives_ok
{
    my $xslt = new XML::XSLT( \$stylesheet, variables => { x => "bar" } );
    $xslt->transform( \$xml );
    my $out     = $xslt->toString();
    my $correct = '<test>bar</test>';
    is $out , $correct, "got expected output";
}
"ordering of parameters";
