<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="Page/Main.xslt"/>

  <xsl:template match="/">

    <xsl:call-template name="HeaderHtml"/>

    <xsl:apply-templates select="PageXml/Menus"/>

    <xsl:text disable-output-escaping="yes">
        <![CDATA[
        <div id="content">
        ]]>
    </xsl:text>

    <h2>
      <xsl:value-of select="//PageXml/Page/strTitle"/>
    </h2>

    <div class="error">
      <img src="http://www.internaltest.uk-plc.net/test2/Purchasing/images/warn.gif"/>
      <xsl:value-of select="PageXml/Header/ErrorMessage"/>
    </div>
    
    <xsl:call-template name="Footer" />

  </xsl:template>

</xsl:stylesheet>
