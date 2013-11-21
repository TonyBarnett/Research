<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ms="urn:schemas-microsoft-com:xslt"
    xmlns:dt="urn:schemas-microsoft-com:datatypes"
>
  <xsl:output method="html" indent="yes"/>

  <!-- **** Include here references to any templates that your container will call via its strXslt field. -->

  <!-- C O N T A I N E R   T E M P L A T E -->
  <xsl:template name="Container">
    <!-- Unfortunately, we can't simply call the template named in the XSLT. -->
    <xsl:choose>
      <xsl:when test="Container/strXslt='ContainerTestTemplate'">
        <xsl:call-template name="ContainerTestTemplate"/>
      </xsl:when>
      <xsl:when test="Container/strXslt='ContainerForm'">
        <xsl:call-template name="ContainerForm"/>
      </xsl:when>
      <!-- **** Add your template to the choose here. -->
      <xsl:otherwise>
        <xsl:call-template name="ContainerDefault"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- T E S T   T E M P L A T E -->
  <xsl:template name="ContainerTestTemplate">
    <p>This is the container test template, which may be used to see whether a custom XSLT template is getting passed through.</p>
    <p>
      The value in the <code>strXslt</code> variable is:
      <code>
        <xsl:value-of select="Container/strXslt"/>
      </code>.
    </p>
  </xsl:template>

  <!-- D E F A U L T   T E M P L A T E -->
  <xsl:template name="ContainerDefault">
    <xsl:for-each select="Container">
      <xsl:variable name="ContainerId">
        <xsl:value-of select="lngContainerId"/>
      </xsl:variable>
      <div class="container">
        <xsl:value-of select="$NewLine"/>
        <xsl:if test="strTitle != ''">
          <h3>
            <xsl:if test="count(//PageItem[bitIsVisible='true'])>1 and /PageXml/Header/UseAccordian='true'">
              <xsl:attribute name="class">
                <xsl:value-of select="'accordion'"/>
                <xsl:if test="/PageXml/Header/PageItemToShow = ../lngPosition - 1">
                  <xsl:value-of select="' activeheader'"/>
                </xsl:if>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="strTitle" disable-output-escaping="yes"/>
          </h3>
        </xsl:if>
        <div class="pageItemBody">
          <xsl:if test="strHelp != ''">
            <span class="pageItemDescription information" style="display: block;">
              <img src="http://images.uk-plc.net/imagesuk/purchasing/binfo.gif" width="40px" height="38px" align="left"/>
              <span class="text" style="display: block;">
                <xsl:value-of select="strHelp" disable-output-escaping="yes"/>
              </span>
              <div class="clear">&#160;</div>
            </span>
          </xsl:if>
          <xsl:if test="count(strContents) = 0">
            <!-- If there is no contents then the elemnt is in fact absent. -->
            <div class="noRowsMessage">
              <xsl:value-of select="strNoContentsMessage" disable-output-escaping="yes"/>
            </div>
          </xsl:if>

          <div> <!-- To do (by someone who knows some XSLT): add the class(es) ContainerParameters[strName='CssClass']/strValue -->
            <xsl:attribute name="id">
              <xsl:value-of select="concat('Container', lngContainerId)"/>
            </xsl:attribute>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(ContainerParameter[strName='CssClass']/strValue)>0">
                  <xsl:value-of select="ContainerParameter[strName='CssClass']/strValue"/>
                </xsl:when>
                <xsl:otherwise>
                  generalText
                </xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>

            <xsl:value-of select="strContents" disable-output-escaping="yes"/>
          </div>

          <div class="clear">&#160;</div>
        </div>
        <xsl:value-of select="$NewLine"/>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!-- F O R M   C O N T A I N E R -->
  <xsl:template name="ContainerForm">
    <!-- Get the ID of the container we've been asked to render. -->
    <xsl:variable name="ContainerId">
      <xsl:value-of select="Container/lngContainerId"/>
    </xsl:variable>
    <xsl:for-each select="/PageXml/PageItemsData/Container[Id=$ContainerId]/PageXml/PageItem">
      <xsl:call-template name="Form"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
