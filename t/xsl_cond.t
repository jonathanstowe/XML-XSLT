
use Test::Most tests => 49;
use strict;
use warnings;

our $DEBUGGING = 0;

use_ok('XML::XSLT');

# element tests
lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title='foo'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title='foo'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>foo</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node string eq";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title != 'foo'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title != 'foo'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>bar</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node string ne";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title &lt; 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title &lt; 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>a</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr,  $correct, "got expected output";
} "text node string lt";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title > 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title > 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>c</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node string gt";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title >= 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title >= 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>c</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node string ge";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title &lt;= 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title &lt;= 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>b</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr , $correct, "got expected output";
} "text node string le";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title = 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title = 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>42</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr,  $correct, "got expected output";
} "text node numeric eq";


lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title != 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title != 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>43</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node numeric ne";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title &lt; 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title &lt; 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>41</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node numeric lt";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title > 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title > 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>43</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node numeric gt";


lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title >= 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title >= 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>43</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node numeric ge";

lives_ok {
   my $parser =  XML::XSLT->new (<<EOS, debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="title &lt;= 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="title &lt;= 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p><title>41</title>some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "text node numeric le";

# attribute tests

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title='foo'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title='foo'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="foo">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute string eq";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title != 'foo'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title != 'foo'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="bar">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute string ne";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title &lt; 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title &lt; 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="a">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute string lt";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title > 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title > 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="c">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute string gt";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title >= 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title >= 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="c">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute string ge";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title &lt;= 'b'">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title &lt;= 'b'">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="b">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute string le";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title = 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title = 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="42">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute numeric eq";


lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title != 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title != 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="43">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute numeric ne";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title &lt; 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title &lt; 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="41">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute numeric lt";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title > 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title > 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="43">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute numeric gt";


lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title >= 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title >= 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="42">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute numeric ge";

lives_ok {
   my $parser =  XML::XSLT->new (<<'EOS', debug => $DEBUGGING);
<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="doc"><doc><xsl:apply-templates/></doc></xsl:template>
<xsl:template match="p"><xsl:choose>
 <xsl:when test="@title &lt;= 42">o</xsl:when>
 <xsl:otherwise>not ok</xsl:otherwise>
</xsl:choose><xsl:if test="@title &lt;= 42">k</xsl:if></xsl:template>
</xsl:stylesheet>
EOS

   $parser->transform(\<<EOX);
<?xml version="1.0"?><doc><p title="41">some random text</p></doc>
EOX

   my $outstr =  $parser->toString();

   warn $outstr if $DEBUGGING;


   my $correct = '<doc>ok</doc>';

   $parser->dispose();

   is $outstr, $correct, "got expected output";
} "attribute numeric le";

