<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="Page/Main.xslt"/>

  <xsl:template match="/">

    <xsl:call-template name="Header"/>
    <style type="text/css">
      html {
      overflow: hidden !important;
      }

      html, body {
      height: 100% !important;
      margin: 0 !important;
      padding: 0 !important;
      }


      #frame-wrapper2 {
      min-height: 100%;
      height: auto !important;
      height: 100%;
      width: 100%;
      position: relative;
      margin: 0 !important;
      left: 0px;
      }

      #iframe2 {
      height: 100% !important;
      width: 100% !important;
      margin: 0 !important;
      padding: 0 !important;
      border:none;
      }

      #inner-wrapper2 {
      width: 100% !important;
      position: absolute;
      top: 0px;
      left: 0px;
      right: 0px;
      bottom: 150px;
      margin: 0 !important;
      padding: 0 !important;
      }
    </style>
    <xsl:text disable-output-escaping="yes">
      <![CDATA[
      <!--[if IE 7]>
         <style>
          #iframe2 {
            position: absolute;
            top: 0px;
            left: 0px;
            right: 0px;
            bottom: 0px;
            border:none;
          }
         </style>
      <![endif]-->
]]>
      </xsl:text>

    <div id="frame-wrapper2">
      <div id="inner-wrapper2">
        <iframe width="100%" height="100%" id="iframe2">
          <xsl:attribute name="src">
            <xsl:value-of select="concat(//PageXml/HeaderVariables[@Name='DataUploadUrl'], 'Workbook.aspx?WorkbookId=', //PageXml/HeaderVariables[@Name='WorkbookId'])"/>
          </xsl:attribute>
          Your browser does not support iframes.
        </iframe>
      </div>
    </div>

    <xsl:text disable-output-escaping="yes"> 
        <![CDATA[
      </body>
</html>
]]>
  </xsl:text>

  </xsl:template>

</xsl:stylesheet>
