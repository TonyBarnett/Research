<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="html" indent="yes"/>

  <xsl:template name="BuildFormJavascript">

    <xsl:value-of select="$NewLine"/>
    <script type="text/javascript">

      var buildFormValidation = function() {
        <xsl:call-template name="InitializeFormValidation"/>
      }

      startFormAccordian = function() {
        <xsl:if test="count(//PageItem[bitIsVisible='true' or count(bitIsVisible) = 0])>1 and /PageXml/Header/UseAccordian='true'">
          if (!Browser.ie6){ // IE 6 cannot cope with rendering the accordion.
          var accordian = new Fx.Accordion($('pageItems'), '#pageItems h3', '#pageItems .pageItemBody', {show: <xsl:value-of select="/PageXml/Header/PageItemToShow - count(//PageItem[bitIsVisible='false' and lngPosition &lt; /PageXml/Header/PageItemToShow])"/>});
          accordian.addEvent('active', function(toggler, el) {
          toggler.addClass('activeheader');
          });

          accordian.addEvent('background', function(toggler, el) {
          toggler.removeClass('activeheader');
          });
          }
        </xsl:if>
      }

      var buildAutocompleteTextboxes = function() {
        <xsl:call-template name="SetupAutocompleteBoxes"/>
      }

    </script>
    <xsl:value-of select="$NewLine"/>

    <xsl:call-template name="BuildHelp"/>

    <xsl:value-of select="$NewLine"/>
    <div id="AjaxForm" class="popup" style="display:none;">
      <div id="AjaxFormConainer" class="popupContainer">
        <div id="CloseAjaxForm" class="closePopup">Close</div>
        <div id="AjaxFormContent">
          &#160;
        </div>
      </div>
    </div>
    <xsl:value-of select="$NewLine"/>
  </xsl:template>

  <xsl:template name="InitializeFormValidation">
    <xsl:for-each select="//PageItem/Form">
      <xsl:value-of select="$NewLine"/>
      <xsl:value-of select="concat('new FormCheck(', $apostrophe, 'Form', lngFormId, $apostrophe, ', {display: {showErrors: 1, addClassErrorToField: 1, addClassSucessToField: 1}}); ')"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="SetupAutocompleteBoxes">
      <xsl:for-each select="//PageItem/Form/Fieldset/FormElement">
        <xsl:if test="strType='Autocomplete Textbox'">
          <xsl:value-of select="$NewLine"/>
          var tokens = [<xsl:for-each select="MultipleChoiceItem">
            <xsl:value-of select="concat($speechmark, strValue, $speechmark, ', ')"/>
          </xsl:for-each>];
          <xsl:value-of select="$NewLine"/>
          new Autocompleter.Local('<xsl:value-of select="strName"/>', tokens, {
            'minLength': 1,
            'selectMode': 'type-ahead',
            'multiple': false
          });
          <xsl:value-of select="$NewLine"/>
        </xsl:if>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="BuildHelp">
    <xsl:for-each select="//PageItem/Form/Fieldset/FormElement">
      <xsl:if test="strHelp != ''">
        <xsl:value-of select="$NewLine"/>
        <div style="display: none;">
          <xsl:attribute name="id">
            <xsl:value-of select="concat('helpFor', strName)"/>
          </xsl:attribute>
          <xsl:value-of select="strHelp" disable-output-escaping="yes"/>
        </div>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>