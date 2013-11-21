﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes"/>
  <xsl:include href="Page/Main.xslt"/>
  <xsl:include href="Page/PagePreview.xslt"/>

  <xsl:template match="/">

    <xsl:call-template name="Header"/>

    <xsl:call-template name="Body" />

    <xsl:call-template name="Preview" />

    <xsl:call-template name="Footer" />

  </xsl:template>

</xsl:stylesheet>