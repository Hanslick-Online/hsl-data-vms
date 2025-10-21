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
        <xsl:variable name="Meta">
            <xsl:value-of select="concat($TopColId, '/meta')"/>
        </xsl:variable>
         <xsl:variable name="Editions">
            <xsl:value-of select="concat($TopColId, '/editions')"/>
        </xsl:variable>
         <xsl:variable name="Indices">
            <xsl:value-of select="concat($TopColId, '/indices')"/>
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

            <xsl:for-each select=".//acdh:Collection[@rdf:about=$Editions or @rdf:about=$Indices]">
                <acdh:Collection>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                    <acdh:hasContributor rdf:resource="https://orcid.org/0000-0002-7722-4091"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/> 
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <acdh:hasMetadataCreator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <xsl:copy-of select="$constants"/>
                    <xsl:for-each select=".//acdh:*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </acdh:Collection>
            </xsl:for-each>

             <xsl:for-each select=".//acdh:Collection[@rdf:about=$Meta]">
                <acdh:Collection>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/> 
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <acdh:hasMetadataCreator rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <xsl:copy-of select="$constants"/>
                    <xsl:for-each select=".//acdh:*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </acdh:Collection>
            </xsl:for-each>


            <xsl:for-each select="collection('../data/editions?select=*.xml')//tei:TEI">
                <!--TEIs-->
                <xsl:variable name="listPersonDoc" select="document('../data/indices/listperson.xml')"/>
                <xsl:variable name="partOf">
                    <xsl:value-of select="concat(string(@xml:base), '/editions')"/>
                </xsl:variable>
                <xsl:variable name="id">
                    <xsl:value-of select="concat(string($TopColId), '/', string(@xml:id))"/>
                </xsl:variable>
                <!-- <xsl:variable name="facs-col">
                    <xsl:choose>
                        <xsl:when test=".//tei:sourceDesc//tei:edition/@n and .//tei:sourceDesc//tei:date/@when">
                            <xsl:value-of select="concat(string($TopColId), '/facsimiles/', 'vom-musikalisch-schoenen-', string(.//tei:sourceDesc//tei:edition/@n), '-auflage-', string(.//tei:sourceDesc//tei:date/@when))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(string($TopColId), '/facsimiles/', 'review-', string(@xml:id))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable> -->
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
                    <!-- <acdh:hasPid>create</acdh:hasPid> -->
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <acdh:hasTitle xml:lang="de">
                        <xsl:value-of select="concat('TEI/XML: ', .//tei:titleStmt/tei:title[@type='main'], ' ', .//tei:sourceDesc//tei:edition/@n, '. Auflage', ' (', .//tei:sourceDesc//tei:date/@when, ')')"/>
                        </acdh:hasTitle>
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:isPartOf rdf:resource="{$partOf}"/>
                    <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                    <acdh:hasEditor rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                    <acdh:hasEditor rdf:about="https://orcid.org/0000-0002-7722-4091">
                    <xsl:choose>
                        <xsl:when test=".//tei:titleStmt/tei:author/@ref">
                            <xsl:variable name="personId" select="substring-after(.//tei:titleStmt/tei:author/@ref, '#')"/>
                            <xsl:variable name="personNode" select="$listPersonDoc//tei:person[@xml:id=$personId]"/>
                            <xsl:variable name="authorName" select="normalize-space(concat(normalize-space($personNode//tei:persName[@type='main']/tei:forename), ' ', normalize-space($personNode//tei:persName[@type='main']/tei:surname)))"/>
                            <xsl:choose>
                                <xsl:when test="$personNode//tei:idno[@type='URI' and @subtype='GND']">
                                    <acdh:hasAuthor rdf:resource="{$personNode//tei:idno[@type='URI' and @subtype='GND'][1]}"/>
                                </xsl:when>
                                <xsl:when test="$personNode//tei:idno[@type='URI' and @subtype='WIKIDATA']">
                                    <acdh:hasAuthor rdf:resource="{$personNode//tei:idno[@type='URI' and @subtype='WIKIDATA'][1]}"/>
                                </xsl:when>
                                <xsl:when test="$personNode//tei:idno[@type='URI' and @subtype='ACDH']">
                                    <acdh:hasAuthor rdf:resource="{$personNode//tei:idno[@type='URI' and @subtype='ACDH'][1]}"/>
                                </xsl:when>
                                <xsl:when test="$authorName != 'Anonym'">
                                    <acdh:hasAuthor>
                                        <xsl:value-of select="$authorName"/>
                                    </acdh:hasAuthor>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                    <acdh:hasCustomCitation xml:lang="de">
                        <xsl:variable name="uniqueId" select="translate(@xml:id, '.', '_')"/>
                        <xsl:variable name="title" select=".//tei:titleStmt/tei:title[@type='main' or @level='a'][1]"/>
                        <xsl:variable name="authorName" select="if (.//tei:titleStmt/tei:author/@ref) then normalize-space(concat(normalize-space($listPersonDoc//tei:person[@xml:id=substring-after(current()//tei:titleStmt/tei:author/@ref, '#')]//tei:persName[@type='main']/tei:forename), ' ', normalize-space($listPersonDoc//tei:person[@xml:id=substring-after(current()//tei:titleStmt/tei:author/@ref, '#')]//tei:persName[@type='main']/tei:surname))) else ''"/>
                        <xsl:variable name="authorCitation">
                            <xsl:if test=".//tei:titleStmt/tei:author/@ref">
                                <xsl:variable name="personNode" select="$listPersonDoc//tei:person[@xml:id=substring-after(current()//tei:titleStmt/tei:author/@ref, '#')]"/>
                                <xsl:variable name="surname" select="normalize-space($personNode//tei:persName[@type='main']/tei:surname)"/>
                                <xsl:variable name="forename" select="normalize-space($personNode//tei:persName[@type='main']/tei:forename)"/>
                                <xsl:choose>
                                    <xsl:when test="$surname != '' and $forename != ''">
                                        <xsl:value-of select="concat($surname, ', ', $forename)"/>
                                    </xsl:when>
                                    <xsl:when test="$surname != ''">
                                        <xsl:value-of select="concat('{', $surname, '}')"/>
                                    </xsl:when>
                                    <xsl:when test="$forename != ''">
                                        <xsl:value-of select="concat('{', $forename, '}')"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:text>@incollection{Wilfing_2025_</xsl:text>
                        <xsl:value-of select="$uniqueId"/>
                        <xsl:text>,&#10;  title = {</xsl:text>
                        <xsl:value-of select="$title"/>
                        <xsl:text>},&#10;</xsl:text>
                        <xsl:if test="$authorName != '' and $authorName != 'Anonym'">
                            <xsl:text>  author = {</xsl:text>
                            <xsl:value-of select="$authorCitation"/>
                            <xsl:text>},&#10;</xsl:text>
                        </xsl:if>
                        <xsl:text>  date = {2025-10-16},&#10;  publisher = {ARCHE},&#10;  url = {</xsl:text>
                        <xsl:value-of select="concat(string($TopColId), '/', string(@xml:id))"/>
                        <xsl:text>},&#10;  editor = {Wilfing, Alexander AND Pfiel, Anna Anna-Maria},&#10;  language = {DE},&#10;  booktitle = {</xsl:text>
                        <xsl:value-of select="$rc-title"/>
                        <xsl:text>},&#10;  keywords = {Cultural heritage, Digital humanities, Musicology}&#10;}</xsl:text>
                    </acdh:hasCustomCitation>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
                    <xsl:copy-of select="$constants"/>
                </acdh:Resource>
            </xsl:for-each>

            <xsl:for-each select="collection('../data/indices?select=*.xml')//tei:TEI">
                <xsl:variable name="listPersonDoc" select="document('../data/indices/listperson.xml')"/>
                <xsl:variable name="id">
                    <xsl:value-of select="concat(string($TopColId), '/', string(@xml:id))"/>
                </xsl:variable>
                <acdh:Resource rdf:about="{$id}">
                    <acdh:hasPid>create</acdh:hasPid>
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <acdh:hasTitle xml:lang="de">
                        <xsl:value-of select="concat('TEI/XML: ', .//tei:titleStmt/tei:title[@type='main'])"/>
                    </acdh:hasTitle>
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:isPartOf rdf:resource="{$Indices}"/>
                    <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                    <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/awilfing"/>
                    <acdh:hasContributor rdf:resource="https://orcid.org/0000-0002-7722-4091"/>
                    <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
                    <xsl:if test="@xml:id = 'listperson.xml'">
                        <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                    </xsl:if>
                    <xsl:copy-of select="$constants"/>
                </acdh:Resource>
            </xsl:for-each>
            <acdh:Resource rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/logo_rezensionen.svg">
                <acdh:isPartOf rdf:resource="{$Meta}"/>
                <acdh:hasTitle xml:lang="de">Hanslick Online Logo: Rezensionen</acdh:hasTitle>
                <!--<acdh:hasPid>create</acdh:hasPid> -->
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
                <acdh:hasFormat>image/+xml</acdh:hasFormat>
                <acdh:isTitleImageOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/image"/>
                <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/oreichl"/>
                <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
                <acdh:hasFunder rdf:resource="https://id.acdh.oeaw.ac.at/org-ma7"/>
            </acdh:Resource>
            <acdh:Metadata rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/vms.odd">
                 <acdh:isPartOf rdf:resource="{$Meta}"/>
                <acdh:hasTitle xml:lang="de">XML/TEI Schema ODD für „Die Rezensionen zu Eduard Hanslicks „Vom Musikalisch-Schönen“ (1854–1857)“</acdh:hasTitle>
                <acdh:hasDescription xml:lang="de">XML/TEI Schema ODD für „Die Rezensionen zu Eduard Hanslicks „Vom Musikalisch-Schönen“ (1854–1857)“</acdh:hasDescription>
                <!-- <acdh:hasPid>create</acdh:hasPid> -->
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
                <acdh:hasCreatedEndDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2025-10-15</acdh:hasCreatedEndDate>
                <acdh:isMetadataFor rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/editions"/>
                <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
                <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
            </acdh:Metadata>
            <acdh:Metadata rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/vms.rng">
                                <acdh:isPartOf rdf:resource="{$Meta}"/>
                <acdh:hasTitle xml:lang="de">TEI/XML Schema RNG für „Die Rezensionen zu Eduard Hanslicks „Vom Musikalisch-Schönen“ (1854–1857)“</acdh:hasTitle>
                <acdh:hasDescription xml:lang="de">XML/TEI Schema RNG für „Die Rezensionen zu Eduard Hanslicks „Vom Musikalisch-Schönen“ (1854–1857)“</acdh:hasDescription>
                <!-- <acdh:hasPid>create</acdh:hasPid> -->
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
                <acdh:hasCreatedEndDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2025-10-15</acdh:hasCreatedEndDate>
                <acdh:isMetadataFor rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms-rezensionen/editions"/>
                <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/delsner"/>
                <acdh:hasContributor rdf:resource="https://id.acdh.oeaw.ac.at/fsanzlazaro"/>
            </acdh:Metadata>
        </rdf:RDF>
    </xsl:template>   
</xsl:stylesheet>
