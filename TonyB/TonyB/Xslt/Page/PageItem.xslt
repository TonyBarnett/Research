<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes"/>
  <xsl:include href="Form.xslt"/>
  <xsl:include href="FormReadOnly.xslt"/>
  <xsl:include href="FormJavascript.xslt"/>
  <xsl:include href="Table.xslt"/>
  <xsl:include href="Tree.xslt"/>
  <xsl:include href="Graph.xslt"/>
  <xsl:include href="Report.xslt"/>
  <xsl:include href="ProcessWizard.xslt"/>
  <xsl:include href="Container.xslt"/>

  <xsl:template name="PageItems">

    <xsl:for-each select="/PageXml/Page/PageColumn">
      <div class="pageColumn">
        <xsl:attribute name="style">
          <xsl:value-of select="concat('width: ', 100 div count(/PageXml/Page/PageColumn), '%;')"/>
        </xsl:attribute>

        <!-- Show page notes. This is specific to Axiascope. -->
        <xsl:if test="count(/PageXml/PageNotes/PageNote) > 0">
          <div class="pageItem" id="PageNote">
            <h3>This page has <xsl:value-of select="count(/PageXml/PageNotes/PageNote)"/> notes attached to it.
            </h3>
            <xsl:for-each select="/PageXml/PageNotes/PageNote">
              <div class="noteHeader">
                <xsl:value-of select="strUsername"/> on <xsl:value-of select="strLastEdit"/> at <xsl:value-of select="strLastEditTime"/>:
                <xsl:if test="lngLoginId = /PageXml/Login/LoginId">
                  <a title="Delete this comment">
                    <xsl:attribute name="href">
                      <xsl:value-of select="concat('/Analysis/DataPack/Note.aspx?Action=Delete&amp;Id=', intId)"/>
                    </xsl:attribute>
                    <img style="border: 0;">
                      <xsl:attribute name="src">
                        <xsl:value-of select="concat(/PageXml/Header/Protocol, '://static.uk-plc.net/ukplc/images/delete.png')"/>
                      </xsl:attribute>
                    </img>
                  </a>
                </xsl:if>
                 <xsl:if test="lngLoginId = /PageXml/Login/LoginId">
                  <a title="Edit this comment">
                    <xsl:attribute name="href">
                      <xsl:value-of select="concat('/Analysis/DataPack/Note.aspx?Id=', intId)"/>
                    </xsl:attribute>
                    <img style="border: 0;">
                      <xsl:attribute name="src">
                        <xsl:value-of select="concat(/PageXml/Header/Protocol, '://static.uk-plc.net/ukplc/images/edit.png')"/>
                      </xsl:attribute>
                    </img>
                  </a>
                </xsl:if>
             <xsl:if test="string-length(strTableFilter) > 0">
                <a title="Apply the filter that was in effect at the time this comment was made.">
                  <xsl:attribute name="href">
                    <xsl:value-of select="strTableFilter"/>
                  </xsl:attribute>
                  <img style="border: 0;">
                    <xsl:attribute name="src">
                      <xsl:value-of select="concat(/PageXml/Header/Protocol, '://static.uk-plc.net/ukplc/images/filtered.png')"/>
                    </xsl:attribute>
                  </img>
                </a>
              </xsl:if>
              </div>
              <div class="noteBody">
                <xsl:value-of select="strNotes" disable-output-escaping="yes"/>
              </div>
            </xsl:for-each>
          </div>
        </xsl:if>

        <xsl:for-each select="PageItem[bitIsVisible='true' or count(bitIsVisible) = 0] ">
            <xsl:variable name="PageItemId" select="lngChildId" />
          <xsl:if test="count(//TableForm[lngFormId=$PageItemId]) = 0"><!-- If the form is a table multi-select, then it's the table that gets rendered (and decorated). -->
          <div class="pageItem">
            <xsl:choose>
              <xsl:when test="strChildType='Form'">
                <xsl:call-template name="Form"/>
                <xsl:call-template name="FormReadOnly"/>
              </xsl:when>
              <xsl:when test="strChildType='Table'">
                <xsl:call-template name="Table"/>
              </xsl:when>
              <xsl:when test="strChildType='Tree'">
                <xsl:call-template name="Tree"/>
              </xsl:when>
              <xsl:when test="strChildType='Graph'">
                <xsl:call-template name="Graph"/>
              </xsl:when>
              <xsl:when test="strChildType='Report'">
                <xsl:call-template name="Report"/>
              </xsl:when>
              <xsl:when test="strChildType='ProcessWizzard'">
                <xsl:call-template name="ProcessWizard"/>
              </xsl:when>
              <xsl:when test="strChildType='Container'">
                <xsl:call-template name="Container"/>
              </xsl:when>
            </xsl:choose>
	    <div class="clear"></div>
          </div>
          </xsl:if>
        </xsl:for-each>
      </div>
    </xsl:for-each>

    <xsl:if test="strLinkType='Under Page Items'">
      <a>
        <xsl:attribute name="class">
          <xsl:value-of select="strCssClass"/>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="strLink"/>
        </xsl:attribute>
        <xsl:value-of select="strLinkText"/>
      </a>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
