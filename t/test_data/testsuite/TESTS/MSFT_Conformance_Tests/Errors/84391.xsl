<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
          <xsl:for-each select="bookstore/book">
            <xsl:choose>
              <xsl:when test="@style='textbook'">
		<B><xsl:apply-templates/></B>
              </xsl:when>

              <xsl:otherwise>
	   <I><xsl:apply-templates/></I>
              </xsl:otherwise>

<xsl:include href="http://webxtest/testcases/books.xml"/>
            </xsl:choose>
          </xsl:for-each>
  </xsl:template>
   
  <xsl:template match="author">
          <xsl:value-of select="last-name"/>
  </xsl:template> 

</xsl:stylesheet>  
