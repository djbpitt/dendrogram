similarities<-scan('output.txt', sep=",") # read vector of reals
size = sqrt(length(similarities)) # to determine matrix dimensions
logs = log(similarities + 1) # reduce extreme variation
subtracted = max(logs) + 1 - logs # convert from similarity to dissimilarity
m = matrix(subtracted, nrow=size, ncol=size)
library(cluster)
labels<-scan('labels.txt',what='',sep=',')
clusters = agnes(m,diss=TRUE,method='complete')
labels<-scan('labels.txt','',sep=',')
par(cex=0.2)
svg('output.svg')
plot(clusters, labels=labels)
dev.off()

