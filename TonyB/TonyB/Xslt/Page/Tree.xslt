<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes"/>

  <xsl:template name="Tree">
    <xsl:for-each select="Tree">
      <div class="treeArea">
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
          <div class="treeContainer">
            <div class="tree">
              <xsl:attribute name="id">
                <xsl:value-of select="concat('Tree', lngTreeId)"/>
              </xsl:attribute>
              <xsl:call-template name="CreateBranch">
                <xsl:with-param name="ParentId" select="''"/>
                <xsl:with-param name="TreeId" select="lngTreeId"/>
              </xsl:call-template>
              <div class="clear"></div>
            </div>
          </div>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="CreateBranch">
    <xsl:param name="ParentId"/>
    <xsl:param name="TreeId"/>

    <xsl:choose>
      <xsl:when test="count(/PageXml/PageItemsData/Tree[Id=$TreeId]/Node[(count(lngParentId) = 0 and $ParentId = '') or lngParentId=$ParentId])>0">
        <ul>
          <xsl:for-each select="/PageXml/PageItemsData/Tree[Id=$TreeId]/Node[(count(lngParentId) = 0 and $ParentId = '') or lngParentId=$ParentId]">
            <li>
              <xsl:attribute name="id">
                <xsl:value-of select="concat('treeNode', lngId)"/>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="count(strLink)=0 or strLink=''">
                  <span class="treeNode">
                    <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
                  </span>
                </xsl:when>
                <xsl:otherwise>
                  <a class="treeNode">
                    <xsl:attribute name="href">
                      <xsl:value-of select="strLink" disable-output-escaping="yes"/>
                    </xsl:attribute>
                    <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:call-template name="CreateBranch">
                <xsl:with-param name="TreeId" select="$TreeId"/>
                <xsl:with-param name="ParentId" select="lngId"/>
              </xsl:call-template>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$ParentId = ''">
          <!-- There are no nodes in the tree -->
          <div class="emptyTreeSpace clear"></div>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>