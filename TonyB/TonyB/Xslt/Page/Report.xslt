<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ms="urn:schemas-microsoft-com:xslt"
    xmlns:dt="urn:schemas-microsoft-com:datatypes"
>
  <xsl:output method="html" indent="yes"/>
  <!--<xsl:include href="PivotTable.xslt"/>-->

  <xsl:template name="Report">
    <xsl:for-each select="Report">

      <xsl:variable name="ReportId">
        <xsl:value-of select="lngReportId"/>
      </xsl:variable>

      <xsl:variable name="ThisReportInstanceId">
        <xsl:value-of select="/PageXml/ReportInstance[lngReportId=$ReportId]/lngId"/>
      </xsl:variable>

      <xsl:if test="count(//PageItemsData/Report[Id=$ReportId]/Row) > 0 or count(//PageItemsData/PivotTable[Id=$ReportId]/Row) > 0 or string-length(strNoRowMessage)>0 or count(//PageItemsData/ReportError[Id=$ReportId]/Error) > 0">
        <xsl:value-of select="$NewLine"/>
        <div class="tableArea">
          <xsl:value-of select="$NewLine"/>
          <xsl:value-of select="$NewLine"/>
          <h3>
            <xsl:value-of select="strTitle" disable-output-escaping="yes"/>
          </h3>
          <div class="pageItemBody">
            <xsl:if test="strHelp != ''">
              <span class="pageItemDescription information" style="display: block;">
                <xsl:call-template name="IncludeImage">
                  <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/binfo.gif'"/>
                  <xsl:with-param name="width" select="'40px'"/>
                  <xsl:with-param name="height" select="'38px'"/>
                  <xsl:with-param name="align" select="'left'"/>
                </xsl:call-template>
                <span class="text" style="display: block;">
                  <xsl:value-of select="strHelp" disable-output-escaping="yes"/>
                </span>
                <div class="clear">&#160;</div>
              </span>
            </xsl:if>

            <!--Report instance customisation links and instance header.-->

            <div class="linkArea">

              <!--Buttons to view each of the user's instances of this report.-->
              <xsl:if test="count(/PageXml/PageItemsData/ReportInstanceId) > 0">
                <!-- TO DO: change to dropdown. -->
                <xsl:for-each select="ReportInstance">
                  <xsl:variable name="ReportInstanceId">
                    <xsl:value-of select="lngReportInstanceId"/>
                  </xsl:variable>
                  <a class="button" target="_self" >
                    <xsl:attribute name="href">
                      <xsl:choose>
                        <xsl:when test="contains(/PageXml/Header/ThisPageUrl, '.aspx?') and contains(/PageXml/Header/ThisPageUrl, 'ReportInstanceId=')">
                          <xsl:value-of select="concat('/', /PageXml/Header/ThisPageUrl, '&amp;ReportInstanceIdChangeTo=', $ReportInstanceId)"/>
                        </xsl:when>
                        <xsl:when test="contains(/PageXml/Header/ThisPageUrl, '.aspx?')">
                          <xsl:value-of select="concat('/', /PageXml/Header/ThisPageUrl, '&amp;ReportInstanceId=', $ReportInstanceId)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="concat('/', /PageXml/Header/ThisPageUrl, '?ReportInstanceId=', $ReportInstanceId)"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="concat('/', /PageXml/Header/ThisPageUrl, '&amp;ReportInstanceIdChangeTo=', $ReportInstanceId)"/>
                    </xsl:attribute>
                    <xsl:value-of select="strName"/>
                  </a>
                </xsl:for-each>
              </xsl:if>

              <!--If we are looking at a report instance, then button to edit it.-->
              <xsl:if test="$ThisReportInstanceId != ''">
                <a class="button" target="_self" >
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat('/ReportGenerator.aspx?ReportGeneratorPage=EditReportInstance.aspx&amp;ReportID=',  $ReportId, '&amp;ReportInstanceId=', $ThisReportInstanceId, '&amp;ReportGeneratorReturnUrl=', /PageXml/Header/ThisPageUrlEncoded)"/>
                  </xsl:attribute>Edit customisation
                </a>
                <xsl:value-of select="$NewLine"/>
                <xsl:value-of select="$NewLine"/>
              </xsl:if>

              <!-- Button to manage the user's instances of this report. -->
              <a class="button" target="_self" >
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('ReportGenerator.aspx?ReportGeneratorPage=ManageReportInstance.aspx&amp;ReportID=', $ReportId, '&amp;ReportGeneratorReturnUrl=', /PageXml/Header/ThisPageUrlEncoded)"/>
                </xsl:attribute>Manage customisations
              </a>

              <!--Button to create a new customisation of this report.-->
              <a class="button" target="_self" >
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('/ReportGenerator.aspx?ReportGeneratorPage=CreateReportInstance.aspx&amp;ReportID=', $ReportId, '&amp;ReportGeneratorReturnUrl=', /PageXml/Header/ThisPageUrlEncoded)"/>
                </xsl:attribute>Create a new customisation
              </a>

              <!-- Welcome to string manipulation hell -->
              <!-- The idea is to get rid of the ReportInstanceId=[0-9]* bit of the url-->
              <xsl:variable name="after-string">
                <xsl:value-of select="substring-after(/PageXml/Header/ThisPageUrl, concat('ReportInstanceId=', $ThisReportInstanceId))" disable-output-escaping="yes"/>
              </xsl:variable>
              <xsl:variable name="before-string">
                <xsl:value-of select="substring-before(/PageXml/Header/ThisPageUrl, concat('ReportInstanceId=', $ThisReportInstanceId))" disable-output-escaping="yes"/>
              </xsl:variable>

              <xsl:variable name="absolute-url">
                <xsl:choose>
                  <!-- ends-with doesn't exist in xpath 1.0, it's only in xpath 2.0.  Instead we have to use substring and string-length. -->
                  <!-- N.B.: substring's positions are 1-based, for some inane reason. -->

                  <!-- If the before string ends with an &, get rid of it. -->
                  <xsl:when test="substring($before-string, string-length($before-string), 1)='&amp;'">
                    <xsl:value-of select="concat(substring($before-string, 1, string-length($before-string) - 1), $after-string)"/>
                  </xsl:when>

                  <!-- If the before string ends with a ? and the after string starts with a &, get rid of the & -->
                  <!-- Warning: This code path is currently untested -->
                  <xsl:when test="substring($before-string, string-length($before-string))='?' and starts-with($after-string, '&amp;')">
                    <xsl:value-of select="concat($before-string, substring($after-string, 2))"/>
                  </xsl:when>

                  <!-- Otherwise we should just have "blah.aspx?ReportInstanceId=whatever" so the after string should be empty.
                         We can just return the before string, perhaps without the question mark. -->
                  <!-- Warning: This code path is currently untested -->
                  <xsl:otherwise>
                    <xsl:value-of select="substring($before-string, 1, string-length($before-string) - 1)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <!--Button to view the full report.-->
              <!-- Only show when we're on a ReportInstance page -->
              <!--
              <xsl:if test="contains(/PageXml/Header/ThisPageUrl, 'ReportInstanceId')">
                <a class="button" target="_self" >
                  <xsl:attribute name="href">
                    <xsl:value-of select="$absolute-url"/>
                  </xsl:attribute>View full report
                </a>
              </xsl:if>
              -->

              <!-- Dropdown -->
              <form method="POST">
                <xsl:attribute name="action">
                  <xsl:value-of select="$absolute-url"/>
                </xsl:attribute>
                <select name="ReportInstanceId" autocomplete="off">
                  <option value="">View full report</option>
                  <xsl:for-each select="/PageXml/PageItemsData/ReportInstances/Instance">
                    <option>
                      <xsl:attribute name="value">
                        <xsl:value-of select="Id"/>
                      </xsl:attribute>
                      <xsl:value-of select="Name"/>
                    </option>
                  </xsl:for-each>
                </select>

                <input id="SubmitReportInstanceId" class="submit " type="submit" value="Submit" name="Submit"/>

              </form>

            </div>

            <!--If we are looking at a report instance, then show the Name and Notes header-->
            <xsl:if test="$ThisReportInstanceId != ''">
              <h3>
                <xsl:value-of select="/PageXml/ReportInstance[lngId=$ThisReportInstanceId]/strName" disable-output-escaping="yes"/>
              </h3>
              <xsl:if test="/PageXml/ReportInstance[lngId=$ThisReportInstanceId]/strNotes != ''">
                <span class="pageItemDescription information" style="display: block;">
                  <span class="text" style="display: block;">
                    <xsl:value-of select="/PageXml/ReportInstance[lngId=$ThisReportInstanceId]/strNotes" disable-output-escaping="yes"/>
                  </span>
                  <div class="clear">&#160;</div>
                </span>
              </xsl:if>
            </xsl:if>

            <xsl:if test="count(//PageItemsData/PivotTable[Id=$ReportId]) = 0 and count(//PageItemsData/Report[Id=$ReportId]) = 0">
              <div class="noRowsMessage">
                <xsl:value-of select="strNoRowMessage" disable-output-escaping="yes"/>
              </div>
            </xsl:if>


            <!--   G R A P H S   -->
            <!-- Compute the size of the graphs. -->

            <xsl:variable name="GraphWidth">
              <xsl:choose>
                <xsl:when test="count(//PageItemsData/Report[Id=$ReportId]/Graph) = 1">
                  <xsl:value-of select="960"/>
                </xsl:when>
                <xsl:when test="count(//PageItemsData/Report[Id=$ReportId]/Graph) = 3 or count(//PageItemsData/Report[Id=$ReportId]/Graph) > 4">
                  <xsl:value-of select="320"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="400"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="GraphHeight">
              <xsl:choose>
                <xsl:when test="count(//PageItemsData/Report[Id=$ReportId]/Graph) = 1">
                  <xsl:value-of select="480"/>
                </xsl:when>
                <xsl:when test="count(//PageItemsData/Report[Id=$ReportId]/Graph) = 3 or count(//PageItemsData/Report[Id=$ReportId]/Graph) > 4">
                  <xsl:value-of select="320"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="400"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!-- Render the graphs. -->
            <xsl:for-each select="//PageItemsData/Report[Id=$ReportId]/Graph">
              <xsl:variable name="GraphId">
                <xsl:value-of select="@id"/>
              </xsl:variable>

              <div>
                <xsl:attribute name="style">
                  width:<xsl:value-of select="$GraphWidth"/>px; float: left;
                </xsl:attribute>
                <div>
                  <xsl:attribute name="id">
                    <xsl:value-of select="concat('Graph', $GraphId)"/>
                  </xsl:attribute>
                  <xsl:attribute name="style">
                    width:<xsl:value-of select="$GraphWidth"/>px; height:<xsl:value-of select="$GraphHeight"/>px;
                  </xsl:attribute>
                </div>
                <p>
                  <xsl:value-of select="//PageItem/Report[lngReportId=$ReportId]/ReportGraph[lngGraphId=$GraphId]/strTitle"/>
                </p>
              </div>
              <xsl:choose>
                <xsl:when test="@library='ofc'">
                  <script type="text/javascript">
                    <!-- The swf only works if it is in the same domain as the website. -->
                    //swfobject.embedSWF("http://static.uk-plc.net/ukplc/flash/page/open-flash-chart.swf", "<xsl:value-of select="concat('Graph', $GraphId)"/>", "900", "600", "9.0.0", "expressInstall.swf", {"get-data":"ofc_get_data", "id":"Graph<xsl:value-of select="$GraphId"/>", "loading":"SpendInsight is loading your data..."});
                    swfobject.embedSWF("/open-flash-chart.swf", "<xsl:value-of select="concat('Graph', $GraphId)"/>", "<xsl:value-of select="$GraphWidth"/>", "<xsl:value-of select="$GraphHeight"/>", "9.0.0", "expressInstall.swf", {"get-data":"ofc_get_data_<xsl:value-of select="$GraphId"/>", "id":"Graph<xsl:value-of select="$GraphId"/>", "loading":"SpendInsight is loading your data..."});
                  </script>

                  <script type="text/javascript">
                    var ofc_data_<xsl:value-of select="$GraphId"/> = <xsl:value-of select="Json"/>;

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
            <xsl:choose>
              <xsl:when test="count(//PageItemsData/PivotTable[Id=$ReportId]) > 0">
                <!--   P I V O T   T A B L E   -->
                <xsl:call-template name="PivotTable">
                  <xsl:with-param name="TableId" select="$ReportId"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="count(//PageItemsData/Report[Id=$ReportId]) > 0">
                <xsl:variable name="reorderable" select="bitReportReorderable"/>
                <!--   T A B L E   -->
                <table class="datatable" align="left">
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="$reorderable='true'">
                        <xsl:value-of select="'datatable reorderable'"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'datatable'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <tbody>
                    <xsl:attribute name="id">
                      <xsl:value-of select="concat('tableBody', lngReportId)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$NewLineOneTab"/>
                    <tr class="tableheader">
                      <th class="rownumber" style="display:none"></th>

                      <!-- customise table header if this is a report instance-->
                      <xsl:choose>
                        <xsl:when test="count(/PageXml/PageItemsData/ReportInstanceId) > 0">
                          <xsl:for-each select="/PageXml/Page/PageColumn/PageItem[lngChildId=$ReportId]/Report/ReportColumn">
                            <xsl:sort select="lngPosition" data-type="number"/>
                            <xsl:value-of select="$NewLineTwoTabs"/>
                            <xsl:choose>
                              <xsl:when test="strType!='Hidden' and strType !='Css Class'">
                                <th>
                                  <xsl:value-of select="strLabel" disable-output-escaping="yes"/>
                                </th>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:for-each>

                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:for-each select="ReportColumn">
                            <xsl:sort select="lngColumnIndex" data-type="number"/>
                            <xsl:value-of select="$NewLineTwoTabs"/>
                            <xsl:choose>
                              <xsl:when test="strType!='Hidden' and strType !='Css Class'">
                                <th>
                                  <xsl:value-of select="strLabel" disable-output-escaping="yes"/>
                                </th>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:for-each>

                        </xsl:otherwise>
                      </xsl:choose>

                    </tr>
                    <xsl:for-each select="//PageItemsData/Report[Id=$ReportId]/Row">
                      <xsl:if test="count(preceding-sibling::Row) &lt; /PageXml/ReportInstance/lngMaximumRows
                                    or not (/PageXml/ReportInstance/lngMaximumRows)">
                        <xsl:value-of select="$NewLineOneTab"/>
                        <tr>
                          <xsl:if test="count(CssClass) > 0">
                            <xsl:attribute name="class">
                              <xsl:value-of select="CssClass"/>
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:call-template name="RenderRow"/>
                        </tr>
                      </xsl:if>
                    </xsl:for-each>
                  </tbody>
                </table>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="/PageXml/PageItemsData/ReportError/Error">
                  <xsl:value-of select="Message"/>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
            <div class="clear">&#160;</div>
            <xsl:value-of select="$NewLine"/>
            <xsl:if test="count(TableLink) > 0">
              <div class="linkArea">
                <xsl:for-each select="TableLink">
                  <xsl:choose>
                    <xsl:when test="string-length(strLink)=0">
                      <span>
                        <xsl:attribute name="class">
                          <xsl:value-of select="strCssClass"/>
                        </xsl:attribute>
                        <xsl:value-of select="strLinkText" disable-output-escaping="yes"/>
                      </span>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="strLink" disable-output-escaping="yes"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </div>
            </xsl:if>
          </div>
          <xsl:value-of select="$NewLine"/>
        </div>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
