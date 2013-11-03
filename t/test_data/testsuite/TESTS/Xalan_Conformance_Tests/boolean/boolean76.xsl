<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- FileName: boolean76 -->
  <!-- Document: http://www.w3.org/TR/xpath -->
  <!-- DocVersion: 19991116 -->
  <!-- Section: 3.4 -->
  <!-- Creator: David Marston -->
  <!-- Purpose: Test != on two node-sets that have their only node in common. -->

<xsl:template match="doc">
  <out>
    <xsl:value-of select="j[@l='16'] != j[@w='78']"/>
  </out>
</xsl:template>

</xsl:stylesheet>