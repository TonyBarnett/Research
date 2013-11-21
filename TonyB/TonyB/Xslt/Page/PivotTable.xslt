<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:ms="urn:schemas-microsoft-com:xslt"
    xmlns:dt="urn:schemas-microsoft-com:datatypes"
>
  <xsl:output method="html" indent="yes" />

  <xsl:template name="PivotTable">
    <xsl:param name="TableId" />
    <table class="datatable" align="left">
      <thead>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('tableBody', lngTableId)" />
        </xsl:attribute>
        <xsl:value-of select="$NewLineOneTab" />
        <xsl:for-each select="//PageItemsData/PivotTable[Id=$TableId]/HeadingRow">
          <tr class="tableheader">
            <xsl:for-each select="./Heading">
              <th>
                <xsl:attribute name="colspan">
                  <xsl:value-of select="@colspan" />
                </xsl:attribute>
                <xsl:value-of select="." disable-output-escaping="yes" />
              </th>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </thead>
      <tbody>
        <xsl:for-each select="//PageItemsData/PivotTable[Id=$TableId]/Row">
          <xsl:value-of select="$NewLineOneTab" />
          <tr>
            <!-- heading cells -->
            <xsl:for-each select="./Heading">
              <th>
                <xsl:attribute name="rowspan">
                  <xsl:value-of select="@rowspan" />
                </xsl:attribute>
                <xsl:value-of select="." disable-output-escaping="yes" />
              </th>
            </xsl:for-each>
            <!-- data cells-->
            <xsl:for-each select="./Cell">
              <td>
                <xsl:value-of select="." disable-output-escaping="yes" />
              </td>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>
</xsl:stylesheet>