<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="html" indent="yes"/>

  <xsl:template name="Form">
    <xsl:for-each select="Form[count(bitIsReadOnly) = 0 or bitIsReadOnly='false']">
      <xsl:value-of select="$NewLine"/>
      <xsl:variable name="Class">
        <xsl:choose>
          <xsl:when test="count(Fieldset) > 1">
            <xsl:value-of select="concat(strClass, ' multipleFieldsets')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(strClass, ' singleFieldset')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <form>
        <xsl:attribute name="action">
          <xsl:value-of select="strAction" />
        </xsl:attribute>
        <xsl:attribute name="method">
          <xsl:value-of select="strMethod" />
        </xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('Form', lngFormId)" />
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('form ', $Class, ' fieldsetCount', count(Fieldset))"/>
        </xsl:attribute>
        <xsl:if test="count(//FormElement[strType='File'])>0">
          <xsl:attribute name="enctype">
            <xsl:value-of select="'multipart/form-data'"/>
          </xsl:attribute>
        </xsl:if>
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
          <input type="hidden" name="ThisFormId" id="ThisFormId">
            <xsl:attribute name="value">
              <xsl:value-of select="lngFormId"/>
            </xsl:attribute>
          </input>

          <xsl:call-template name="Fieldsets"/>
        </div>
        <xsl:value-of select="$NewLine"/>
      </form>
      <xsl:value-of select="$NewLine"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="Fieldsets">

    <xsl:variable name="FieldsetCount" select="count(Fieldset)"/>
    <xsl:for-each select="Fieldset">
      <xsl:value-of select="$NewLineOneTab"/>
      <fieldset>
        <xsl:attribute name="class">
          <xsl:value-of select="concat(strCssClass, ' fieldset', position(), 'of', $FieldsetCount)"/>
        </xsl:attribute>

        <xsl:if test="count(strTitle) > 0">
          <h3>
            <xsl:value-of select="strTitle" disable-output-escaping="yes"/>
          </h3>
        </xsl:if>
        <xsl:for-each select="FormElement">
          <xsl:sort select="lngPosition" data-type="number"/>
          <xsl:value-of select="$NewLineOneTab"/>
          <xsl:variable name="CssClass">
            <xsl:if test="strType='Date' or strType='DateTime'">
              <xsl:value-of select="'date '"/>
            </xsl:if>
            <xsl:if test="strType='Rich Text Editor'">
              <xsl:value-of select="'richTextEditorElement '"/>
            </xsl:if>
          </xsl:variable>
          <div>
            <xsl:attribute name="class">
              <xsl:value-of select="concat(strRowCssClass, ' ', $CssClass, 'FormElement')"/>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat(strName,'ElementRow')"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="bitReadOnly='true'">
                <xsl:call-template name="ReadOnlyFormElement"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="FormElement"/>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </xsl:for-each>
      </fieldset>
      <xsl:value-of select="$NewLineOneTab"/>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="FormElement">
    <xsl:choose>
      <xsl:when test="strType='Text' or strType='Autocomplete Textbox'">
        <xsl:call-template name="TextElement"/>
      </xsl:when>
      <xsl:when test="strType='Password'">
        <xsl:call-template name="PasswordElement"/>
      </xsl:when>
      <xsl:when test="strType='Date'">
        <xsl:call-template name="DateElement"/>
      </xsl:when>
      <xsl:when test="strType='DateTime'">
        <xsl:call-template name="DateTimeElement"/>
      </xsl:when>
      <xsl:when test="strType='Dropdown'">
        <xsl:call-template name="DropdownElement"/>
      </xsl:when>
      <xsl:when test="strType='Checkbox'">
        <xsl:call-template name="CheckBoxElement"/>
      </xsl:when>
      <xsl:when test="strType='Radiobutton'">
        <xsl:call-template name="RadioButtonElement"/>
      </xsl:when>
      <xsl:when test="strType='Hidden'">
        <xsl:call-template name="HiddenElement"/>
      </xsl:when>
      <xsl:when test="strType='Textarea'">
        <xsl:call-template name="TextareaElement"/>
      </xsl:when>
      <xsl:when test="strType='Rich Text Editor'">
        <xsl:call-template name="RichTextEditorElement"/>
      </xsl:when>
      <xsl:when test="strType='Message'">
        <xsl:call-template name="MessageElement"/>
      </xsl:when>
      <xsl:when test="strType='Captcha'">
        <xsl:call-template name="CaptchaElement"/>
      </xsl:when>
      <xsl:when test="strType='File'">
        <xsl:call-template name="File"/>
      </xsl:when>
    <xsl:when test="strType='FileMulti'">
        <xsl:call-template name="FileMulti"/>
      </xsl:when>
      <xsl:when test="strType='Tree'">
        <xsl:call-template name="TreeElement"/>
      </xsl:when>
      <xsl:when test="strType='TreeCheckbox'">
        <xsl:call-template name="CheckboxTreeElement"/>
      </xsl:when>
      <xsl:when test="strType='Filtered List'">
        <xsl:call-template name="FilteredListElement"/>
      </xsl:when>
      <xsl:when test="strType='Multiple-Choice Checkboxes'">
        <xsl:call-template name="MultipleChoiceCheckboxElements"/>
      </xsl:when>
      <xsl:when test="strType='Submit'">
        <xsl:call-template name="SubmitElement"/>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="strValidationMessage!=''">
      <span class="validationMessage">
        <xsl:value-of select="strValidationMessage"/>
      </span>
    </xsl:if>

    <div class="displaynone customValidationMessage">
      <xsl:value-of select="FormElementValidation/strFailureMessage"/>
    </div>

  </xsl:template>

  <xsl:template name="TextElement">
    <xsl:call-template name="Label"/>
    <input type="text" autocomplete="off">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="strValue"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat(strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
    </input>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="CaptchaElement">
    <label>
      &#160;
      <xsl:if test="strValidationMessage!=''">
        <span class="mandatoryStar">
          <br></br>
          <xsl:value-of select="strValidationMessage"/>
        </span>
      </xsl:if>
    </label>
    <span style="float:left;">
      <span class="innocentLookingSpan">
        <xsl:value-of select="concat('&#160;', strLabel)"/>
      </span>
      <br/>
      <input type="text" autocomplete="off">
        <xsl:attribute name="id">
          <xsl:value-of select="strName"/>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="strName"/>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:value-of select="concat(strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
        </xsl:attribute>
      </input>
    </span>
  </xsl:template>

  <xsl:template name="PasswordElement">
    <xsl:call-template name="Label"/>
    <input type="password" autocomplete="off">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="strValue"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat(strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
    </input>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="DateElement">
    <xsl:call-template name="Label"/>
    <input type="text" autocomplete="off">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:choose>
          <xsl:when test="strValue=''">
            <xsl:value-of select="'DD/MM/YYYY'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="strValue"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('dateInput ', strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
    </input>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="DateTimeElement">
    <xsl:call-template name="Label"/>
    <input type="text" autocomplete="off">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:choose>
          <xsl:when test="strValue=''">
            <xsl:value-of select="'DD/MM/YYYY HH:MM'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="strValue"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('dateTimeInput ', strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
    </input>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="CheckBoxElement">
    <div class="radio">
      <div>
        <input type="checkbox">
          <xsl:attribute name="value">
            <xsl:value-of select="1"/>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="strName" disable-output-escaping="yes"/>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="strName" disable-output-escaping="yes"/>
          </xsl:attribute>
          <xsl:if test="strValue=1">
            <xsl:attribute name="checked">
              <xsl:value-of select="'checked'"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name="class">
            <xsl:value-of select="concat(strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
          </xsl:attribute>
        </input>
        <xsl:value-of select="strLabel" disable-output-escaping="yes"/>
        <xsl:call-template name="HelpLink"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="RadioButtonElement">
    <div class="radio">
      <xsl:call-template name="Label"/>
      <xsl:call-template name="HelpLink"/>
      <xsl:for-each select="MultipleChoiceItem">
        <xsl:value-of select="$NewLineTwoTabs"/>
        <div>
          <input type="radio" autocomplete="off">
            <xsl:attribute name="value">
              <xsl:value-of select="strValue" disable-output-escaping="yes"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="../strName" disable-output-escaping="yes"/>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="concat(../strName,'_', strValue)" disable-output-escaping="yes"/>
            </xsl:attribute>
            <xsl:if test="bitSelected='true' or bitSelected='True'">
              <xsl:attribute name="checked">
                <xsl:value-of select="'checked'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
              <xsl:value-of select="strCssClass" disable-output-escaping="yes"/>
            </xsl:attribute>
          </input>
          <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template name="TextareaElement">
    <xsl:call-template name="Label"/>
    <textarea autocomplete="off">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat(strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
      <xsl:value-of select="strValue"/>
    </textarea>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="RichTextEditorElement">
    <xsl:call-template name="Label"/>
    <div class="rteWrapper">
      <textarea autocomplete="off">
        <xsl:attribute name="id">
          <xsl:value-of select="strName"/>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="strName"/>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('ckeditor ', strCssClass)" disable-output-escaping="yes"/>
        </xsl:attribute>
        <xsl:value-of select="strValue"/>
      </textarea>
    </div>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="MessageElement">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('FormMessage ', strCssClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
      <xsl:value-of select="strValue" disable-output-escaping="yes"/>
    </div>
  </xsl:template>

  <xsl:template name="DropdownElement">
    <xsl:call-template name="Label"/>
    <select autocomplete="off">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat(strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
      </xsl:attribute>

      <xsl:for-each select="MultipleChoiceItem">
        <xsl:value-of select="$NewLineTwoTabs"/>
        <option>
          <xsl:attribute name="value">
            <xsl:value-of select="strValue" disable-output-escaping="yes"/>
          </xsl:attribute>
          <xsl:if test="bitSelected='true' or bitSelected='True'">
            <xsl:attribute name="selected">
              <xsl:value-of select="'selected'"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
        </option>
      </xsl:for-each>
    </select>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="MultipleChoiceCheckboxElements">
    <xsl:call-template name="Label"/>
    <xsl:call-template name="HelpLink"/>

    <div class="radio">
      <xsl:for-each select="MultipleChoiceItem">
        <xsl:value-of select="$NewLineTwoTabs"/>
        <div>
          <input type="checkbox">
            <xsl:attribute name="value">
              <xsl:value-of select="1"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="strValue" disable-output-escaping="yes"/>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="strValue" disable-output-escaping="yes"/>
            </xsl:attribute>
            <xsl:if test="bitSelected='true' or bitSelected='True'">
              <xsl:attribute name="checked">
                <xsl:value-of select="'checked'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
              <xsl:value-of select="concat(strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
            </xsl:attribute>
          </input>
          <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template name="FilteredListElement">
    <xsl:call-template name="Label"/>
    <span class="filteredListWrapper">
      <select autocomplete="off" size="6">
        <xsl:attribute name="id">
          <xsl:value-of select="strName"/>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="strName"/>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('filteredList ', strCssClass, ' ', strValidationClass)" disable-output-escaping="yes"/>
        </xsl:attribute>

        <xsl:for-each select="MultipleChoiceItem">
          <xsl:value-of select="$NewLineTwoTabs"/>
          <option>
            <xsl:attribute name="value">
              <xsl:value-of select="strValue" disable-output-escaping="yes"/>
            </xsl:attribute>
            <xsl:if test="bitSelected='true' or bitSelected='True'">
              <xsl:attribute name="selected">
                <xsl:value-of select="'selected'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
          </option>
        </xsl:for-each>
      </select>
      <br/>
      <input autocomplete="off" type="text" style="display: none;" class="listFilter">
        <xsl:attribute name="id">
          <xsl:value-of select="concat(strName, 'FilterText')"/>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="concat(strName, 'FilterText')"/>
        </xsl:attribute>
      </input>
    </span>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="SubmitElement">
    <input type="submit">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="strValue"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('submitbutton ', strCssClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
    </input>
  </xsl:template>

  <xsl:template name="HiddenElement">
    <input type="hidden">
      <xsl:attribute name="id">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="strValue"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="concat(strValidationClass, strCssClass)" disable-output-escaping="yes"/>
      </xsl:attribute>
    </input>
  </xsl:template>

  <xsl:template name="Label">
    <label class="formElementlabel">
      <xsl:attribute name="for">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <span class="labelText">
        <xsl:value-of select="strLabel" disable-output-escaping="yes"/>
      </span>
      <xsl:if test="bitMandatory='true'">
        <span class="mandatoryStar">
          <xsl:value-of select="'*'"/>
        </span>
      </xsl:if>
    </label>
  </xsl:template>

  <xsl:template name="File">
    <input type="file" size="50">
      <xsl:attribute name="name">
        <xsl:value-of select="strName"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="strCssClass"/>
      </xsl:attribute>
    </input>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>

  <xsl:template name="TreeElement">
    <div class="tree">
      <xsl:call-template name="TreeBranch">
        <xsl:with-param name="FormId" select="lngFormId"/>
        <xsl:with-param name="ElementName" select="strName"/>
        <xsl:with-param name="ParentId" select="''"/>
        <xsl:with-param name="ElementType" select="'radio'"/>
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template name="TreeBranch">
    <xsl:param name="ParentId"/>
    <xsl:param name="FormId"/>
    <xsl:param name="ElementName"/>
    <xsl:param name="ElementType"/>

    <ul>
      <xsl:for-each select="//FormElement[lngFormId=$FormId and strName=$ElementName]/MultipleChoiceItem[(count(lngParentId) = 0 and $ParentId = '') or lngParentId=$ParentId]">
        <li>
          <xsl:attribute name="id">
            <xsl:value-of select="concat('treeNode', lngId)"/>
          </xsl:attribute>

          <xsl:variable name="Id" select="lngId"/>

          <xsl:choose>
            <xsl:when test="count(strLink)=0 or strLink=''">
              <span>
                <xsl:attribute name="class">
                  <xsl:value-of select="concat('treeNode ', strCssClass)"/>
                </xsl:attribute>
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

          <xsl:choose>
            <xsl:when test="count(//FormElement[lngFormId=$FormId and strName=$ElementName]/MultipleChoiceItem[lngParentId=$Id])>0">
              <xsl:call-template name="TreeBranch">
                <xsl:with-param name="FormId" select="$FormId"/>
                <xsl:with-param name="ElementName" select="$ElementName"/>
                <xsl:with-param name="ParentId" select="lngId"/>
                <xsl:with-param name="ElementType" select="$ElementType"/>
              </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
              <input disabled="disabled">
                <xsl:attribute name="type">
                  <xsl:value-of select="$ElementType"/>
                </xsl:attribute>
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($ElementName, 'Display')"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat($ElementName, 'Display')"/>
                </xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
                </xsl:attribute>
              </input>
              <input type="hidden">
                <xsl:attribute name="name">
                  <xsl:value-of select="$ElementName"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="$ElementName"/>
                </xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="strDescription" disable-output-escaping="yes"/>
                </xsl:attribute>
              </input>
            </xsl:otherwise>

          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="CheckboxTreeElement">
    <div class="tree">
      <xsl:call-template name="TreeBranch">
        <xsl:with-param name="FormId" select="lngFormId"/>
        <xsl:with-param name="ElementName" select="strName"/>
        <xsl:with-param name="ParentId" select="''"/>
        <xsl:with-param name="ElementType" select="'checkbox'"/>
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template name="HelpLink">
    <xsl:if test="strHelp != ''">
      <span class="openHelp info">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('helpButtonFor', strName)"/>
        </xsl:attribute>
        <xsl:call-template name="IncludeImage">
          <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/images/info-small.gif'"/>
          <xsl:with-param name="class" select="'info'"/>
        </xsl:call-template>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="FileMulti">
    <xsl:call-template name="IncludeScript">
      <xsl:with-param name="src" select="'static.uk-plc.net/ukplc/js/fileupload/fileuploader.js'"/>
    </xsl:call-template>
    <xsl:call-template name="IncludeStylesheet">
      <xsl:with-param name="href" select="'static.uk-plc.net/ukplc/css/fileupload.css'"/>
    </xsl:call-template>

    <div class="fileMulti">
      <div id="demo"></div>
      <ul id="separate-list"></ul>
      <xsl:variable name="Name" select="concat('SerialisedForm', lngFormId)"/>
      <xsl:text disable-output-escaping="yes">
    <![CDATA[
    <script>
      var files = 0;
      var finished = 0;
      function createUploader(){
        var uploader = new qq.FileUploader({
          element: document.getElementById('demo'),
          listElement: document.getElementById('separate-list'),
          onSubmit: function(id, filename) {
            files++
          },
          onComplete: function(id, fileName, loaded, total) {
            finished++
            if (files == finished){
              window.location.reload()
            }
          },
          action: '/]]></xsl:text>
      <xsl:value-of select="//PageXml/Page/strName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[',
          params: ]]></xsl:text>
      <xsl:value-of select="//HeaderVariables[@Name=$Name]/Value"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[
        });
      }
      window.onload = createUploader;

    </script>
    ]]>
    </xsl:text>
    </div>
    <xsl:call-template name="HelpLink"/>
  </xsl:template>
</xsl:stylesheet>