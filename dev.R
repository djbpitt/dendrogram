setwd("~/Dropbox/repertorium/2013-08-03_sofia/dendrogram")
similarities<-scan('output.txt', sep=",") # read vector of reals
size = sqrt(length(similarities)) # to determine matrix dimensions
logs = log(similarities + 1) # reduce extreme variation
subtracted = max(logs) + 1 - logs # convert from similarity to dissimilarity
m = matrix(subtracted, nrow=size, ncol=size)
library(cluster)
labels<-scan('labels.txt',what='',sep=',')
# Methods: average, single, complete, ward, weighted 
#   Omit flexible and gavarage, which are the same as weighted
clusters = agnes(m,diss=TRUE,method='complete')
labels<-scan('labels.txt','',sep=',')
par(cex=0.2)
svg('complete.svg')
plot(clusters, labels=labels, which.plots = 2, cex = 0.2, cex.main = 0.5, cex.lab = 0.5, cex.axis = 0.5, cex.sub = 0.5)
dev.off()