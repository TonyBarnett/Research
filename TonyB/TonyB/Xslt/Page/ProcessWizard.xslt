<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes"/>

  <xsl:template name="ProcessWizard">
    <xsl:for-each select="ProcessWizzard">
      <div class="ProcessWizard">
        <ul class="steps">
          <xsl:for-each select="ProcessWizzardStep">
            <xsl:sort select="lngPosition" data-type="number"/>
            <il class="step">
              <xsl:choose>
                <xsl:when test="Selected='true'">
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('step ', strCssClass)"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('step ', strCssClass)"/>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="HasLink='true'">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="strPageUrl"/>
                    </xsl:attribute>
                    <xsl:value-of select="lngPosition+1"/>. <xsl:value-of select="strName"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="lngPosition+1"/>. <xsl:value-of select="strName"/>
                </xsl:otherwise>
              </xsl:choose>
            </il>
          </xsl:for-each>
        </ul>
        <xsl:for-each select="ProcessWizzardStep[Selected='true']">
          <xsl:if test="strHelp">
            <div class="help">
              <xsl:value-of select="strHelp" disable-output-escaping="yes"/>
            </div>
          </xsl:if>
        </xsl:for-each>
      </div>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>