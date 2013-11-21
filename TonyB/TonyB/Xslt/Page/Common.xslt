<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:variable name="NewLine">
    <xsl:text></xsl:text>
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
  <xsl:variable name="speechmark">"</xsl:variable>

  <xsl:template name="IncludeImage">
    <xsl:param name="src" />
    <xsl:param name="id" select="''" />
    <xsl:param name="alt" select="''" />
    <xsl:param name="align" select="''" />
    <xsl:param name="border" select="''" />
    <xsl:param name="class" select="''" />
    <xsl:param name="width" select="''" />
    <xsl:param name="height" select="''" />
    <xsl:param name="style" select="''" />
    <xsl:param name="title" select="''" />
    <xsl:param name="hspace" select="''" />

    <img>
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="/xml/PageXml/Header/Protocol">
            <xsl:value-of select="concat(/xml/PageXml/Header/Protocol, '://', $src)"/>
          </xsl:when>
          <xsl:when test="//PageXml/Protocol">
            <xsl:value-of select="concat(//PageXml/Protocol, '://', $src)"/>
          </xsl:when>
          <xsl:when test="/PageXml/Header/Protocol">
            <xsl:value-of select="concat(/PageXml/Header/Protocol, '://', $src)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(//Protocol, '://', $src)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$id!=''">
        <xsl:attribute name="id">
          <xsl:value-of select="$id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$alt!=''">
        <xsl:attribute name="alt">
          <xsl:value-of select="$alt"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$align!=''">
        <xsl:attribute name="align">
          <xsl:value-of select="$align"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$border!=''">
        <xsl:attribute name="border">
          <xsl:value-of select="$border"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$class!=''">
        <xsl:attribute name="class">
          <xsl:value-of select="$class"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$hspace!=''">
        <xsl:attribute name="hspace">
          <xsl:value-of select="$hspace"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$style!=''">
        <xsl:attribute name="style">
          <xsl:value-of select="$style"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$title!=''">
        <xsl:attribute name="title">
          <xsl:value-of select="$title"/>
        </xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>

  <xsl:template name="IncludeStylesheet">
    <xsl:param name="href" />
    <xsl:param name="media" select="''" />
    <xsl:param name="condition" select="''" />

    <xsl:choose>
      <xsl:when test="$condition = '!IE'">
        <xsl:value-of disable-output-escaping="yes" select="concat('&lt;![if ', $condition, ' ]&gt;')" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
      <xsl:when test="$condition != ''">
        <xsl:value-of disable-output-escaping="yes" select="concat('&lt;!--[if ', $condition, ' ]&gt;')" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="$condition = '!IE'">

      <!-- Newline character -->
    </xsl:if>
    <link rel="stylesheet" type="text/css">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="/xml/PageXml/Header/Protocol">
            <xsl:value-of select="concat(/xml/PageXml/Header/Protocol, '://', $href)"/>
          </xsl:when>
          <xsl:when test="//PageXml/Protocol">
            <xsl:value-of select="concat(//PageXml/Protocol, '://', $href)"/>
          </xsl:when>
          <xsl:when test="/PageXml/Header/Protocol">
            <xsl:value-of select="concat(/PageXml/Header/Protocol, '://', $href)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(//Protocol, '://', $href)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$media!=''">
        <xsl:attribute name="media">
          <xsl:value-of select="$media"/>
        </xsl:attribute>
      </xsl:if>
    </link>
    <xsl:text>&#xa;</xsl:text>
    <xsl:choose>
      <xsl:when test="$condition = '!IE'">
        <xsl:value-of disable-output-escaping="yes" select="'&lt;![endif]&gt;'" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
      <xsl:when test="$condition != ''">
        <xsl:value-of disable-output-escaping="yes" select="'&lt;![endif]--&gt;'" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="IncludeScript">
    <xsl:param name="src" />
    <xsl:param name="condition" select="''" />

    <xsl:choose>
      <xsl:when test="$condition = '!IE'">
        <xsl:value-of disable-output-escaping="yes" select="concat('&lt;![if ', $condition, ' ]&gt;')" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
      <xsl:when test="$condition != ''">
        <xsl:value-of disable-output-escaping="yes" select="concat('&lt;!--[if ', $condition, ' ]&gt;')" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
    </xsl:choose>

    <script type="text/javascript">
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="/xml/PageXml/Header/Protocol">
            <xsl:value-of select="concat(/xml/PageXml/Header/Protocol, '://', $src)"/>
          </xsl:when>
          <xsl:when test="//PageXml/Protocol">
            <xsl:value-of select="concat(//PageXml/Protocol, '://', $src)"/>
          </xsl:when>
          <xsl:when test="/PageXml/Header/Protocol">
            <xsl:value-of select="concat(/PageXml/Header/Protocol, '://', $src)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(//Protocol, '://', $src)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </script>
    <xsl:text>&#xa;</xsl:text>
    <xsl:choose>
      <xsl:when test="$condition = '!IE'">
        <xsl:value-of disable-output-escaping="yes" select="'&lt;![endif]&gt;'" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
      <xsl:when test="$condition != ''">
        <xsl:value-of disable-output-escaping="yes" select="'&lt;![endif]--&gt;'" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>