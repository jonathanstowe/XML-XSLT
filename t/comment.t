use strict;
use warnings;

use Test::Most tests => 3;

our $DEBUGGING = 0;

use_ok('XML::XSLT');

lives_ok {
  my $stylesheet =<<EOS;
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:comment>Comment</xsl:comment></doc></xsl:template>
</xsl:stylesheet>
EOS

  my $xml =<<EOX;
<?xml version="1.0"?>
<doc>Foo</doc>  
EOX

  my $parser = XML::XSLT->new(\$stylesheet,debug => $DEBUGGING);

  $parser->transform(\$xml);

  my $wanted = '<doc><!--Comment--></doc>';
  my $outstr =  $parser->toString;
  is $outstr , $wanted, "got expected output";
} "Comment text as expected";
