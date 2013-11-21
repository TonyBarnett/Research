<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ms="urn:schemas-microsoft-com:xslt"
    xmlns:dt="urn:schemas-microsoft-com:datatypes"
>
  <xsl:output method="html" indent="yes"/>
  <xsl:template name="Graph">
    <xsl:for-each select="Graph">
      <xsl:variable name="GraphId">
        <xsl:value-of select="lngGraphId"/>
      </xsl:variable>
<!-- TO DO: CHECK FOR TOO FEW POINTS. -->
      <div class="graph">
        <xsl:value-of select="$NewLine"/>
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
          <div class="noRowsMessage" style="display:none;">
            <xsl:value-of select="strTooFewPointsMessage" disable-output-escaping="yes"/>
          </div>

          <!-- Note: this bit is also in Table.xslt for rendering graphs that are associated to tables. -->
          
          <div>
            <xsl:attribute name="id">
              <xsl:value-of select="concat('Graph', lngGraphId)"/>
            </xsl:attribute>
              <!--<xsl:attribute name="style">width:960px; height:480px;</xsl:attribute>-->
              <xsl:attribute name="style">width:800px; height:400px;</xsl:attribute>
          </div>

          <xsl:for-each select="//PageItemsData/Graph[@id=$GraphId]">
            <xsl:choose>
              <xsl:when test="@library='ofc'">
                <script type="text/javascript">
                  <!-- The swf only works if it is in the same domain as the website. -->
                  //swfobject.embedSWF("http://static.uk-plc.net/ukplc/flash/page/open-flash-chart.swf", "<xsl:value-of select="concat('Graph', $GraphId)"/>", "900", "600", "9.0.0", "expressInstall.swf", {"get-data":"ofc_get_data", "id":"Graph<xsl:value-of select="$GraphId"/>", "loading":"SpendInsight is loading your data..."});
                  swfobject.embedSWF("/open-flash-chart.swf", "<xsl:value-of select="concat('Graph', $GraphId)"/>", "950", "400", "9.0.0", "expressInstall.swf", {"get-data":"ofc_get_data_<xsl:value-of select="$GraphId"/>", "id":"Graph<xsl:value-of select="$GraphId"/>", "loading":"SpendInsight is loading your data..."});
                </script>

                <script type="text/javascript">
                  var ofc_data_<xsl:value-of select="lngGraphId"/> = <xsl:value-of select="Json"/>;

                  function ofc_get_data_<xsl:value-of select="$GraphId"/>() {
                  return JSON.encode(ofc_data_<xsl:value-of select="$GraphId"/>);
                  }
                </script>
              </xsl:when>
              <xsl:when test="@library='flot'">
                <xsl:value-of select="Flot" disable-output-escaping="yes"/>
              </xsl:when>
              <xsl:otherwise>
                <p>Graph library not recognised.</p>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>

          <div class="clear">&#160;</div>
        </div>
        <xsl:value-of select="$NewLine"/>
      </div>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
