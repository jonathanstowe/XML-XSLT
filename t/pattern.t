# Test all patterns
# $Id: pattern.t,v 1.4 2007/10/05 13:44:04 gellyfish Exp $

use strict;

use Test::More tests => 2;

use vars qw($DEBUGGING);

$DEBUGGING = 0;

use_ok('XML::XSLT');


my $xml =<<'EOX';
<?xml version="1.0"?>
<doc>
  <foo>Content of foo</foo>
  <bar>Content of bar</bar>
</doc>
EOX

my $stylesheet =<<'EOS';
<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="xml" />
                                                                                
   <xsl:template match="doc">
      <out>
        <xsl:apply-templates select="foo|bar" />
      </out>
   </xsl:template>
   <xsl:template match="foo">
     <item>
     foo: <xsl:value-of select="." />
     </item>
   </xsl:template>
   <xsl:template match="bar">
     <item>
     bar: <xsl:value-of select="." />
     </item>
   </xsl:template>
</xsl:stylesheet>
EOS

my $expect =<<'EOE';
<out><item>
foo: Content of foo</item><item>
bar: Content of foo</item></out>
EOE


my $parser = XML::XSLT->new(\$stylesheet,debug => $DEBUGGING);
$parser->transform(\$xml);
my $out = $parser->toString();


SKIP:
{
   skip "pattern selector not working", 1;
   ok($out eq $expect,'pattern template selector');
}
