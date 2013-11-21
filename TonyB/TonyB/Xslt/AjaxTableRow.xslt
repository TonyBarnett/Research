<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:import href="Page/Common.xslt" />
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="Page/Table.xslt"/>
  <xsl:variable name="NewLine">
    <xsl:text>
</xsl:text>
  </xsl:variable>
  <xsl:variable name="NewLineOneTab">
    <xsl:text>
    </xsl:text>
  </xsl:variable>
  <xsl:variable name="NewLineTwoTabs">
    <xsl:text>
        </xsl:text>
  </xsl:variable>
  <xsl:variable name="apostrophe">'</xsl:variable>

  <xsl:template match="/">
    <xsl:for-each select="//IsolatedRow/Table/Row">
      <tr>
        <xsl:call-template name="RenderRow"/>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="//IsolatedTable">
      <xsl:call-template name="Table"/>
    </xsl:for-each>

    <xsl:if test="//ErrorMessage!=''">
      <xsl:comment>
        <xsl:value-of select="concat('ajax_error_message_start__', //ErrorMessage, '__ajax_error_message_end')" disable-output-escaping="yes" />
      </xsl:comment>
    </xsl:if>
    <xsl:if test="//SuccessMessage!=''">
      <xsl:comment>
        <xsl:value-of select="concat('ajax_success_message_start__', //SuccessMessage, '__ajax_success_message_end')" disable-output-escaping="yes" />
      </xsl:comment>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>