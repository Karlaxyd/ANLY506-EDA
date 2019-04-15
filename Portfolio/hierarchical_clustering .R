library(tidyverse) # data manipulation
library(cluster) # clustering algorithms
library(factoextra) # clustering visualization
library(dendextend) # for comparing two dendrograms

data(USArrests)

df <- USArrests

##To remove any missing value that might be present in the data
df <- na.omit(df)

##scaling/standardizing the data
df <- scale(df)
head(df)

##Agglomerative Hierarchical Clustering

# Dissimilarity matrix
d <- dist(df, method = "euclidean")

# Hierarchical clustering using Complete Linkage
hc1 <- hclust(d, method = "complete" )

# Plot the obtained dendrogram
plot(hc1, cex = 0.6, hang = -1)

# Alternatively we can use the agnes function
# Compute with agnes
hc2 <- agnes(df, method = "complete")
hc_quiz_q6 <- agnes(df, method = "single")

# Agglomerative coefficient
hc2$ac
hc_quiz_q6$ac

hc_quiz_q7 <- hclust(d, method = "ward.D")
plot(hc_quiz_q7, cex = 0.6, hang = -1)
cutree(hc_quiz_q7, h = 10)

# methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")
# function to compute coefficient
ac <- function(x) {
  agnes(df, method = x)$ac
}
map_dbl(m, ac)

##we see that Ward’s method identifies the strongest clustering structure of the four methods assessed

##Visualizing the dendogram

hc3 <- agnes(df, method = "ward")
pltree(hc3, cex = 0.6, hang = -1, main = "Dendrogram of agnes") 

##Divisive Hierarchical Clustering

# compute divisive hierarchical clustering
hc4 <- diana(df)
# Divise coefficient; amount of clustering structure found
hc4$dc

# plot dendrogram
pltree(hc4, cex = 0.6, hang = -1, main = "Dendrogram of diana")

##Identifying sub-groups i.e. clusters

# Ward's method
hc5 <- hclust(d, method = "ward.D2" )
# Cut tree into 4 groups
sub_grp <- cutree(hc5, k = 4)
# Number of members in each cluster
table(sub_grp)

##Add cluster column to see which cluster does an obs. belong to

USArrests %>%
  mutate(cluster = sub_grp) %>%
  head

##Drawing the dendogram with a border around the clusters

plot(hc5, cex = 0.6)
rect.hclust(hc5, k = 4, border = 2:5)

##use the fviz_cluster function from the factoextra package to
##visualize the result in a scatter plot.

fviz_cluster(list(data = df, cluster = sub_grp))

##Using cutree with agnes and diana

# Cut agnes() tree into 4 groups
hc_a <- agnes(df, method = "ward")
cutree(as.hclust(hc_a), k = 4)
# Cut diana() tree into 4 groups
hc_d <- diana(df)
cutree(as.hclust(hc_d), k = 4)

##Comparing the two dendograms with the function tanglegram

# Compute distance matrix
res.dist <- dist(df, method = "euclidean")

# Compute 2 hierarchical clusterings
hc1 <- hclust(res.dist, method = "complete")
hc2 <- hclust(res.dist, method = "ward.D2")

# Create two dendrograms
dend1 <- as.dendrogram (hc1)
dend2 <- as.dendrogram (hc2)

tanglegram(dend1, dend2)

##Customizing the output of tangleram

dend_list <- dendlist(dend1, dend2)

tanglegram(dend1, dend2,
           highlight_distinct_edges = FALSE, # Turn-off dashed lines
           common_subtrees_color_lines = FALSE, # Turn-off line colors
           common_subtrees_color_branches = TRUE, # Color common branches 
           main = paste("entanglement =", round(entanglement(dend_list), 2))
)

##Determing Optimal Clusters

# Elbow Method
fviz_nbclust(df, FUN = hcut, method = "wss")

# Average Silhouette Method
fviz_nbclust(df, FUN = hcut, method = "silhouette")

# Gap Statistic Method
gap_stat <- clusGap(df, FUN = hcut, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)