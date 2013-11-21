<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/PageXml/Menus">
    <xsl:if test="count(/PageXml/Header/HideMenu) = 0 or /PageXml/Header/HideMenu != 'true'">
      <xsl:value-of select="$NewLine"/>
      <div id="navigation">
        <ul id="nav">
          <xsl:apply-templates select="Menu"/>
        </ul>
      </div>
      <xsl:value-of select="$NewLine"/>
      <div class="breadcrumbs">
        <ul>
          <li class="first">You are here:</li>
          <xsl:for-each select="/PageXml/Breadcrumbs/Breadcrumb">
            <li>
              <xsl:choose>
                <xsl:when test="strLink!=''">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="strLink"/>
                    </xsl:attribute>
                    <xsl:if test="position()=last()">
                      <xsl:attribute name="class">
                        <xsl:value-of select="'last'"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="strName"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="strName"/>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:for-each>
        </ul>
        <div class="clear">&#160;</div>
      </div>
      <xsl:value-of select="$NewLine"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Menu">
    <xsl:value-of select="$NewLine"/>
    <xsl:if test="bitDisplayInMenu = 'true'">
      <li>
        <a>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="Menu[bitDisplayInMenu = 'true']">
                <xsl:value-of select="'mainMenuParentBtn'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'mainParentBtn'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="strLink!=''">
            <xsl:attribute name="href">
              <xsl:value-of select="strLink"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="strMenuText"/>
        </a>
        <xsl:if test="Menu[bitDisplayInMenu = 'true']">
          <div class="menuDiv">
            <ul>
              <xsl:apply-templates select="Menu"/>
            </ul>
          </div>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>