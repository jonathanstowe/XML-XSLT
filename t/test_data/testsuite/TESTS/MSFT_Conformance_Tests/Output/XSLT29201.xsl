<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version="1.0">  
 
<xsl:output method="xml" encoding="foo"/>  
<xsl:template match="/">  
<xsl:copy-of select="/xslTutorial"/>  
</xsl:template>  

</xsl:stylesheet>  
