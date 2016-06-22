#! /bin/bash
shopt -s expand_aliases
/usr/local/bin/R --vanilla < dev.R
java -Xmx4g  -DentityExpansionLimit=500000 -jar /opt/saxon/saxon9he.jar -s:complete.svg -xsl:add-links-to-dendrogram.xsl -o:complete-repertorium.svg
java -Xmx4g  -DentityExpansionLimit=500000 -jar /opt/saxon/saxon9he.jar -s:ward.svg -xsl:add-links-to-dendrogram.xsl -o:ward-repertorium.svg
/usr/local/bin/R --vanilla < colored.R
java -Xmx4g  -DentityExpansionLimit=500000 -jar /opt/saxon/saxon9he.jar -s:colored.svg -xsl:add-links-to-colored-dendrogram.xsl -o:ward-colored-repertorium.svg
