use XML::XSLT;

print "1..1\n";

$xsl = q{<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <xsl:processing-instruction name="cml">version="1.0" encoding="ISO-8859-1"</xsl:processing-instruction>
    <![CDATA[<!DOCTYPE molecule SYSTEM "cml.dtd" []>]]>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="MOL">
    <molecule id="{@ID}">
      <xsl:apply-templates/>
    </molecule>
  </xsl:template>

  <xsl:template match="XVAR">
	<xsl:choose>
	  <xsl:when test="./[@BUILTIN='BOILINGPOINT']">
            <float title="BoilingPoint" units="degrees Celsius"><xsl:value-of select="."/></float>
	  </xsl:when>
	  <xsl:when test="./[@BUILTIN='MELTINGPOINT']">
            <float title="MeltingPoint" units="degrees Celsius"><xsl:value-of select="."/></float>
	  </xsl:when>
	</xsl:choose>
  </xsl:template>
</xsl:stylesheet>
};
$xml = q{<?xml version="1.0" encoding="ISO-8859-1"?>
<CML>
<MOL ID="95-48-7">
  <XVAR BUILTIN="BOILINGPOINT" UNITS="degrees Celsius">191.04</XVAR>
  <XVAR BUILTIN="MELTINGPOINT" UNITS="degrees Celsius">29.8</XVAR>
</MOL>
</CML>
};
$expected = q{
};

$p = XML::XSLT->new($xsl, "STRING");
$p->transform_document ($xml, "STRING");
$r = $p->result_string;

print "not "
  unless $r eq $expected;
print "ok 1\n";
warn $r;
