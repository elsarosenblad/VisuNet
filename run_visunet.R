library(R.ROSETTA)
library(devtools)

# load your development version of VisuNet
load_all("~/Documents/Forskningspraktik/VisuNet")

ros <- rosetta(autcon)
vis <- visunet(ros$main)