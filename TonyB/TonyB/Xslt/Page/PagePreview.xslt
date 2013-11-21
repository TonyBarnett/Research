<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="html" indent="yes"/>

    <xsl:template name="Preview">
      <xsl:if test="PageXml/Header/ShowPreview='true'">
        <xsl:value-of select="$NewLine"/>
        <h3>Preview</h3>
        <xsl:value-of select="$NewLine"/>
        <iframe width="100%" height="900px" id="previewIFrame">
          <xsl:attribute name="src">
            <xsl:value-of select="concat('AjaxPagePreview.aspx?PreviewProject=', PageXml/Header/CurrentProject, '&#38;PreviewPageName=', PageXml/Header/CurrentPageName, '&#38;PreviewFormId=', PageXml/Header/PreviewFormId)"/>
          </xsl:attribute>
        </iframe>
      </xsl:if>
      <xsl:value-of select="$NewLine"/>
    </xsl:template>
</xsl:stylesheet>