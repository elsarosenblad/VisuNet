library(devtools)
library(R.ROSETTA)

ros<-rosetta(autcon,reducer='Genetic')

setwd("~/Documents/Roya/VisuNet-master")
load_all('.')


vis<-visunet(ros$main)
