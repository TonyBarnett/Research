<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes"/>

    <xsl:include href="Main.xslt"/>
  <xsl:template match="/">
    <xsl:call-template name ="Header"/>
    <body>
    <xsl:for-each select ="//PageItem">
    <xsl:call-template name="Form"/>
    </xsl:for-each>
    </body>
    <xsl:call-template name ="Footer"/>
    </xsl:template>
</xsl:stylesheet>