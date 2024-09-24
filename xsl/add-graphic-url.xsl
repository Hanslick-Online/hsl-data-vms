<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output encoding="UTF-8" media-type="text/xml" method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:graphic">
        <xsl:variable name="base" select="replace(tokenize(base-uri(/), '/')[last()], '_tei.xml', '_image_name.xml')"/>
        <xsl:variable name="items" select="doc(concat('../data/facs/', $base))"/>
        <xsl:variable name="pos" select="number(tokenize(parent::tei:surface/@xml:id, '_')[last()])"/>
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:attribute name="url">
                <xsl:value-of select="$items//item[$pos]"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>