library(data.table)
library(corrplot)
library(PerformanceAnalytics)
library(ggplot2)
library(reshape)

# This code is used to calculate correlation Risk Allele Frequency between Thai population from merged RIKEN I & II and 1000 Genome Project Phase1
# MAF was produced by PLINK1.9 from 08_statistical_analysis.sh in 1.3 Extract Risk Allele Frequency
## Output file is available here (https://docs.google.com/spreadsheets/d/1MuvxvT7t_kfWTGqsW0k8HxOvtift6pEl2G0wObLPh4I/edit?ts=5d6ccdf2#gid=2034486253)

#Example.frq: long format dataframe with risk allele frequency. For example,
#      SNP     RAF    ethnic
# rs10139550 0.65310   Thai
# rs10139550 0.54490    EUR
# rs10139550 0.62590    ASN
# rs10139550 0.62430    AMR
# rs10139550 0.69310    AFR


# read data from long format dataframe

MAF <- fread(Example.frq)

# Convert long format into wide format for plotting
wdat_01 <- reshape(MAF, idvar = "SNP", timevar = "ethnic", direction = "wide") %>% setnames(c("RAF.Thai","RAF.EUR","RAF.AMR","RAF.AFR","RAF.ASN"),c("Thai","EUR","AMR","AFR","ASN"))
wdat_02 <- data.frame(wdat_01,row.names = T)
wdat_02 <- wdat_02[ , c("Thai", "EUR", "ASN", "AMR","AFR")]

#plotting RAF correaltion plot
chart.Correlation(wdat_02, histogram=TRUE, pch=10, method = "spearman")

