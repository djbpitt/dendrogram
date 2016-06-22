# dendextend can colorize and draw rectangles
library(dendextend)
library(dendextendRcpp)
# palate of dark ColorBrewer colors
library(RColorBrewer)
# main routine
setwd("~/Dropbox/repertorium/2013-08-03_sofia/dendrogram")
similarities<-scan('output.txt', sep=",") # read vector of reals
size = sqrt(length(similarities)) # to determine matrix dimensions
logs = log(similarities + 1) # reduce extreme variation
subtracted = max(logs) + 1 - logs # convert from similarity to dissimilarity
m = matrix(subtracted, nrow=size, ncol=size) # create a matrix object
labels<-scan('labels.txt',what='',sep=',')
how_many = 10
colors = brewer.pal(how_many, "Dark2")
rownames(m)<-labels #labels are set at rownames() with hclust, not during plotting

clusters <-  as.dist(m)  %>% # convert matrix to dist object (hclust can't accept non-dist matrix, unlike agnes)
  hclust(method = "ward.D2") # use hclust to cluster

# Write order information to attach links later
orderFile<-file('colored.order.txt')
writeLines(toString(unlist(clusters["order"])), orderFile)
close(orderFile)

dend <- as.dendrogram(clusters) # it's possible to plot an hclust object, but better to convert to dendrogram object to make it pretty later

svg('colored.svg')
par(cex=0.5)
dend %>% 
  # set("labels", labels) %>% # prepare to use labels when plotting later - 
  set("labels_cex", 0.5) %>% # make the label text small
  set("branches_k_color", k = how_many, value = colors) %>% # number of partitions and ColorBrewer colors
  set("branches_lwd", 0.6) %>% # thin lines
  hang.dendrogram %>% # pull labels up to lines
  # sort %>% # sort by labels alphabetically (as much as possible)
  plot(main = paste('Repertorium corpus, Ward linkage, ', size, 'manuscripts'))

rect.dendrogram(dend, k = how_many, lwd = 0.6, border = colors) # match number of partitions and colors; thin lines
dev.off()