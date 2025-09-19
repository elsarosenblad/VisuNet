library(R.ROSETTA)
library(devtools)

# load your development version of VisuNet
load_all("~/Documents/Forskningspraktik/VisuNet")

ros <- rosetta(autcon)
vis <- visunet(ros$main)

# # # Original behavior (means)
# vis_mean <- visunet(ros$main, agg_method = "mean")
# 
# # New behavior (sums for node size)
# # vis_sum  <- visunet(ros$main, agg_method = "sum")
