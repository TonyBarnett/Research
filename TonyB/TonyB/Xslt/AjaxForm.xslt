<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:import href="Page/Common.xslt" />
  <xsl:output method="html" indent="yes"/>
  <xsl:include href="Page/Form.xslt"/>
  <xsl:include href="Page/FormReadOnly.xslt"/>
  <xsl:include href="Page/FormJavascript.xslt"/>

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

  <xsl:template match="/">
    <xsl:call-template name="BuildHelp"/>
    <script type="text/javascript">
      var buildAjaxFormValidation = function() {
      <xsl:call-template name="InitializeFormValidation"/>
      }

      var buildAjaxFormAutocompleteTextboxes = function() {
      <xsl:call-template name="SetupAutocompleteBoxes"/>
      }
    </script>

    <xsl:if test="/PageXml/ErrorMessage != ''">
      <div class="error">
        <xsl:value-of select="/PageXml/ErrorMessage"/>
      </div>
    </xsl:if>

    <xsl:for-each select="/PageXml/PageItem">
      <xsl:call-template name="Form"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>