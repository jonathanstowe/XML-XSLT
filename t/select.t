#!/usr/bin/perl
# Test select/match with various special paths
# $Id: select.t,v 1.1 2004/02/18 08:34:38 gellyfish Exp $

use Test::More tests => 2;

use strict;
use vars qw($DEBUGGING);

$DEBUGGING = 0;

use_ok('XML::XSLT');


eval
{
  my $stylesheet =<<EOS;
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc">
  <out>
    <xsl:apply-templates select="processing-instruction()"/>
  </out>
</xsl:template>
                                                                                
<xsl:template match="processing-instruction()">
  <xsl:value-of select="."/>
</xsl:template>
</xsl:stylesheet>
EOS
                                                                                
  my $xml =<<EOX;
<?xml version="1.0"?>
<doc>
<?PITarget Processing-Instruction 1 type='text/xml'?>
</doc>
EOX
                                                                                
  my $parser = XML::XSLT->new(\$stylesheet,debug => $DEBUGGING);
                                                                                
  $parser->transform(\$xml);
                                                                                
  my $wanted = q%<out>Processing-Instruction 1 type='text/xml'</out>%;
  my $outstr =  $parser->toString;
  die "$outstr ne $wanted\n" unless $outstr eq $wanted;
};

print $@;
ok(!$@,"apply attribute set to xsl:copy");
