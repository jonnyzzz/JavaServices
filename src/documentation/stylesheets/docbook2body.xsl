<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- ********************************************************************
    $Id$
    ********************************************************************
    
    Based on Jakarta Avalon Documentation Style sheets.
    See http://jakarta.apache.org/avalon
    
    ******************************************************************** -->
    
    <!-- ******************************************************************************** -->
    <!-- I M P O R T S                                                                    -->
    <!-- ******************************************************************************** -->
    
    <xsl:include href="docbook/nwalsh/html/param.xsl"/>
    <xsl:include href="docbook/nwalsh/common/l10n.xsl"/>
    <xsl:include href="docbook/nwalsh/common/labels.xsl"/>
    <xsl:include href="docbook/nwalsh/common/titles.xsl"/>
    <xsl:include href="docbook/nwalsh/common/subtitles.xsl"/>
    
    <!-- ******************************************************************************** -->
    <!-- P A R A M E T E R S                                                              -->
    <!-- ******************************************************************************** -->
    
    <!-- ******************************************************************************** -->
    <!-- T E M P L A T E S                                                                -->               
    <!-- ******************************************************************************** -->
    
    <xsl:template match="*">
        <xsl:message>
            <xsl:text>No template matches </xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:text>.</xsl:text>
        </xsl:message>
        
        <font color="red">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:text>&gt;</xsl:text>
        </font>
    </xsl:template>
    
    <xsl:template match="book">
        <body>
            <title><xsl:value-of select="title"/></title>
            <center>
                <table width="80%">
                    <tr>
                        <td bgcolor="#F3DD61">
                            <br/>
                            <center>
                                <b>
                                    <font color="#000000" face="arial,helvetica,sanserif">
                                        <xsl:value-of select="title"/>
                                        <xsl:if test="subtitle">
                                            <xsl:text>: </xsl:text><xsl:value-of select="subtitle"/>
                                        </xsl:if>
                                    </font>
                                </b>
                            </center>
                            <br/>
                        </td>
                    </tr>
                </table>
            </center><br/>
            <xsl:apply-templates select="dedication"/>
            <xsl:apply-templates select="bookinfo"/>
        </body>
    </xsl:template>
    
    <xsl:template match="chapter|article|glossary|appendix">
        <body>
            <xsl:call-template name="header"/>
            
            <xsl:apply-templates>
                <xsl:with-param name="level" select="1"/>
            </xsl:apply-templates>
        </body>
    </xsl:template>
    
    <xsl:template match="javadocs">
        <iframe src="../../jdoc/index.html" width="100%" height="480" align="center" frameborder="1" marginwidth="0" marginheight="0" scrolling="yes">
            <xsl:apply-templates/>
        </iframe>				
    </xsl:template>
    
    <xsl:template match="paypal-form">
        <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
            <center>
                <table bgcolor="#8888aa" border="0" cellspacing="0" cellpadding="2">
                    <tr>
                        <td>
                            <table bgcolor="#bbbbee" border="0" cellspacing="0" cellpadding="8">
                                <tr valign="top">
                                    <td>
                                        <p>
                                            <b>Anonymity</b>:<br/>
                                            <font size="-2">choose whether to<br/>donate anonymously</font>
                                        </p>
                                    </td>
                                    <td nowrap="true">
                                        <table border="0" cellspacing="0" cellpadding="2">
                                            <tr>
                                                <td valign="top">
                                                    <input type="radio" name="item_number" value="101" checked="true" />
                                                </td>
                                                <td>
                                                    <p><i>Anonymous donation</i></p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <input type="radio" name="item_number" value="102" />
                                                </td>
                                                <td>
                                                    <p><i>Named on our <br/><a href="sponsors.html">sponsor's page</a></i></p>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p>
                                            <b>Amount (US$)</b>:<br/>
                                            <font size="-2">enter the amount you<br/>wish to donate</font>
                                        </p>
                                    </td>
                                    <td nowrap="true" align="center">
                                        <input type="text" name="amount" size="8" value="50.00" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p>
                                            <b>Submit</b>:<br/>
                                            <font size="-2">click the image to donate</font>
                                        </p>
                                    </td>
                                    <td nowrap="true" align="center">
                                        <input type="image" src="http://images.paypal.com/images/x-click-butcc-donate.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!"/>
                                        <input type="hidden" name="business" value="leif@tanukisoftware.com"/>
                                        
                                        <input type="hidden" name="cmd" value="_xclick"/>
                                        <input type="hidden" name="item_name" value="Java Service Wrapper"/>
                                        <input type="hidden" name="image_url" value="http://wrapper.tanukisoftware.org/paypal/WrapperLogoWhite.png"/>
                                        <input type="hidden" name="no_shipping" value="1"/>
                                        <input type="hidden" name="cn" value="Sponsor page message."/>
                                        <input type="hidden" name="return" value="http://wrapper.tanukisoftware.org/doc/english/donate-thanks.html"/>
                                        <input type="hidden" name="cancel_return" value="http://wrapper.tanukisoftware.org/doc/english/donate.html"/>
                                        <input type="hidden" name="currency_code" value="USD"/>
                                        <input type="hidden" name="tax" value="0"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </center>
        </form>
    </xsl:template>
    
    <xsl:template match="donorlist">
        <table border="0" cellpadding="4" cellspacing="0">
            <tr class="donorheader">
                <td><b>Date</b></td>
                <td><b>Amount (US$)</b></td>
                <td><b>Donor</b></td>
                <td><b>Message</b></td>
            </tr>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="donorlist/donor">
        <tr class="donor">
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="donorlist/donor/date">
        <td valign="top" nowrap="true"><xsl:apply-templates/></td>
    </xsl:template>
    
    <xsl:template match="donorlist/donor/amount">
        <td valign="top" nowrap="true">$<xsl:apply-templates/></td>
    </xsl:template>
    
    <xsl:template match="donorlist/donor/name">
        <td valign="top"><xsl:apply-templates/></td>
    </xsl:template>
    
    <xsl:template match="donorlist/donor/message">
        <td valign="top"><xsl:apply-templates/></td>
    </xsl:template>
        
    
    <xsl:template match="glossary">
        <body>
            <xsl:call-template name="header"/>
            <dl>
                <xsl:apply-templates/>
            </dl>
        </body>
    </xsl:template>
    
    <xsl:template name="header">
        <title><xsl:value-of select="title"/></title>
        <xsl:if test="subtitle">
            <font face="arial,helvetica,sanserif" color="#525D76"><i><xsl:value-of select="subtitle"/></i></font><br/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="title|subtitle"/>
    
    <xsl:template match="author">
        <body>
            <title>
                <xsl:value-of select="honorific"/><xsl:text>. </xsl:text>
                <xsl:value-of select="firstname"/><xsl:text> </xsl:text>
                <xsl:value-of select="surname"/>
            </title>
            <center>
                <table width="80%">
                    <tr>
                        <td bgcolor="#F3DD61">
                            <br/><center><b><font color="#000000" face="arial,helvetica,sanserif"><xsl:text>Author: </xsl:text><xsl:value-of select="honorific"/><xsl:text>. </xsl:text><xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:value-of select="surname"/></font></b></center>
                            <br/>
                        </td>
                    </tr>
                </table>
            </center><br/>
            <div align="right">
                <table border="0" cellpadding="2" cellspacing="0" width="100%">
                    <tr>
                        <td bgcolor="#525D76">
                            <font color="#ffffff" face="arial,helvetica,sanserif" size="+1"><b>Affiliations</b></font>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <font color="#000000" face="arial,helvetica,sanserif"><br/>
                                <ul>
                                    <xsl:apply-templates select="affiliation"/>
                                </ul>
                            </font>
                        </td>
                    </tr>
                </table>
            </div><br/>
            <xsl:apply-templates select="authorblurb"/>
        </body>
    </xsl:template>
    
    <xsl:template match="affiliation">
        <li>
            <xsl:text>[</xsl:text><xsl:value-of select="shortaffil"/><xsl:text>] </xsl:text>
            <b><xsl:value-of select="jobtitle"/></b>
            <i><xsl:value-of select="orgname"/><xsl:if test="orgdiv"><xsl:text>/</xsl:text><xsl:value-of select="orgdiv"/></xsl:if></i>
        </li>
    </xsl:template>
    
    <xsl:template match="authorblurb">
        <div align="right">
            <table border="0" cellpadding="2" cellspacing="0" width="100%">
                <tr>
                    <td bgcolor="#525D76">
                        <font color="#ffffff" face="arial,helvetica,sanserif" size="+1"><b>Bio</b></font>
                    </td>
                </tr>
                <tr>
                    <td>
                        <font color="#000000" face="arial,helvetica,sanserif"><br/>
                            <ul>
                                <xsl:apply-templates/>
                            </ul>
                        </font>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template match="honorific|firstname|surname|orgdiv|orgname|shortaffil|jobtitle"/>
    
    <xsl:template match="revhistory">
        <body>
            <title>Revision History</title>
            <center>
                <table width="80%">
                    <tr>
                        <td bgcolor="#F3DD61">
                            <br/><center><b><font color="#000000" face="arial,helvetica,sanserif">Revision History</font></b></center>
                            <br/>
                        </td>
                    </tr>
                </table>
            </center><br/>
            <div align="right">
                <table border="0" cellpadding="2" cellspacing="0" width="100%">
                    <xsl:variable name="unique-revisions" 
                        select="revision[not(revnumber=preceding-sibling::revision/revnumber)]/revnumber"/>
                    <xsl:variable name="base" select="."/>
                    <xsl:for-each select="$unique-revisions">
                        <tr>
                            <td bgcolor="#525D76">
                                <font color="#ffffff" face="arial,helvetica,sanserif">
                                    <b>Revision <xsl:value-of select="."/> 
                                        (<xsl:value-of select="$base/revision[revnumber=current()]/date"/>)
                                    </b>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <font color="#000000" face="arial,helvetica,sanserif"><br/>
                                    <ul>
                                        <xsl:apply-templates select="$base/revision[revnumber=current()]"/>
                                    </ul>
                                </font>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </div>
        </body>
    </xsl:template>
    
    <xsl:template match="para|simpara">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template name="italics">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    
    <xsl:template match="emphasis">
        <xsl:call-template name="italics"/>
    </xsl:template>
    
    <xsl:template match="foreignphrase">
        <xsl:call-template name="italics"/>
    </xsl:template>
    
    <xsl:template name="monospace">
        <xsl:param name="content">
            <xsl:apply-templates/>
        </xsl:param>
        <tt><xsl:copy-of select="$content"/></tt>
    </xsl:template>
    
    <xsl:template match="literal">
        <xsl:call-template name="monospace"/>
    </xsl:template>
    
    <xsl:template match="guilabel|guibutton|guimenu|guisubmenu|guimenuitem|guiicon">
        <xsl:call-template name="monospace"/>
    </xsl:template>
    
    <xsl:template match="email">
        <xsl:call-template name="monospace">
            <xsl:with-param name="content">
                <xsl:text>&lt;</xsl:text>
                <a>
                    <xsl:attribute name="href">mailto:<xsl:value-of select="."/></xsl:attribute>
                    <xsl:apply-templates/>
                </a>
                <xsl:text>&gt;</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="revision">
        <li>
            <xsl:choose>
                <xsl:when test="@revisionflag='added'">
                    <img align="absmiddle" alt="added" border="0" src="images/add.jpg"/>
                </xsl:when>
                <xsl:when test="@revisionflag='changed'">
                    <img align="absmiddle" alt="changed" border="0" src="images/update.jpg"/>
                </xsl:when>
                <xsl:when test="@revisionflag='deleted'">
                    <img align="absmiddle" alt="deleted" border="0" src="images/remove.jpg"/>
                </xsl:when>
                <xsl:when test="@revisionflag='off'">
                    <img align="absmiddle" alt="off" border="0" src="images/fix.jpg"/>
                </xsl:when>
                <xsl:otherwise>
                    <img align="absmiddle" alt="changed" border="0" src="images/update.jpg"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="revremark"/>
            <xsl:text> (</xsl:text><xsl:value-of select="authorinitials"/><xsl:text>)</xsl:text>
        </li>
    </xsl:template>
    
    <xsl:template match="revnumber|revremark|authorinitials|date"/>
    
    <xsl:template match="section">
        <xsl:param name="level"/>
        
        <xsl:variable name="id">
            <xsl:call-template name="object.id"/>
        </xsl:variable>

        <a name="{$id}"/>
        <table border="0" width="100%" cellspacing="0" cellpadding="2">
            <tr>
                <xsl:choose>
                    <xsl:when test="$level>1">
                        <td width="10" rowspan="3"><img src="./images/spacer.gif" width="10" height="1"/></td>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$level=1">
                        <td width="*" class="sectionheader1" bgcolor="#8888aa"><font size="4" color="#eeeeee"><b><xsl:value-of select="title"/></b></font></td>
                    </xsl:when>
                    <xsl:when test="$level=2">
                        <td width="*" class="sectionheader2" bgcolor="#9999bb"><font size="3" color="#eeeeee"><b><xsl:value-of select="title"/></b></font></td>
                    </xsl:when>
                    <xsl:when test="$level=3">
                        <td width="*" class="sectionheader3" bgcolor="#aaaacc"><font size="2" color="#eeeeee"><b><xsl:value-of select="title"/></b></font></td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td width="*" class="sectionheader3" bgcolor="#bbbbdd"><font size="2" color="#eeeeee"><b><xsl:value-of select="title"/></b></font></td>
                    </xsl:otherwise>
                </xsl:choose>
            </tr>
            <tr>
                <td><img src="./images/spacer.gif" width="1" height="4"/></td>
            </tr>
            <tr>
                <td>
                    <xsl:apply-templates>
                        <xsl:with-param name="level" select="number($level)+1"/>
                    </xsl:apply-templates>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template match="bookinfo">
        <div align="right">
            <table border="0" cellpadding="2" cellspacing="0" width="100%">
                <tr>
                    <td bgcolor="#525D76">
                        <font color="#ffffff" face="arial,helvetica,sanserif" size="+1">
                            <b><xsl:value-of select="edition"/></b><xsl:text> </xsl:text>
                            <i><font size="0">pub. <xsl:value-of select="pubdate"/></font></i>
                        </font>
                    </td>
                </tr>
                <tr>
                    <td>
                        <font color="#000000" face="arial,helvetica,sanserif">
                            <br/>
                            <xsl:apply-templates/>
                        </font>
                    </td>
                </tr>
            </table>
        </div><br/>
    </xsl:template>
    
    <xsl:template match="dedication">
        <div align="right">
            <table border="0" cellpadding="2" cellspacing="0" width="100%">
                <tr>
                    <td bgcolor="#525D76">
                        <font color="#ffffff" face="arial,helvetica,sanserif" size="+1">
                            <b>Dedication</b>
                        </font>
                    </td>
                </tr>
                <tr>
                    <td>
                        <font color="#000000" face="arial,helvetica,sanserif">
                            <br/>
                            <xsl:apply-templates/>
                        </font>
                    </td>
                </tr>
            </table>
        </div><br/>
    </xsl:template>
    
    <xsl:template match="edition|pubdate|year|holder"/>
    
    <xsl:template match="copyright">
        <p>Copyright &#x00A9;<xsl:value-of select="year"/> by <xsl:value-of select="holder"/>.<br/>
            <i>All rights reserved.</i>
        </p>
    </xsl:template>
    
    <xsl:template match="legalnotice">
        <div align="center">
            <table border="1" cellpadding="2" cellspacing="2">
                <tr>
                    <td><xsl:apply-templates/></td>
                </tr>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template match="programlisting">
        <table class="listing" border="0" width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td class="listingcell" bgcolor="#eeeeee">
                    <font color="#444444">
                        <pre class="listingpre"><xsl:apply-templates/></pre>
                    </font>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template match="example|informalexample">
        <table class="listing" border="0" width="100%" cellpadding="0" cellspacing="0">
            <xsl:if test="simpara">
                <tr>
                    <td class="listingcaption">
                        <xsl:apply-templates select="simpara" mode="example"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="screen">
                <tr>
                    <td class="listingcell" bgcolor="#eeeeee">
                        <font color="#444444">
                            <pre class="listingpre"><xsl:apply-templates select="screen" mode="example"/></pre>
                        </font>
                    </td>
                </tr>
            </xsl:if>
        </table>
        
        
        <!--
        <div class="listing">
            <xsl:apply-templates mode="example"/>
        </div>
        -->
    </xsl:template>
    
    <xsl:template match="title" mode="example">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    
    <xsl:template match="simpara" mode="example">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="programlisting|screen" mode="example">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="orderedlist"><ol><xsl:apply-templates/></ol></xsl:template>
    
    <xsl:template match="listitem"><li><xsl:apply-templates/></li></xsl:template>
    
    <xsl:template match="itemizedlist"><ul><xsl:apply-templates/></ul></xsl:template>
    
    <xsl:template match="classname|function|parameter"><code><xsl:apply-templates/><xsl:if test="name(.)='function'"><xsl:text>()</xsl:text></xsl:if></code></xsl:template>
    
    <xsl:template match="listproperty">
        <li>
            <xsl:apply-templates/>
            <xsl:if test="@version">
                <font color="#808080"><i>(<xsl:value-of select="@version"/>)</i></font>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template match="blockquote">
        <div align="center">
            <table border="1" cellpadding="2" cellspacing="2">
                <xsl:if test="title">
                    <tr>
                        <td bgcolor="#525D76">
                            <font color="#ffffff"><xsl:value-of select="title"/></font>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <td bgcolor="#c0c0c0">
                        <font color="#023264" size="-1"><xsl:apply-templates/></font>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template match="warning">
        <div class="warning">
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top" nowrap="nowrap"><p class="warninglabel"><font color="#a00000"><b>WARNING</b></font></p></td>
                    <td><img src="images/spacer.gif" width="10"/></td>
                    <td class="warningbody" bgcolor="#dd8080">
                        <font color="#602222">
                            <xsl:apply-templates/>
                        </font>
                    </td>
                </tr>
            </table>
        </div>
        <!--
        <div align="center">
            <table border="1" cellpadding="2" cellspacing="2">
                <xsl:if test="title">
                    <tr>
                        <td bgcolor="#800000">
                            <font color="#ffffff"><xsl:value-of select="title"/></font>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <td bgcolor="#c0c0c0">
                        <font color="#023264" size="-1"><xsl:apply-templates/></font>
                    </td>
                </tr>
            </table>
        </div>
        -->
    </xsl:template>

    <xsl:template match="note">
        <div class="note">
            <table border="0" width="100%" cellpadding="2" cellspacing="0">
                <tr>
                    <td valign="top" nowrap="nowrap"><p class="notelabel"><font color="#0000a0"><b>NOTE MEG</b></font></p></td>
                    <td><img src="images/spacer.gif" width="10"/></td>
                    <td class="notebody" bgcolor="#bbbbdd">
                        <font color="#222260">
                            <xsl:apply-templates/>
                        </font>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template match="link">
        <a href="#{@linkend}"><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="ulink">
        <a href="{@url}"><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="figure">
        <div align="center">
            <table border="0" cellpadding="2" cellspacing="2">
                <tr>
                    <td bgcolor="#525D76"><font color="#ffffff" size="0"><xsl:value-of select="title"/></font></td>
                </tr>
                <xsl:apply-templates/>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template match="screenshot">
        <div class="{name(.)}" align="center">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="screeninfo"/>
    
    <xsl:template match="graphic">
        <p>
            <img src="{@fileref}.png"/>
        </p>
    </xsl:template>
    
    <xsl:template match="trademark"><xsl:apply-templates/><sup>TM</sup></xsl:template>
    
    <xsl:template match="node()|@*" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="object.id">
        <xsl:param name="object" select="."/>
        <xsl:choose>
            <xsl:when test="$object/@id">
                <xsl:value-of select="$object/@id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="generate-id($object)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ==================================================================== -->
    
    <xsl:template match="table|informaltable">
        <div align="center">
            <p>
                <table border="5" cellpadding="2" cellspacing="2">
                    <xsl:apply-templates/>
                </table>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tgroup">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="colspec"/>
    
    <xsl:template match="thead|tbody|tfoot">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="row">
        <tr><xsl:apply-templates/></tr>
    </xsl:template>
    
    <xsl:template match="entry">
        <td align="left" bgcolor="#a0ddf0" valign="top">
            <font color="#000000" face="arial,helvetica,sanserif" size="-1"><xsl:apply-templates/></font>
        </td>
    </xsl:template>
    
    <!-- ==================================================================== -->
    
    <xsl:template match="glosslist">
        <table border="0" width="100%" cellpadding="2" cellspacing="0">
            <xsl:apply-templates/>
        </table>
    
        <!--
        <div class="{name(.)}">
            <a>
                <xsl:attribute name="name">
                    <xsl:call-template name="object.id"/>
                </xsl:attribute>
            </a>
            
            <dl>
                <xsl:apply-templates/>
            </dl>
        </div>
        -->
    </xsl:template>
    
    <xsl:template match="glossentry">
        <xsl:apply-templates/>
        <tr>
            <td colspan="2"><img src="images/spacer.gif" width="1" height="10"/></td>
        </tr>
    
        <!--
        <xsl:apply-templates/>
        <br/>
        -->
    </xsl:template>
    
    <xsl:template match="glossentry/glossterm">
        <tr>
            <td colspan="2"><b><xsl:apply-templates/></b></td>
        </tr>
    
        <!--
        <dt>
            <b><xsl:apply-templates/></b>
        </dt>
        -->
    </xsl:template>
    
    <xsl:template match="glossentry/glossdef">
        <tr>
            <td width="20"><img src="images/spacer.gif" width="20" height="1"/></td>
            <td width="*"><xsl:apply-templates/></td>
        </tr>
    
        <!--
        <dd>
            <xsl:apply-templates/>
        </dd>
        -->
    </xsl:template>
    
    <xsl:template match="glossentry/glossdef/simpara">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="glossentry/glosssee">
        <xsl:variable name="otherterm" select="@otherterm"/>
        <xsl:variable name="targets" select="//node()[@id=$otherterm]"/>
        <xsl:variable name="target" select="$targets[1]"/>
        <dd>
            <p>
                <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" select="'glossary'"/>
                    <xsl:with-param name="name" select="'see'"/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="@otherterm">
                        <a href="#{@otherterm}">
                            <xsl:apply-templates select="$target" mode="xref"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>.</xsl:text>
            </p>
        </dd>
    </xsl:template>
    
    <!-- ==================================================================== -->
    
    <xsl:template match="glossentry" mode="xref">
        <xsl:apply-templates select="./glossterm[1]" mode="xref"/>
    </xsl:template>
    
    <xsl:template match="glossterm" mode="xref">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- ==================================================================== -->
    
    <xsl:template match="xref">
        
        <xsl:variable name="targets" select="id(@linkend)"/>
        <xsl:variable name="target"  select="$targets[1]"/>
        <xsl:variable name="refelem" select="local-name($target)"/>
        
        <xsl:call-template name="check.id.unique">
            <xsl:with-param name="linkend" select="@linkend"/>
        </xsl:call-template>
        
        <xsl:choose>
            <xsl:when test="count($target) = 0">
                <xsl:message>
                    <xsl:text>XRef to nonexistent id: </xsl:text>
                    <xsl:value-of select="@linkend"/>
                </xsl:message>
                <xsl:text>???</xsl:text>
            </xsl:when>
            
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                            <xsl:with-param name="object" select="$target"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    
                    <xsl:apply-templates select="$target" mode="xref-to"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*" mode="xref-to">
        <xsl:param name="target" select="."/>
        <xsl:param name="refelem" select="local-name($target)"/>
        
        <xsl:message>
            <xsl:text>Don't know what gentext to create for xref to: "</xsl:text>
            <xsl:value-of select="$refelem"/>
            <xsl:text>"</xsl:text>
        </xsl:message>
        <xsl:text>???</xsl:text>
    </xsl:template>
    
    <xsl:template match="section" mode="xref-to">
        <xsl:apply-templates select="." mode="object.xref.markup"/>
    </xsl:template>
    
    <xsl:template match="figure" mode="xref-to">
        <xsl:apply-templates select="." mode="object.xref.markup"/>
    </xsl:template>
    
    <xsl:template match="*" mode="object.xref.markup">
        <xsl:variable name="template">
            <xsl:apply-templates select="." mode="object.xref.template"/>
        </xsl:variable>
        <xsl:call-template name="substitute-markup">
            <xsl:with-param name="template" select="$template"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="*" mode="object.xref.template">
        <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'xref'"/>
            <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="section" mode="object.xref.template">
        <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'section-xref'"/>
            <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="check.id.unique">
        <xsl:param name="linkend"></xsl:param>
        <xsl:if test="$linkend != ''">
            <xsl:variable name="targets" select="id($linkend)"/>
            <xsl:variable name="target" select="$targets[1]"/>
            
            <xsl:if test="count($targets)=0">
                <xsl:message>
                    <xsl:text>Error: no ID for constraint linkend: </xsl:text>
                    <xsl:value-of select="$linkend"/>
                    <xsl:text>.</xsl:text>
                </xsl:message>
            </xsl:if>
            
            <xsl:if test="count($targets)>1">
                <xsl:message>
                    <xsl:text>Warning: multiple "IDs" for constraint linkend: </xsl:text>
                    <xsl:value-of select="$linkend"/>
                    <xsl:text>.</xsl:text>
                </xsl:message>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="href.target">
        <xsl:param name="object" select="."/>
        <xsl:text>#</xsl:text>
        <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="$object"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="substitute-markup">
        <xsl:param name="template" select="''"/>
        <xsl:param name="allow-anchors" select="'0'"/>
        <xsl:variable name="bef-n" select="substring-before($template, '%n')"/>
        <xsl:variable name="bef-s" select="substring-before($template, '%s')"/>
        <xsl:variable name="bef-t" select="substring-before($template, '%t')"/>
        
        <xsl:choose>
            <!-- n=1 -->
            <xsl:when test="starts-with($template, '%n')">
                <xsl:apply-templates select="." mode="label.markup"/>
                <xsl:call-template name="substitute-markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                    <xsl:with-param name="template"
                        select="substring-after($template, '%n')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- t=1 -->
            <xsl:when test="starts-with($template, '%t')">
                <xsl:apply-templates select="." mode="title.markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                </xsl:apply-templates>
                <xsl:call-template name="substitute-markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                    <xsl:with-param name="template"
                        select="substring-after($template, '%t')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- s=1 -->
            <xsl:when test="starts-with($template, '%s')">
                <xsl:apply-templates select="." mode="subtitle.markup"/>
                <xsl:call-template name="substitute-markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                    <xsl:with-param name="template"
                        select="substring-after($template, '%s')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- n and t and s -->
            <xsl:when test="contains($template, '%n')
            and contains($template, '%t')
            and contains($template, '%s')">
                <xsl:choose>
                    <!-- n is first -->
                    <xsl:when test="string-length($bef-n) &lt; string-length($bef-s)
                    and string-length($bef-n) &lt; string-length($bef-t)">
                        <xsl:value-of select="$bef-n"/>
                        <xsl:apply-templates select="." mode="label.markup"/>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%n')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- s is first -->
                    <xsl:when test="string-length($bef-s) &lt; string-length($bef-n)
                    and string-length($bef-s) &lt; string-length($bef-t)">
                        <xsl:value-of select="$bef-s"/>
                        <xsl:apply-templates select="." mode="subtitle.markup"/>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%s')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- t must be first -->
                    <xsl:otherwise>
                        <xsl:value-of select="$bef-t"/>
                        <xsl:apply-templates select="." mode="title.markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                        </xsl:apply-templates>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%t')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- n and t -->
            <xsl:when test="contains($template, '%n')
            and contains($template, '%t')">
                <xsl:choose>
                    <!-- n is first -->
                    <xsl:when test="string-length($bef-n) &lt; string-length($bef-t)">
                        <xsl:value-of select="$bef-n"/>
                        <xsl:apply-templates select="." mode="label.markup"/>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%n')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- t is first -->
                    <xsl:otherwise>
                        <xsl:value-of select="$bef-t"/>
                        <xsl:apply-templates select="." mode="title.markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                        </xsl:apply-templates>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%t')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- n and s -->
            <xsl:when test="contains($template, '%n')
            and contains($template, '%s')">
                <xsl:choose>
                    <!-- n is first -->
                    <xsl:when test="string-length($bef-n) &lt; string-length($bef-s)">
                        <xsl:value-of select="$bef-n"/>
                        <xsl:apply-templates select="." mode="label.markup"/>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%n')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- s is first -->
                    <xsl:otherwise>
                        <xsl:value-of select="$bef-s"/>
                        <xsl:apply-templates select="." mode="subtitle.markup"/>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%s')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- t and s -->
            <xsl:when test="contains($template, '%t')
            and contains($template, '%s')">
                <xsl:choose>
                    <!-- t is first -->
                    <xsl:when test="string-length($bef-t) &lt; string-length($bef-s)">
                        <xsl:value-of select="$bef-t"/>
                        <xsl:apply-templates select="." mode="title.markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                        </xsl:apply-templates>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%t')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- s is first -->
                    <xsl:otherwise>
                        <xsl:value-of select="$bef-s"/>
                        <xsl:apply-templates select="." mode="subtitle.markup"/>
                        <xsl:call-template name="substitute-markup">
                            <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                            <xsl:with-param name="template"
                                select="substring-after($template, '%s')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- n -->
            <xsl:when test="contains($template, '%n')">
                <xsl:value-of select="$bef-n"/>
                <xsl:apply-templates select="." mode="label.markup"/>
                <xsl:call-template name="substitute-markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                    <xsl:with-param name="template"
                        select="substring-after($template, '%n')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- t -->
            <xsl:when test="contains($template, '%t')">
                <xsl:value-of select="$bef-t"/>
                <xsl:apply-templates select="." mode="title.markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                </xsl:apply-templates>
                <xsl:call-template name="substitute-markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                    <xsl:with-param name="template"
                        select="substring-after($template, '%t')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- s -->
            <xsl:when test="contains($template, '%s')">
                <xsl:value-of select="$bef-s"/>
                <xsl:apply-templates select="." mode="subtitle.markup"/>
                <xsl:call-template name="substitute-markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                    <xsl:with-param name="template"
                        select="substring-after($template, '%s')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- neither n nor t nor s -->
            <xsl:otherwise>
                <xsl:value-of select="$template"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
