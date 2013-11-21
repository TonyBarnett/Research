<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes" />

  <xsl:template name="FormReadOnly">
    <xsl:for-each select="Form[bitIsReadOnly='true']">
      <xsl:value-of select="$NewLine" />
      <xsl:variable name="Class">
        <xsl:choose>
          <xsl:when test="count(Fieldset)>1">
            <xsl:value-of select="'multipleFieldsets'" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'singleFieldset'" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <form>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('Form', lngFormId)" />
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('form ', $Class, ' fieldsetCount', count(Fieldset))" />
        </xsl:attribute>
        <h3>
          <xsl:if test="count(//PageItem)>1 and /PageXml/Header/UseAccordian='true'">
            <xsl:attribute name="class">
              <xsl:value-of select="'accordion'" />
              <xsl:if test="/PageXml/Header/PageItemToShow = ../lngPosition - 1">
                <xsl:value-of select="' activeheader'" />
              </xsl:if>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="strTitle" disable-output-escaping="yes" />
        </h3>
        <div class="pageItemBody">
          <xsl:if test="strHelp != ''">
            <span class="pageItemDescription information" style="display: block;">
              <xsl:call-template name="IncludeImage">
                <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/binfo.gif'" />
                <xsl:with-param name="width" select="'40px'" />
                <xsl:with-param name="height" select="'38px'" />
                <xsl:with-param name="align" select="'left'" />
              </xsl:call-template>
              <span class="text" style="display: block;">
                <xsl:value-of select="strHelp" disable-output-escaping="yes" />
              </span>
              <div class="clear">&#160;</div>
            </span>
          </xsl:if>

          <xsl:call-template name="ReadOnlyFieldsets" />
        </div>
        <xsl:value-of select="$NewLine" />
      </form>
      <xsl:value-of select="$NewLine" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="ReadOnlyFieldsets">
    <xsl:variable name="FieldsetCount" select="count(Fieldset)" />
    <xsl:for-each select="Fieldset">
      <xsl:value-of select="$NewLineOneTab" />
      <fieldset>
        <xsl:attribute name="class">
          <xsl:value-of select="concat(strCssClass, ' fieldset', position(), 'of', $FieldsetCount)" />
        </xsl:attribute>

        <xsl:if test="count(strTitle)> 0">
          <h3>
            <xsl:value-of select="strTitle" disable-output-escaping="yes" />
          </h3>
        </xsl:if>

        <xsl:for-each select="FormElement">
          <xsl:sort select="lngPosition" data-type="number" />
          <xsl:value-of select="$NewLineOneTab" />
          <div class="readOnlyFormElement">
            <xsl:attribute name="id">
              <xsl:value-of select="concat(strName,'ElementRow')" />
            </xsl:attribute>
            <xsl:call-template name="ReadOnlyFormElement" />
            <div class="clear"></div>
          </div>
        </xsl:for-each>
      </fieldset>
      <xsl:value-of select="$NewLineOneTab" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="ReadOnlyFormElement">
    <xsl:if test="strType != 'Message'">
      <input type="hidden">
        <xsl:attribute name="id">
          <xsl:value-of select="strName" />
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="strName" />
        </xsl:attribute>
        <xsl:attribute name="value">
          <xsl:value-of select="strValue" />
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:value-of select="strCssClass" />
        </xsl:attribute>
      </input>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="strType='Text' or strType='Autocomplete Textbox' or strType='Rich Text Editor' or strType='Textarea' or strType='Date' or strType='DateTime'">
        <xsl:choose>
          <xsl:when test="contains(strValidationClass, 'validate[' + $apostrophe + 'url' + $apostrophe + ']')">
            <xsl:call-template name="ReadOnlyLinkElement" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="ReadOnlyTextElement" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="strType='Dropdown' or strType='Radiobutton' or strType='Filtered List'">
        <xsl:call-template name="ReadOnlyMultipleChoiceElement" />
      </xsl:when>
      <xsl:when test="strType='Checkbox'">
        <xsl:call-template name="ReadOnlyCheckboxElement" />
      </xsl:when>
      <xsl:when test="strType='Message'">
        <xsl:call-template name="MessageElement" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ReadOnlyTextElement">
    <xsl:call-template name="LabelForReadOnlyElement" />
    <xsl:if test ="strType='Rich Text Editor'">
      <br/>
      <xsl:text  disable-output-escaping="yes"><![CDATA[
<div style='background:white;'>]]>
</xsl:text>
    </xsl:if>
    
    <span>
      <xsl:attribute name="id">
        <xsl:value-of select="concat(strName, '_readonly')" />
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('readOnlyFormValue ', strCssClass)" disable-output-escaping="yes" />
      </xsl:attribute>
      <xsl:value-of select="concat(strValue, '&#160;')" disable-output-escaping="yes" />
      &#160;
    </span>
    <xsl:if test ="strType='Rich Text Editor'">
      <xsl:text  disable-output-escaping="yes"><![CDATA[
    </div>]]></xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ReadOnlyLinkElement">
    <xsl:call-template name="LabelForReadOnlyElement" />
    <span>
      <xsl:attribute name="id">
        <xsl:value-of select="concat(strName, '_readonly')" />
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('readOnlyFormValue ', strCssClass)" disable-output-escaping="yes" />
      </xsl:attribute>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="concat(strValue, '&#160;')" disable-output-escaping="yes" />
        </xsl:attribute>
        <xsl:value-of select="concat(strValue, '&#160;')" disable-output-escaping="yes" />
      </a>
      &#160;
    </span>
  </xsl:template>

  <xsl:template name="ReadOnlyMultipleChoiceElement">
    <xsl:call-template name="LabelForReadOnlyElement" />
    <span class="readOnlyFormValue">
      <xsl:attribute name="id">
        <xsl:value-of select="concat(strName, '_readonly')" />
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('readOnlyFormValue ', strCssClass)" disable-output-escaping="yes" />
      </xsl:attribute>

      <xsl:variable name="Value" select="strValue" />
      <xsl:for-each select="MultipleChoiceItem[strValue=$Value]">
        <xsl:value-of select="strDescription" disable-output-escaping="yes" />
      </xsl:for-each>
      &#160;
    </span>
  </xsl:template>

  <xsl:template name="ReadOnlyCheckboxElement">
    <xsl:call-template name="LabelForReadOnlyElement" />
    <span>
      <xsl:attribute name="id">
        <xsl:value-of select="concat(strName, '_readonly')" />
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('readOnlyFormValue ', strCssClass)" disable-output-escaping="yes" />
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="strValue='1'">
          <xsl:call-template name="IncludeImage">
            <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/etick.gif'" />
            <xsl:with-param name="alt" select="'True'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="strValue='0'">
          <xsl:call-template name="IncludeImage">
            <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/ecross.gif'" />
            <xsl:with-param name="alt" select="'False'" />
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template name="LabelForReadOnlyElement">
    <xsl:if test="string-length(strLabel)> 0">
      <label class="formElementlabel">
        <span class="labelText">
          <xsl:value-of select="strLabel" disable-output-escaping="yes" />:
        </span>
      </label>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>