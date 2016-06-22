<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text"/>
    <xsl:param name="filename" select="base-uri()"/>
    <xsl:template match="/">
        <xsl:value-of
            select="concat(substring-before(tokenize($filename, '/')[last()], '.svg'), '.order.txt&#x0a;')"
        />
    </xsl:template>
</xsl:stylesheet>
