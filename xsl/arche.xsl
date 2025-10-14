<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:output encoding="UTF-8" media-type="text/xml" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="constants">
            <xsl:for-each select=".//node()[parent::acdh:RepoObject]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="constantsImg">
            <xsl:for-each select=".//node()[parent::acdh:ImgObject]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="TopColId">
            <xsl:value-of select="string(.//acdh:TopCollection/@rdf:about)"/>
        </xsl:variable>
        <rdf:RDF xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#">
            <acdh:TopCollection>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select=".//acdh:TopCollection/@rdf:about"/>
                </xsl:attribute>
                <xsl:for-each select=".//node()[parent::acdh:TopCollection]">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </acdh:TopCollection>
            
            <xsl:for-each select=".//node()[parent::acdh:MetaAgents]">
                <xsl:copy-of select="."/>
            </xsl:for-each>

            <xsl:for-each select=".//acdh:Collection[@rdf:about='https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/editions']">
                <acdh:Collection>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                    <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/ampfiel"/>
                    <acdh:hasMetadataCreator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <xsl:copy-of select="$constants"/>
                    <xsl:for-each select=".//acdh:*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </acdh:Collection>
            </xsl:for-each>

            <xsl:for-each select="collection('../data/editions?select=*.xml')//tei:TEI">
                <!--TEIs-->
                <xsl:variable name="partOf">
                    <xsl:value-of select="concat(string(@xml:base), '/editions')"/>
                </xsl:variable>
                <xsl:variable name="id">
                    <xsl:value-of select="concat(string($TopColId), '/', string(@xml:id))"/>
                </xsl:variable>
                <xsl:variable name="facs-col">
                    <xsl:choose>
                        <xsl:when test=".//tei:sourceDesc//tei:edition/@n and .//tei:sourceDesc//tei:date/@when">
                            <xsl:value-of select="concat(string($TopColId), '/facsimiles/', 'vom-musikalisch-schoenen-', string(.//tei:sourceDesc//tei:edition/@n), '-auflage-', string(.//tei:sourceDesc//tei:date/@when))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(string($TopColId), '/facsimiles/', 'review-', string(@xml:id))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rc-title">
                    <xsl:choose>
                        <xsl:when test=".//tei:sourceDesc//tei:edition/@n and .//tei:sourceDesc//tei:date/@when">
                            <xsl:value-of select="concat(string(.//tei:titleStmt/tei:title[@type='main']), ' ', string(.//tei:sourceDesc//tei:edition/@n), '. Auflage', ' (', string(.//tei:sourceDesc//tei:date/@when), ')')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string(.//tei:titleStmt/tei:title[@type='main' or @level='a'][1])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <acdh:Resource rdf:about="{$id}">
                    <acdh:hasPid>create</acdh:hasPid>
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <acdh:hasTitle xml:lang="de">
                        <xsl:value-of select="concat('TEI/XML: ', .//tei:titleStmt/tei:title[@type='main'], ' ', .//tei:sourceDesc//tei:edition/@n, '. Auflage', ' (', .//tei:sourceDesc//tei:date/@when, ')')"/>
                        </acdh:hasTitle>
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:isPartOf rdf:resource="{$partOf}"/>
                    <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                    <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/ampfiel"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
                    <xsl:copy-of select="$constants"/>
                </acdh:Resource>
            </xsl:for-each>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-ehanslick-1854">
                <acdh:hasTitle xml:lang="de">Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst</acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1854-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">112 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">Rudolph Weigel</acdh:hasPublisher>
                <acdh:hasSeriesInformation xml:lang="de">1. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
            </acdh:Publication>
            <acdh:Resource rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/logo_font_blau.svg">
                <acdh:isPartOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen"/>
                <acdh:hasTitle xml:lang="de">Hanslick Online Logo</acdh:hasTitle>
                <acdh:hasPid>create</acdh:hasPid>
                <acdh:hasLicensor rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasContact rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                <acdh:hasOwner rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasDepositor rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                <acdh:hasCurator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                <acdh:hasMetadataCreator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                <acdh:hasRightsHolder rdf:resource="https://id.acdh.oeaw.ac.at/oeaw"/>
                <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/image"/>
                <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                <acdh:hasFormat>image/svg</acdh:hasFormat>
                <acdh:isTitleImageOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/image"/>
                <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/oreichl"/>
                <acdh:hasFunder rdf:resource="https://id.acdh.oeaw.ac.at/org-ma7"/>
            </acdh:Resource>
            <acdh:Metadata rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/vms.odd">
                <acdh:isPartOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/editions"/>
                <acdh:hasTitle xml:lang="de">TEI/XML Schema ODD für "Vom Musikalisch-Schönen"</acdh:hasTitle>
                <acdh:hasDescription xml:lang="de">TEI/XML Schema ODD für "Vom Musikalisch-Schönen"</acdh:hasDescription>
                <acdh:hasPid>create</acdh:hasPid>
                <acdh:hasLicensor rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasOwner rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasDepositor rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                <acdh:hasCurator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                <acdh:hasMetadataCreator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                <acdh:hasRightsHolder rdf:resource="https://id.acdh.oeaw.ac.at/oeaw"/>
                <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                <acdh:hasCreatedStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-19</acdh:hasCreatedStartDate>
                <acdh:hasCreatedEndDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-20</acdh:hasCreatedEndDate>
                <acdh:isMetadataFor rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/editions"/>
                <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
            </acdh:Metadata>
            <acdh:Metadata rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/vms.rng">
                <acdh:isPartOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-rezensionen/editions"/>
                <acdh:hasTitle xml:lang="de">TEI/XML Schema RNG für "Vom Musikalisch-Schönen"</acdh:hasTitle>
                <acdh:hasDescription xml:lang="de">TEI/XML Schema RNG für "Vom Musikalisch-Schönen"</acdh:hasDescription>
                <acdh:hasPid>create</acdh:hasPid>
                <acdh:hasLicensor rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasOwner rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasDepositor rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                <acdh:hasCurator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                <acdh:hasMetadataCreator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                <acdh:hasRightsHolder rdf:resource="https://id.acdh.oeaw.ac.at/oeaw"/>
                <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                <acdh:hasCreatedStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-19</acdh:hasCreatedStartDate>
                <acdh:hasCreatedEndDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-20</acdh:hasCreatedEndDate>
                <acdh:isMetadataFor rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/editions"/>
                <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
            </acdh:Metadata>
        </rdf:RDF>
    </xsl:template>   
</xsl:stylesheet>
