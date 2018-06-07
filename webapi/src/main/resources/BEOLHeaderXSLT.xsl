<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:beol="http://0.0.0.0:3333/ontology/0801/beol/v2#"
               xmlns:knora-api="http://api.knora.org/ontology/knora-api/v2#"
               exclude-result-prefixes="rdf beol knora-api xs"
               version="2.0">

    <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

    <xsl:function name="knora-api:iaf" as="xs:string">
        <xsl:param name="input" as="xs:string"/>
        <xsl:value-of select="replace($input, '\(DE-588\)', 'http://d-nb.info/gnd/')"/>
    </xsl:function>

    <xsl:template match="rdf:RDF">
        <profileDesc>
            <xsl:variable name="resourceIri" select="beol:letter/@rdf:about"/>
            <correspDesc>
                <xsl:attribute name="ref"><xsl:value-of select="$resourceIri"/></xsl:attribute>
                <xsl:apply-templates/>
            </correspDesc>
        </profileDesc>
    </xsl:template>

    <xsl:template match="beol:letter/beol:hasAuthorValue">
        <xsl:variable name="authorValue" select="@rdf:resource"/>

        <xsl:variable name="authorIAFValue" select="//knora-api:LinkValue[@rdf:about=$authorValue]//beol:hasIAFIdentifier/@rdf:resource"/>
        <xsl:variable name="authorFamilyNameValue" select="//knora-api:LinkValue[@rdf:about=$authorValue]//beol:hasFamilyName/@rdf:resource"/>
        <xsl:variable name="authorGivenNameValue" select="//knora-api:LinkValue[@rdf:about=$authorValue]//beol:hasGivenName/@rdf:resource"/>

        <correspAction type="sent">

            <xsl:variable name="authorIAFText" select="//knora-api:TextValue[@rdf:about=$authorIAFValue]/knora-api:valueAsString/text()"/>
            <xsl:variable name="authorFamilyNameText" select="//knora-api:TextValue[@rdf:about=$authorFamilyNameValue]/knora-api:valueAsString/text()"/>
            <xsl:variable name="authorGivenNameText" select="//knora-api:TextValue[@rdf:about=$authorGivenNameValue]/knora-api:valueAsString/text()"/>

            <persName>
                <xsl:attribute name="ref"><xsl:value-of select="knora-api:iaf($authorIAFText)"/></xsl:attribute>
                <xsl:value-of select="$authorFamilyNameText"/>, <xsl:value-of select="$authorGivenNameText"/>
            </persName>

            <xsl:call-template name="creationDate"/>

        </correspAction>
    </xsl:template>

    <xsl:template name="creationDate">
        <xsl:variable name="dateValue" select="//beol:creationDate/@rdf:resource"/>

        <xsl:variable name="dateText" select="//knora-api:DateValue[@rdf:about=$dateValue]/knora-api:valueAsString/text()"/>

        <date>
            <xsl:attribute name="when"><xsl:value-of select="$dateText"/></xsl:attribute>
        </date>
    </xsl:template>

    <xsl:template match="beol:letter/beol:hasRecipientValue">
        <xsl:variable name="recipientValue" select="@rdf:resource"/>

        <xsl:variable name="recipientIAFValue" select="//knora-api:LinkValue[@rdf:about=$recipientValue]//beol:hasIAFIdentifier/@rdf:resource"/>
        <xsl:variable name="recipientFamilyNameValue" select="//knora-api:LinkValue[@rdf:about=$recipientValue]//beol:hasFamilyName/@rdf:resource"/>
        <xsl:variable name="recipientGivenNameValue" select="//knora-api:LinkValue[@rdf:about=$recipientValue]//beol:hasGivenName/@rdf:resource"/>

        <correspAction type="received">

            <xsl:variable name="recipientIAFText" select="//knora-api:TextValue[@rdf:about=$recipientIAFValue]/knora-api:valueAsString/text()"/>
            <xsl:variable name="recipientFamilyNameText" select="//knora-api:TextValue[@rdf:about=$recipientFamilyNameValue]/knora-api:valueAsString/text()"/>
            <xsl:variable name="recipientGivenNameText" select="//knora-api:TextValue[@rdf:about=$recipientGivenNameValue]/knora-api:valueAsString/text()"/>

            <persName>
                <xsl:attribute name="ref"><xsl:value-of select="knora-api:iaf($recipientIAFText)"/></xsl:attribute>
                <xsl:value-of select="$recipientFamilyNameText"/>, <xsl:value-of select="$recipientGivenNameText"/>
            </persName>

        </correspAction>
    </xsl:template>

    <!-- ignore text if there is no template for the element containing it -->
    <xsl:template match="text()">

    </xsl:template>


</xsl:transform>