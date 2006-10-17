<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <!-- ********************************************************************
    $Id$
    ********************************************************************
    
    Based on Jakarta Avalon Documentation Style sheets.
    See http://jakarta.apache.org/avalon
    
    ******************************************************************** -->
    
    <xsl:template match="book">
        <menu>
            <div id="menu">
                <script language="JavaScript">//@@MENU_TOP@@</script>
                <xsl:apply-templates/>
            </div>
        </menu>
    </xsl:template>
    
    <xsl:template match="project">
        <br/><a href="{@href}"><font color="#F3510C" size="+1"><xsl:value-of select="@label"/></font></a><br/>
    </xsl:template>
    
    <xsl:template match="menu">
        <div>
            <b><xsl:value-of select="@label"/></b>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="menu-item">
        <xsl:if test="not(@type) or @type!='hidden'">
            <div>
                <xsl:if test="@highlight">
                    <b>
                        &gt;&gt;
                        <a href="{@href}"><xsl:value-of select="@label"/></a>
                        &lt;&lt;
                    </b>
                </xsl:if>
                <xsl:if test="not(@highlight)">
                    <a href="{@href}"><xsl:value-of select="@label"/></a>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="node()|@*" priority="-1"/>
</xsl:stylesheet>

