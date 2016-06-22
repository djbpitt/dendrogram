library(dendextend)
library(dendextendRcpp)
setwd("~/Dropbox/repertorium/2013-08-03_sofia/dendrogram")
similarities<-scan('output.txt', sep=",") # read vector of reals
size = sqrt(length(similarities)) # to determine matrix dimensions
logs = log(similarities + 1) # reduce extreme variation
subtracted = max(logs) + 1 - logs # convert from similarity to dissimilarity
m = matrix(subtracted, nrow=size, ncol=size) # create a matrix object
labels<-scan('labels.txt',what='',sep=',')

for (currentMethod in c('complete', 'ward.D2')){
  dend <-  as.dist(m)  %>% # convert matrix to dist object and then cluster and convert to dendrogram object
    hclust(method = currentMethod) %>% # use hclust to cluster (can't accept non-dist matrix, unlike agnes)
    as.dendrogram # it's possible to plot an hclust object, but better to convert to dendrogram object to make it pretty later
  orderFile<-file(paste(currentMethod,'.colored.order.txt',sep=''))
  writeLines(toString(unlist(dend["order"])), orderFile)
  close(orderFile)
  svg(paste(currentMethod,'.colored.svg',sep=''))
  dend %>% set("labels", labels) %>% # prepare to use labels when plotting later
    set("labels_cex", 0.225) %>% # make the label text small
    set("branches_k_color", k = 7, value = 1:9) %>% # number of partitions and colors
    set("branches_lwd", 0.5) %>% # thin lines
    hang.dendrogram %>% # pull labels up to lines
    sort %>% # sort by labels alphabetically (as much as possible) in preparation for tanglegram
    plot
  # rect.dendrogram(dend, k = 7, lwd = 0.5, border = 1:9) # match number of partitions and colors; thin lines
  dev.off()
}