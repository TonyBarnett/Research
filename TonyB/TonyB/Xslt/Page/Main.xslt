<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:import href="Common.xslt" />

  <xsl:output method="html" indent="yes"/>

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
  <xsl:variable name="speechmark">"</xsl:variable>

  <xsl:include href="Menu.xslt" />
  <xsl:include href="PageItem.xslt" />

  <xsl:template name="Header">

    <xsl:call-template name="HeaderHtml"/>

    <xsl:apply-templates select="PageXml/Menus"/>

    <!--If you run an iframe add SuppressCentralBoxHTML as a header variable (set to true) to suppress the menus and breadcrumbs-->
    <xsl:if test="count(/PageXml/Header/SuppressCentralBoxHTML) = 0 or /PageXml/Header/SuppressCentralBoxHTML!='true'">
      <xsl:text disable-output-escaping="yes">
        <![CDATA[
        <div id="content">
        ]]>
      </xsl:text>
    <h2>
      <xsl:value-of select="/PageXml/Page/strTitle"/>
      <xsl:if test="count(/PageXml/Header/DataPackId) > 0">
      <a style="float:right;" title="Add a note to this page.">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('/Analysis/DataPack/Note.aspx?Url=', /PageXml/Header/ThisPageCanonicalUrlEncoded, '&amp;TableFilter=', /PageXml/Header/ThisPageFiltersEncoded, '&amp;Title=', /PageXml/Page/strTitle, '&amp;DataPackId=', /PageXml/Header/DataPackId)"/>
      </xsl:attribute>
        <img style="border: 0;">
          <xsl:attribute name="src">
            <xsl:value-of select="concat(/PageXml/Header/Protocol, '://static.uk-plc.net/ukplc/images/edit.png')"/>
          </xsl:attribute>
        </img>
    </a></xsl:if>
    </h2>
    </xsl:if>
    
    <xsl:call-template name="Infobox"/>
    <xsl:call-template name="Messages"/>

    <div id="topOfPageLinks">
      <xsl:call-template name="PageLink">
        <xsl:with-param name="Location" select="'Top Of Page'"/>
      </xsl:call-template>
    </div>

    <xsl:if test="count(/PageXml/Page/PageLink[strLinkType='Menu Style'])>0">
      <div id="menuStyleLinks">
        <xsl:call-template name="PageLink">
          <xsl:with-param name="Location" select="'Menu Style'"/>
        </xsl:call-template>
      </div>
    </xsl:if>
    
    <xsl:call-template name="BuildFormJavascript"/>

  </xsl:template>

  <xsl:template name="Body">
    
    <div id="pageItems">
      <xsl:call-template name="PageItems" />
      <div class="clear">&#160;</div>
    </div>

    <xsl:call-template name="PageLink">
      <xsl:with-param name="Location" select="'Under Page Items'"/>
    </xsl:call-template>

    <xsl:call-template name="PageLink">
      <xsl:with-param name="Location" select="'Bottom Of Page'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="HeaderHtml">
    <xsl:text disable-output-escaping="yes">

	<![CDATA[
<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE html>

<html lang="EN">
    <head>]]>
    </xsl:text>
    <title>
<xsl:value-of select="/PageXml/Page/strTitle"/>
    </title>
    <xsl:text disable-output-escaping="yes"><![CDATA[
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

        <link rel="stylesheet" type="text/css" href="https://images.uk-plc.net/cssuk/page/otherpages.css" />
        <link rel="stylesheet" type="text/css" href="https://images.uk-plc.net/cssuk/page/main.css" />
        <link rel="stylesheet" type="text/css" href="https://images.uk-plc.net/cssuk/page/pages.css" />
        <link rel="stylesheet" type="text/css" href="https://images.uk-plc.net/cssuk/page/Autocompleter.css" />
        <!--link rel="stylesheet" type="text/css" href="https://images.uk-plc.net/cssuk/page/date-dropdown.css" /-->
        <link rel="stylesheet" type="text/css" media="screen" href="https://images.uk-plc.net/cssuk/page/datepicker_vista.css"/>
        <link rel="stylesheet" href="https://images.uk-plc.net/cssuk/formcheck/formcheck.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="https://static.uk-plc.net/ukplc/css/page/table.css"/>
        <link rel="stylesheet" href="https://static.uk-plc.net/ukplc/css/page/TableFilter.css"/>
        <link rel="stylesheet" href="https://static.uk-plc.net/ukplc/css/page/SelectFromTable.css"/>]]>
    </xsl:text>

    <xsl:for-each select="/PageXml/ExtraCss/CssFile">
      <xsl:value-of select="$NewLineTwoTabs"/>
      <link rel="stylesheet" type="text/css">
        <xsl:attribute name="href">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </link>
    </xsl:for-each>

    <xsl:text disable-output-escaping="yes">

	<![CDATA[
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/mootools-core-1.3-debug.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/mootools-more-1.3-debug.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/helper.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/formcheck/en.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/formcheck/formcheck.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/form.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/tree.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/datetime.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/page.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/filteredlist.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/table.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/tableFormSelect.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/customformvalidation.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/TableFilter.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/Autocomplete/Observer.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/Autocomplete/Autocompleter.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/Autocomplete/Autocompleter.Local.js"></script>
        <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/ckeditor-3.5/ckeditor.js"></script>
		<script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/swfobject.js"></script>

        <!--[if lte IE 8]>
            <link rel="stylesheet" type="text/css" media="screen" href="https://images.uk-plc.net/cssuk/purchasing/ie.css">
            <link rel="stylesheet" type="text/css" media="screen" href="https://images.uk-plc.net/cssuk/page/menunojs.css ">
        <![endif]-->

        <!--[if IE 6]>
            <link rel="stylesheet" type="text/css" media="screen" href="https://images.uk-plc.net/cssuk/purchasing/ie6.css">
        <![endif]-->

        <![if gt IE 8]>

            <link rel="stylesheet" type="text/css" media="screen" href="https://images.uk-plc.net/cssuk/page/menuwithjs.css ">
            <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/menumatic.js"></script>
        <![endif]>

        <![if !IE]>
            <link rel="stylesheet" type="text/css" media="screen" href="https://images.uk-plc.net/cssuk/page/menuwithjs.css ">
            <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/page/menumatic.js"></script>
        <![endif]>
]]>
    </xsl:text>

    <xsl:for-each select="/PageXml/ExtraJavascript/JavascriptFile">
      <xsl:value-of select="$NewLineTwoTabs"/>
      <script type="text/javascript">
        <xsl:attribute name="src">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </script>
    </xsl:for-each>

    <!-- JavaScript for graphs -->
    <xsl:if test="count(//Graph|//TableGraph) > 0">
      <xsl:text disable-output-escaping="yes">
<![CDATA[
      <!--[if lte IE 8]><script language="javascript" type="text/javascript" src="https://static.uk-plc.net/ukplc/js/jquery/excanvas.min.js"></script><![endif]-->
      <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/jquery/jquery.js"></script>
      <script type="text/javascript">
        var JQ = jQuery.noConflict();
      </script>
      <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/jquery/flot/jquery.flot.js"></script>
      <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/jquery/flot/jquery.flot.orderBars.js"></script>
      <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/jquery/flot/jquery.flot.tickrotor.js"></script>
      <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/jquery/flot/jquery.flot.pie.js"></script>
      <script type="text/javascript" src="https://static.uk-plc.net/ukplc/js/jquery/flot/jquery.flot.axislabels.js"></script>

<script type="text/javascript">
function flotShowTooltip(x, y, contents) {
    JQ('<div id="tooltip">' + contents + '</div>').css( {
        position: 'absolute',
        display: 'none',
        top: y - 20,
        left: x,
        border: '2px solid #036',
        padding: '2px',
        'background-color': '#E2ECF7',
		'font-size': '10pt',
        opacity: 0.80
    }).appendTo("body").fadeIn(500);
}
</script>

]]>
    </xsl:text>
    </xsl:if>

  <!-- ! ! !  S E T  J A V A S C R I P T   P A T H   F O R   W E B   R O O T ! ! !-->
    <xsl:text disable-output-escaping="yes">
	<![CDATA[
        <script type="text/javascript">
            var siteRoot = '/';

            buildFormValidation = function() {
              // Will be overridden to use.
            }

            buildAutocompleteTextboxes = function() {
              // Will be overridden to use.
            }

            window.addEvent('domready', function(){
                buildFormValidation();
                buildAutocompleteTextboxes();
           });
        </script>
    </head>

    <body id="body">
      <div id='blackout' style='display: none;'>
        &#160;
      </div>
      <div id='blackoutLevel2' style='display: none;'>
        &#160;
      </div>
      <div id='helpPopup' class='popup' style="display: none;">
        <div class="popupContainer">
          <div class="closePopup">Close</div>
            <div id='helpContents'>&#160;</div>
          </div>
        </div>

        <div id="TableFilter" style="display:none;">
        <!-- JS sets the HREFs when the div is summoned. -->
        <p><a href="" id="TableFilterUp"><img src="http://static.uk-plc.net/ukplc/images/filterOptionAscending.png" /><span>Sort A to Z</span></a></p>
        <p><a href="" id="TableFilterDown"><img src="http://static.uk-plc.net/ukplc/images/filterOptionDescending.png" /><span>Sort Z to A</span></a></p>
        <p><a href="" id="TableFilterClear"><img src="http://static.uk-plc.net/ukplc/images/filterOptionRemove.png" /><span>Remove</span></a></p>
        <div id="TableFilterMenu"></div>
        </div>

        <div id="TableFilterForm" style="display:none;">
<form action="" method="GET">
<input type="hidden" name="tableIdColumnIndex" id="TableFilterFormTableColumn" value="" />
<p><select name="filterType" id="TableFilterFormSelect1">
<option value="EQ">Equals...</option>
<option value="NE">Does not equal...</option>
<option value="BW">Begins with...</option>
<option value="EW">Ends with...</option>
<option value="CT">Contains...</option>
<option value="NC">Does not contain...</option>
<option value="GT">Greater than...</option>
<option value="GE">Greater than or equal to...</option>
<option value="LT">Less than...</option>
<option value="LE">Less than or equal to...</option>
</select><input type="text" size="16" id="TableFilterFormText1"/></p>

<p><input type="radio" id="TableFilterFormAnd" name="operator" value="and" class="radiobutton">And
<input type="radio" id="TableFilterFormOr" name="operator" value="or" class="radiobutton">Or</p>

<p><select name="filterType" id="TableFilterFormSelect2">
<option value=""/>
<option value="EQ">Equals...</option>
<option value="NE">Does not equal...</option>
<option value="BW">Begins with...</option>
<option value="EW">Ends with...</option>
<option value="CT">Contains...</option>
<option value="NC">Does not contain...</option>
<option value="GT">Greater than...</option>
<option value="GE">Greater than or equal to...</option>
<option value="LT">Less than...</option>
<option value="LE">Less than or equal to...</option>
</select><input type="text" size="16" id="TableFilterFormText2"/></p>
<p><input id="TableFilterFormSubmitButton" type="submit" class="submitbutton" value="OK"/><a class="button" id="TableFilterFormCancelButton">Cancel</a></p>
</form>
</div>

        <div id="header">
            <div class="top-tab">
                <a href="/Default.aspx?Action=logout" target="_top">Logout</a>
            </div>
            <div class="top-tab">
                <a href="/" target="_top">Home</a>
            </div>
]]>
    </xsl:text>
<!--
            <h1>
              Branding: <xsl:value-of select="/PageXml/Header/Domain"/>
            </h1>
            -->
            <div id="telephoneNumber">
                <div></div>
            </div>
   <xsl:text disable-output-escaping="yes">
	<![CDATA[</div>]]>
    </xsl:text>
  </xsl:template>

  <xsl:template name="PageLink">
    <xsl:param name="Location"/>
    <xsl:value-of select="$NewLine"/>
    <xsl:for-each select="PageXml/Page/PageLink[strLinkType=$Location]">
      <xsl:value-of select="$NewLineOneTab"/>
      <xsl:if test="count(strExplanation)>0 and strExplanation!=''">
        <div class="linkExplanation">
          <xsl:value-of select="strExplanation" disable-output-escaping="yes"/>
        </div>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="count(strCompleteLink)=0">
          <a>
            <xsl:attribute name="class">
              <xsl:value-of select="strCssClass"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="strLink"/>
            </xsl:attribute>
            <xsl:value-of select="strLinkText"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="strCompleteLink" disable-output-escaping="yes"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="count(strExplanation)>0 and strExplanation!=''">
        <div class="endOfLinkExplanation clear"></div>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="Footer">
    <xsl:if test="/PageXml/Header/ShowBackButton=true">
      <a class="button" onclick="history.back()">
        Go back
      </a>
    </xsl:if>

    <xsl:text disable-output-escaping="yes">
<![CDATA[
        </div>

        <script language="JavaScript" src="https://www.uk-plc.net/tracking/Tracking.aspx?CompanyID=1" type="text/javascript"></script>
        <!--div id="google_translate_element"></div>
        <script>
            var language = (navigator.language) ? navigator.language : navigator.userLanguage;
            if (language.toLowerCase().indexOf('en') != 0) {
              function googleTranslateElementInit() {
                new google.translate.TranslateElement({
                  pageLanguage: 'en',
                  layout: google.translate.TranslateElement.InlineLayout.SIMPLE
                }, 'google_translate_element');
              }
            }
        </script>
        <script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script-->
    </body>
</html>
]]>
  </xsl:text>
  </xsl:template>

  <xsl:template name="Infobox">
    <xsl:if test="/PageXml/Header/ShowHelp='true'">
      <xsl:if test="/PageXml/Page/strHelp!=''">
        <div class="information">
          <xsl:call-template name="IncludeImage">
            <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/help-icon.gif'" />
            <xsl:with-param name="width" select="'40px'" />
            <xsl:with-param name="height" select="'38px'" />
            <xsl:with-param name="align" select="'left'" />
          </xsl:call-template>
          <div class="text">
            <xsl:value-of select="/PageXml/Page/strHelp" disable-output-escaping="yes"/>
          </div>
          <div class="clear"></div>
        </div>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Messages">
    <div id="failureMessage">
      <xsl:if test="/PageXml/Header/ErrorMessage!=''">
        <p>
          <xsl:value-of select="/PageXml/Header/ErrorMessage" disable-output-escaping="yes" />
        </p>
      </xsl:if>
    </div>
    <span id="successMessage" style="filter:alpha(opacity=0); opacity:0;">
      <xsl:if test="/PageXml/Header/SuccessMessage!=''">
        <p>
          <xsl:value-of select="/PageXml/Header/SuccessMessage" disable-output-escaping="yes" />
        </p>
      </xsl:if>
    </span>
    <xsl:if test="/PageXml/Header/SuccessMessage!=''">
      <noscript>
        <xsl:value-of select="/PageXml/Header/SuccessMessage" disable-output-escaping="yes" />
      </noscript>
    </xsl:if>
  </xsl:template>

  <xsl:template name="IsolatedPageItem">
    <xsl:param name="Column" select="1"/>
    <xsl:param name="Position"/>

    <div class="pageColumn" style="width: 100%;">
      <xsl:for-each select="/PageXml/Page/PageColumn/PageItem[lngColumnNumber=$Column and lngPosition=$Position and (bitIsVisible='true' or count(bitIsVisible) = 0)]">
        <div class="pageItem">
          <xsl:choose>
            <xsl:when test="strChildType='Form'">
              <xsl:call-template name="Form" />
              <xsl:call-template name="FormReadOnly" />
            </xsl:when>
            <xsl:when test="strChildType='Table'">
              <xsl:call-template name="Table"/>
            </xsl:when>
	          <xsl:when test="strChildType='Report'">
              <xsl:call-template name="Report"/>
            </xsl:when>
          </xsl:choose>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

</xsl:stylesheet>