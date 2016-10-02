use Test::Most tests => 11;

use strict;
use warnings;


our $DEBUGGING = 0;

use_ok('XML::XSLT');

# First example

my $stylesheet =<<EOS;
<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:output cdata-section-elements="example"/>

<xsl:template match="/">
<example>&lt;foo></example>
</xsl:template>
</xsl:stylesheet>
EOS

my $xml = '<doc />';

# this is not the same as that in the spec because of white space issues

my $expected =<<EOE;
<?xml version="1.0" encoding="UTF-8"?>
<example><![CDATA[<foo>]]></example>
EOE

chomp($expected);

my $parser;

lives_ok {
   $parser = XML::XSLT->new(\$stylesheet,debug => $DEBUGGING);
   ok $parser, "got a parser object" ;
} 'Can parse example stylesheet';

my $outstr;

lives_ok {
   $outstr = $parser->serve(\$xml,http_headers => 0);
   ok $outstr, "got output";
} 'serve produced output';

warn $outstr if $DEBUGGING;

is($outstr , $expected,'Matches output');

$parser->dispose();

# The data example - test 'Literal result as stylesheet'

$stylesheet =<<'EOS';
<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:output cdata-section-elements="example"/>

<xsl:template match="/">
<example><![CDATA[<foo>]]></example>
</xsl:template>
</xsl:stylesheet>
EOS

$expected =<<EOE;
<?xml version="1.0" encoding="UTF-8"?>
<example><![CDATA[<foo>]]></example>
EOE

chomp ($expected);

lives_ok {
   $parser = XML::XSLT->new(\$stylesheet,debug => $DEBUGGING);
   ok $parser, "got a parser"; 
} 'it can parse literal result';

lives_ok {
   $outstr = $parser->serve(\$xml,http_headers => 0);
   ok $outstr, "serve produced some output";
} 'serve lived';


is( $outstr ,$expected,'Preserves CDATA');

print $outstr if $DEBUGGING;
