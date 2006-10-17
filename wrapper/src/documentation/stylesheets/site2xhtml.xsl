<?xml version="1.0"?>

<html xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xsl:version="1.0">
    
    <!-- ********************************************************************
    $Id$
    ******************************************************************** -->
    
    <head>
        <title>Java Service Wrapper - <xsl:value-of select="/site/body/title"/></title>
        <style type="text/css" media="all">
            @import url("./style/wrapper.css");
        </style>
    </head>
    
    <body text="#000000" link="#525D76" vlink="#023264" alink="#023264"
        topmargin="0" leftmargin="0" marginwidth="0" marginheight="0"
        bgcolor="#eeeeff">
        
        <map name="wrapperLogo">
            <area shape="circle" coords="90,90,88" href="http://wrapper.tanukisoftware.org"/>
        </map>
        <map name="wrapperTitle">
            <area shape="rect" coords="28,32,176,48" href="http://www.tanukisoftware.com"/>
        </map>
            
        <table border="0" width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td width="180" valign="top">
                    <table border="0" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="180"><img src="images/WrapperLogo.png" width="180" height="180" border="0" usemap="#wrapperLogo"/></td>
                        </tr>
                        <tr>
                            <td>
                                <table border="0" width="100%" cellspacing="0" cellpadding="4">
                                    <tr>
                                        <td nowrap="true">
                                            <xsl:copy-of select="/site/menu/node()|@*"/>
                                            <script language="JavaScript">//@@MENU_BOTTOM@@</script>
                                            <p>
                                                <b>Hosted by:</b><br/>
                                                <a href="http://sourceforge.net/projects/wrapper/">
                                                    <img src="http://sourceforge.net/sflogo.php?group_id=39428" width="88" height="31" border="0" alt="SourceForge"/>
                                                </a><br/>
                                            </p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="*" valign="top">
                    <table border="0" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="3"><img src="images/spacer.gif" height="4"/></td>
                        </tr>
                        <tr>
                            <td colspan="2" height="90" align="center"><a href="http://wrapper.tanukisoftware.org"><img src="images/OfflineAd728x90.png" width="728" height="90" border="0"/></a></td>
                            <td rowspan="5"><img src="images/spacer.gif" width="4"/></td>
                        </tr>
                        <tr>
                            <td width="435" height="49"><img src="images/WrapperTitle.png" width="435" height="49" border="0" usemap="#wrapperTitle"/></td>
                            <td width="*" align="right" valign="bottom"><a href="donate.html"><img src="images/DonationRequest.png" width="300" height="16" border="0"/></a></td>
                        </tr>
                        <tr>
                            <td colspan="2" height="4"><img src="images/BorderTop.png" width="500" height="4"/></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="4" valign="top"><img src="images/BorderLeft.png" width="4" height="496"/></td>
                                        <td colspan="2" width="*" valign="top" bgcolor="#ffffff">
                                            <table border="0" width="100%" cellspacing="0" cellpadding="4">
                                                <tr>
                                                    <td align="center" nowrap="true"><font size="5" color="#8888aa" zcolor="#115b77"><b><xsl:value-of select="/site/body/title"/></b></font></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <xsl:copy-of select="/site/body/node()|@*"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td id="author" align="right">
                                                        <p><i>by Leif Mortenson</i></p>
                                                    </td>
                                                </tr>
                                            </table>
                                            <script language="JavaScript">//@@BODY_SECTION@@</script>
                                        </td>
                                        <td width="4" valign="bottom"><img src="images/BorderRight.png" width="4" height="496"/></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="4" align="right"><img src="images/BorderBottom.png" width="500" height="4"/></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tr>
                <td align="left" id="copyright">
                    <font face="arial,helvetica,sanserif" size="-1" color="#525D76">
                        <i>
                            Copyright &#169;1999-2004 by <a href="http://www.tanukisoftware.com">Tanuki Software</a>.
                            All Rights Reserved.
                        </i>
                    </font>
                </td>
                <td align="right">
                    <font face="arial,helvetica,sanserif" size="-1" color="#525D76">
                        <i>
                            last modified:
                            <script language="JavaScript"><![CDATA[ document.write(document.lastModified); ]]></script>
                        </i>
                    </font>
                </td>
            </tr>
        </table>
    </body>
</html>

