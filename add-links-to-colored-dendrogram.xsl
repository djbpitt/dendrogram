<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg"
    xpath-default-namespace="http://www.w3.org/2000/svg" exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="order" as="xs:string+"
        select="tokenize(unparsed-text('colored.order.txt'), ', ')"/>
    <xsl:variable name="labels" as="xs:string+"
        select="tokenize('AA1322NBKM,AA1348NBKM,AA308NBKM,AA325NBKM,AA36NBB,AA53NBB,AA698NBKM,AA724NBKM,AA761NBKM,AA771NBKM,AM1-102O,AM1-103O,AM1-108O,AM100MCB,AM104NBB,AM109PAT,AM1161CM,AM11ODES,AM13225S,AM13410S,AM13613S,AM149NBW,AM17DUJC,AM241HLU,AM29SAV,AM2_23RM,AM305NBB,AM309NBKM,AM326NBKM,AM38NBB,AM39A,AM3_6RM,AM413BDL,AM433NBKM,AM4_14RM,AM52NIK,AM677NBKM,AM738NBB,AM740DAB,AM76NBW,AM828NBB,AM82NIK,AMA797Stock,AMAdd19393BL,AMAdd27442BL,AMAdd39628BBL,AS1052NBKM,AS1053NBKM,AS1055NBKM,AS22PANT,AS26054W,AS447BAB,AS681NBKM,AS685NBKM,AS9D15MP,AS9H10MP,DA1039NBKM,DA3a48HAZU,DA3c24HAZU,DA4d106HAZU,DA9E25PNM,DAGrig15IIRGB,DAGrig15IRGB,DALovech,DD1118NBKM,DD1170NBKM,DD295NBKM,DD296NBKM,DD310NBKM,DD312NBKM,DD333NBKM,DD437NBKM,DD684NBKM,DR10Upps,DR124CIAI,DR1415NBKM,DR149PNB,DR1NSIN,DR248NBKM,DR24Upps,DR280CIAI,DR43CIAI,DR54CIAI,DR57CIAI,DR621NBKM,DR940CIAI,DR944CIAI,DR971NBKM,DR972NBKM,DRA787a10Stock,DRA787a15Stock,DRA787a16Stock,DRA787a18Stock,DRA787a21Stock,DRA787a23Stock,DRA787a6Stock,DRA787Stock,DRAdd12069BL,DRAdd15715BL,DRAdd16373BL,DRAdd1860BL,DRAdd22713BL,DRAdd39625BL,DRAdd39626BL,DRAdd39627BBL,DRAdd5232ABL,DRAdd5232BBL,DRAdd8245BL,ET1_22RM,ET1_26RM,ET1_27RM,ET270NBKM,ET47CIAI,ET4_29RM,ET5_13RM,ET5_32RM,ET986NBKM,ET987NBKM,IK198MatichNBB,IK1RSL,IKIXH16NM,MD1143NBKM,MD13518RAN,MD838NBKM,MD845NBKM,MD846NBKM,MD923NBKM,MDManoil,MDMarianus,MJMUZ3483GMM,MP408G,MP95DECH,MPSuprasliensis,MY13Upps,MY15Upps,MY16Upps,MY2Upps,MY3Upps,MY5Upps,MY6Upps,MY7Upps,MY9Upps,MYA787a9Stock,MYA857Stock,NG13317S,NG1497PBS,NG2BAN,NG2VAT,NG320BAB,NG376PBS,NG38GMM,NG434HIL,NG649BAB,NG97BAB,RS518NBKM,RSIIIa20,Sinaiticus34', ',')"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="svg">
        <xsl:copy>
            <xsl:apply-templates select="@* except (@height | @width)"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="rect[starts-with(../@id, 'surface')]">
        <xsl:copy>
            <xsl:apply-templates select="@* except @style"/>
            <xsl:attribute name="style" select="'fill:#f4eee2;fill-opacity:0;stroke:none;'"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <!--
            Surface structure is:
            1 <rect> for background
            7 <path> elements for Y axis and tick lines
            7 <g> elements for numerical labels on Y axis followed by main title
            mixture of <path> and <g> elements for lines and sigla, end on the last <g> element
            10 <path> elements for the rectangles
            
            Path to ms sigla: g[starts-with(@id,'surface')]/g[count(preceding-sibling::g) ge 7]
        -->
    <xsl:template match="g[starts-with(@id, 'surface')]/g[count(preceding-sibling::g) ge 7]">
        <xsl:variable name="position" as="xs:integer" select="count(preceding-sibling::g) - 6"/>
        <xsl:copy>
            <xsl:apply-templates select="@* except @style"/>
            <xsl:attribute name="fill"
                select="
                    if ($position le count($labels)) then
                        'blue'
                    else
                        'black'"/>
            <xsl:attribute name="fill-opacity" select="1"/>
            <xsl:choose>
                <xsl:when test="$position le count($labels)">
                    <a
                        xlink:href="http://repertorium.obdurodon.org/readFile.php?filename={$labels[number($order[$position])]}.xml">
                        <rect x="{use[1]/@x - 1.6}" y="{use[last()]/@y - 1.5}" width="1.6"
                            height="{number(use[1]/@y) - number(use[last()]/@y) + 2}" opacity="0"/>
                        <xsl:apply-templates select="node()"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
