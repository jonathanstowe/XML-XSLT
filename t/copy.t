#!/usr/bin/perl

use Test::Most tests => 3;

use strict;
use warnings;


our $DEBUGGING = 0;

use_ok('XML::XSLT');


lives_ok {
  my $stylesheet =<<EOS;
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="test">
<out><xsl:copy use-attribute-sets="set1"/></out>
</xsl:template>
                                                                                
<xsl:attribute-set name="set1">
  <xsl:attribute name="format">bold</xsl:attribute>
</xsl:attribute-set>
</xsl:stylesheet>
EOS
                                                                                
  my $xml =<<EOX;
<?xml version="1.0"?>
<doc><test>a</test></doc>
EOX
                                                                                
  my $parser = XML::XSLT->new(\$stylesheet,debug => $DEBUGGING);
                                                                                
  $parser->transform(\$xml);
                                                                                
  my $wanted = '<out><test format="bold"/></out>';
  my $outstr =  $parser->toString;
  is $outstr , $wanted, "got expected output";
} "apply attribute set to xsl:copy";
