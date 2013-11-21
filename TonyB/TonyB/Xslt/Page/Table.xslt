<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ms="urn:schemas-microsoft-com:xslt"
    xmlns:dt="urn:schemas-microsoft-com:datatypes"
>
  <xsl:output method="html" indent="yes"/>
  <xsl:include href="PivotTable.xslt"/>

  <xsl:template name="Table">
    <!-- All of the decoration around the actual <table>. The <table> itself is in template TableTable -->
    <xsl:for-each select="Table">
      <xsl:variable name="TableId">
        <xsl:value-of select="lngTableId"/>
      </xsl:variable>
      <xsl:if test="count(//PageItemsData/Table[Id=$TableId]/Row) > 0 or count(//PageItemsData/PivotTable[Id=$TableId]/Row) > 0 or string-length(strNoRowMessage)>0">
        <xsl:value-of select="$NewLine"/>
        <div class="tableArea">
          <xsl:value-of select="$NewLine"/>
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
            <xsl:if test="bitDownloadable='true'">
              <div style="float: right;">
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat(/PageXml/Header/ThisPageUrl, '&amp;DownloadTableId=', $TableId, '|xls')"/>
                  </xsl:attribute>
                  <img alt="Download table contents as Excel." title="Download table contents as Excel.">
                    <xsl:attribute name="src">
                      <xsl:value-of select="concat(/PageXml/Header/Protocol, '://static.uk-plc.net/ukplc/images/icons/xls-16.png')"/>
                    </xsl:attribute>
                  </img>
                </a>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat(/PageXml/Header/ThisPageUrl, '&amp;DownloadTableId=', $TableId, '|csv')"/>
                  </xsl:attribute>
                  <img alt="Download table contents as CSV." title="Download table contents as CSV.">
                    <xsl:attribute name="src">
                      <xsl:value-of select="concat(/PageXml/Header/Protocol, '://static.uk-plc.net/ukplc/images/icons/txt-16.png')"/>
                    </xsl:attribute>
                  </img>
                </a>
              </div>
            </xsl:if>
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
            <xsl:if test="count(//PageItemsData/PivotTable[Id=$TableId]) = 0 and count(//PageItemsData/Table[Id=$TableId]) = 0">
              <div class="noRowsMessage">
                <xsl:value-of select="strNoRowMessage" disable-output-escaping="yes"/>
              </div>
            </xsl:if>

            <!--   G R A P H S   -->
            <!-- Compute the size of the graphs. -->

            <xsl:variable name="GraphWidth">
              <xsl:choose>
                <xsl:when test="count(//PageItemsData/Table[Id=$TableId]/Graph) = 1">
                  <!--<xsl:value-of select="960"/>-->
                  <xsl:value-of select="800"/>
                </xsl:when>
                <xsl:when test="count(//PageItemsData/Table[Id=$TableId]/Graph) = 3 or count(//PageItemsData/Table[Id=$TableId]/Graph) > 4">
                  <xsl:value-of select="320"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="400"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="GraphHeight">
              <xsl:choose>
                <xsl:when test="count(//PageItemsData/Table[Id=$TableId]/Graph) = 1">
                  <!--<xsl:value-of select="480"/>-->
                  <xsl:value-of select="400"/>
                </xsl:when>
                <xsl:when test="count(//PageItemsData/Table[Id=$TableId]/Graph) = 3 or count(//PageItemsData/Table[Id=$TableId]/Graph) > 4">
                  <xsl:value-of select="320"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="400"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!-- Render the graphs. -->
            <xsl:for-each select="//PageItemsData/Table[Id=$TableId]/Graph">
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
                  <xsl:value-of select="//PageItem/Table[lngTableId=$TableId]/TableGraph[lngGraphId=$GraphId]/strTitle"/>
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
              <xsl:when test="count(//PageItemsData/PivotTable[Id=$TableId]) > 0">
                <!--   P I V O T   T A B L E   -->
                <xsl:call-template name="PivotTable">
                  <xsl:with-param name="TableId" select="$TableId"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <!--   T A B L E   -->

                <xsl:variable name="PageItemId" select="lngChildId" />
                <xsl:choose>
                  <xsl:when test="count(//TableForm[lngTableId=$TableId]) > 0">
                    <!-- if we're part of a form, then emit the form header -->
                    <xsl:variable name="TableFormId">
                      <xsl:value-of select="//TableForm[lngTableId=$TableId]/lngFormId"/>
                    </xsl:variable>
                    <form>
                      <xsl:attribute name="action">
                        <xsl:value-of select="//PageItem/Form[lngFormId=$TableFormId]/strAction" />
                      </xsl:attribute>
                      <xsl:attribute name="method">
                        <xsl:value-of select="//PageItem/Form[lngFormId=$TableFormId]/strMethod" />
                      </xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="concat('Form', $TableFormId)" />
                      </xsl:attribute>
                      <xsl:attribute name="class">
                        <xsl:value-of select="concat('form singleFieldset', ' fieldsetCount', count(//PageItem/Form[lngFormId=$TableFormId]/Fieldset))"/>
                      </xsl:attribute>

                      <input type="hidden" name="ThisFormId" id="ThisFormId">
                        <xsl:attribute name="value">
                          <xsl:value-of select="$TableFormId"/>
                        </xsl:attribute>
                      </input>

                      <xsl:for-each select="//PageItem/Form[lngFormId=$TableFormId]/Fieldset/FormElement[strType!='Submit' and strType!='Select From Table']">
                        <xsl:call-template name="HiddenElement"/>
                      </xsl:for-each>

                      <!-- get on with the table (see you afterwards) -->
                      <xsl:call-template name="TableTable">
                        <xsl:with-param name ="TableId" select ="$TableId"/>
                      </xsl:call-template>

                      <div class="submitArea">
                        <xsl:for-each select="//PageItem/Form[lngFormId=$TableFormId]/Fieldset/FormElement[strType='Submit']">
                          <xsl:call-template name="SubmitElement"/>
                        </xsl:for-each>
                      </div>
                    </form>

                  </xsl:when>
                  <xsl:otherwise>
                    <!-- we're not in a form-->
                    <xsl:call-template name="TableTable">
                      <xsl:with-param name ="TableId" select ="$TableId"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:otherwise>
            </xsl:choose>
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

  <xsl:template name="TableTable">
    <xsl:param name ="TableId"/>
    <xsl:variable name="reorderable" select="bitTableReorderable"/>
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
          <xsl:value-of select="concat('tableBody', lngTableId)"/>
        </xsl:attribute>
        <xsl:value-of select="$NewLineOneTab"/>
          <xsl:for-each select="//PageItemsData/Table[Id=$TableId]/Totals">
            <tr class="tableTotals">
              <xsl:call-template name="RenderRow">
                <xsl:with-param name ="TableId" select ="$TableId"/>
              </xsl:call-template>
            </tr>
          </xsl:for-each>
        <xsl:value-of select="$NewLineOneTab"/>
        <tr class="tableheader">
          <th class="rownumber" style="display:none"></th>
          <!-- if we're part of a form, then leave space for checkbox -->
          <xsl:if test="count(//TableForm[lngTableId=$TableId]) > 0">
            <th>
              <div class="tableFormSelectAll">All</div>
              <div class="tableFormSelectNone">None</div>
            </th>
          </xsl:if>
          <!-- do the real table headers -->
          <xsl:for-each select="TableColumn">
            <xsl:sort select="lngColumnIndex" data-type="number"/>
            <xsl:value-of select="$NewLineTwoTabs"/>
            <xsl:choose>
              <xsl:when test="strType!='Hidden' and strType !='Css Class'">
                <th>
                  <xsl:value-of select="strLabel" disable-output-escaping="yes"/>
                  <xsl:if test="//PageItem/Table[lngTableId=$TableId]/bitDownloadable='true'">
                    <!-- can't do this because of when filtered table contains 2 rows!  and count(//PageItemsData/Table[Id=$TableId]/Row) > 2"> -->
                    <!-- Check that the column should be filterable. -->
                    <xsl:if test="strType = 'Currency' or strType = 'Date' or strType = 'Date Time' or strType = 'Number' or strType = 'Text'">
                      <img class="tableFilter" src="https://static.uk-plc.net/ukplc/images/filter.png">
                        <xsl:attribute name="id">
                          <xsl:value-of select="concat('Table', lngTableId, 'Column', lngColumnIndex)" />
                        </xsl:attribute>
                        <xsl:attribute name="class">
                          <xsl:value-of select="concat('tableFilter ', strType)" />
                        </xsl:attribute>
                      </img>
                    </xsl:if>
                  </xsl:if>
                </th>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </tr>
        <xsl:for-each select="//PageItemsData/Table[Id=$TableId]/Row">
          <xsl:value-of select="$NewLineOneTab"/>
          <tr>
            <xsl:if test="count(CssClass) > 0">
              <xsl:attribute name="class">
                <xsl:value-of select="CssClass"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="RenderRow">
              <xsl:with-param name ="TableId" select ="$TableId"/>
            </xsl:call-template>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
    <div class="clear">&#160;</div>
  </xsl:template>

  <xsl:template name="RenderRow">
    <xsl:param name ="TableId"/>
    <!-- this is nonsense -->
    <td class="rownumber" style="display:none">
      <xsl:value-of select="position()-1"/>
    </td>
    <!-- if we're part of a form then add a checkbox -->
    <xsl:if test="count(//TableForm[lngTableId=$TableId]) > 0">
      <xsl:variable name="TableFormColumnIndex">
        <xsl:value-of select="//TableForm[lngTableId=$TableId]/lngColumnIndex"/>
      </xsl:variable>
      <xsl:variable name="Value">
        <xsl:value-of select="self::node()/*[$TableFormColumnIndex]"/>
      </xsl:variable>
      <xsl:variable name="FormId">
        <xsl:value-of select="//TableForm[lngTableId=$TableId]/lngFormId"/>
      </xsl:variable>
      <xsl:variable name="FormElementName">
        <xsl:value-of select="//TableForm[lngTableId=$TableId]/strElementName"/>
      </xsl:variable>
      <xsl:variable name="Values">
        <xsl:value-of select="//PageItem/Form/Fieldset/FormElement[lngFormId=$FormId and strName=$FormElementName]/strValue"/>
      </xsl:variable>
      <td>
        <xsl:if test="name(.) != 'Totals'">
        <input type="checkbox">
          <xsl:attribute name="name">
            <xsl:value-of select="//TableForm[lngTableId=$TableId]/strElementName"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$Value"/>
          </xsl:attribute>
          <xsl:if test="starts-with($Values, concat($Value, ',')) or contains($Values, concat(',', $Value, ',')) or $Value = substring($Values, string-length($Values) - string-length($Value) +1)">
            <xsl:attribute name="checked">
              <xsl:value-of select="1"/>
            </xsl:attribute>
          </xsl:if>
        </input>
        </xsl:if>
      </td>
    </xsl:if>
    <!-- do the proper cells -->
    <xsl:for-each select="child::node()">
      <xsl:variable name="Position" select="position()-1"/>
      <!-- This is NOT the same value as "position()-1" 3 lines above. -->
      <xsl:if test="local-name(.)!='Hidden' and local-name(.)!='CssClass'">
        <xsl:if test ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment">
          <xsl:value-of select="$NewLineTwoTabs"/>
        </xsl:if>
        <td>
          <xsl:choose>
            <xsl:when test="local-name(.)='Image'">
              <img align="center" class="textCell numberCell">
                <xsl:attribute name="src">
                  <xsl:value-of select="." disable-output-escaping="yes"/>
                </xsl:attribute>
              </img>
            </xsl:when>
            <xsl:when test="local-name(.)='Number'">
              <div class="textCell numberCell">
                <xsl:choose>
                  <xsl:when test ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment">
                    <xsl:variable name ="Alignment" select ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment"/>
                    <xsl:attribute name ="align">
                      <xsl:value-of select="$Alignment"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="align">
                      <xsl:value-of select="'center'"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="." disable-output-escaping="yes"/>
              </div>
            </xsl:when>
            <xsl:when test="local-name(.)='Button'">
              <div class="buttonCell">
                <xsl:choose>
                  <xsl:when test ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment">
                    <xsl:variable name="Alignment" select ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment"/>
                    <xsl:attribute name="align">
                      <xsl:value-of select="$Alignment"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="align">
                      <xsl:value-of select="'center'"/>
                    </xsl:attribute>
                    <xsl:value-of select="." disable-output-escaping="yes"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </xsl:when>
            <xsl:when test="local-name(.)='Currency'">
              <div class="textCell currencyCell">
                <xsl:choose>
                  <xsl:when test ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment">
                    <xsl:variable name ="Alignment" select ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment"/>
                    <xsl:attribute name ="align">
                      <xsl:value-of select="$Alignment"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="align">
                      <xsl:value-of select="'right'"/>
                    </xsl:attribute>
                    <xsl:value-of select="." disable-output-escaping="yes"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </xsl:when>
            <xsl:when test="local-name(.)='Boolean'">
              <!-- This is awful. Links are created in C#, but we have to re-make them here so that we can put the icon in.-->
              <div class="booleanCell">
                <xsl:choose>
                  <xsl:when test ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment">
                    <xsl:variable name ="Alignment" select ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment"/>
                    <xsl:attribute name ="align">
                      <xsl:value-of select="$Alignment"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="align">
                      <xsl:value-of select="'center'"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <!-- Boolean with link. Hacjy! Re-construct the link and show the cross in the 'false' case. -->
                  <xsl:when test="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strLink != ''">
                    <xsl:value-of disable-output-escaping="yes" select="concat(substring-before(., '>'), '>')" />
                    <!-- the open a and href -->
                    <xsl:choose>
                      <xsl:when test="contains(., 'True')">
                        <xsl:call-template name="IncludeImage">
                          <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/etick.gif'"/>
                          <xsl:with-param name="alt" select="'True'"/>
                          <xsl:with-param name="align" select="'middle'"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:when test="contains(., 'False')">
                        <xsl:call-template name="IncludeImage">
                          <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/ecross.gif'"/>
                          <xsl:with-param name="alt" select="'False'"/>
                          <xsl:with-param name="align" select="'middle'"/>
                        </xsl:call-template>
                      </xsl:when>
                    </xsl:choose>
                    <xsl:text disable-output-escaping="yes">
	                    <![CDATA[</a>]]>
                  </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Show the tick for true, and nothing for false. -->
                    <xsl:if test="contains(., 'True')">
                      <xsl:call-template name="IncludeImage">
                        <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/etick.gif'"/>
                        <xsl:with-param name="alt" select="'True'"/>
                        <xsl:with-param name="align" select="'middle'"/>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <div>
                <xsl:choose>
                  <xsl:when test ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment">
                    <xsl:variable name ="Alignment" select ="/PageXml/Page/PageColumn/PageItem/Table[lngTableId=$TableId]/TableColumn[lngColumnIndex=$Position]/strAlignment"/>
                    <xsl:attribute name ="align">
                      <xsl:value-of select="$Alignment"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name ="align">
                      <xsl:value-of select ="'left'"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <span class="textCell">
                  <xsl:value-of select="." disable-output-escaping="yes"/>
                </span>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>