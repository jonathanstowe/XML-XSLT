<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="four-tag">
  From stylesheet final_included.xsl: <xsl:value-of select="self::node()"/>
</xsl:template>

</xsl:stylesheet>