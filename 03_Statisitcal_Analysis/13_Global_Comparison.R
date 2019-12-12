library(data.table)
library(ggplot2)
library(dplyr)
library(ggrepel)

### This script aim to comparing Thai'GRS mean with global reference and plotting along with mortality rate and heritability ###
#df.txt: GRS of five NCDs calculated by PLINK1.9 derived from 08_statisical_analysis.sh (1.2 calculate weighted and unweigted GRS)
#Heritability derived from SNPedia (https://www.snpedia.com/index.php/Heritability)
#For CAD derived from (https://www.ncbi.nlm.nih.gov/pubmed/11665307)
#for COPD (FEV1,FVC, and FEV1/FVC ratio) derived from (https://www.jacionline.org/article/S0091-6749(13)00986-X/pdf)

#Mortality rate derived from WHO (https://www.who.int/healthinfo/global_burden_disease/estimates/en/index1.html)



Compare_Mean <- function(df){
    perc.rank <- function(x) (trunc(rank(x))/length(x))*100
    GRS <-  fread(df)
    population_list <- fread("../../../population_code/all.pop",header = F) %>% setnames("V1","FID")
    GRS_global <- inner_join(population_list,GRS,by="FID")
    GRS_Thai <- GRS[c(1:1806),]
    GRS_Thai$Ethnic <- "Thai"
    GRS_global$Ethnic <- "Global"
    #extract column 
    cdat <- rbind(GRS_Thai[,c(7,6)],GRS_global[c(9,8)])
    res <- t.test(SCORESUM ~ Ethnic, data = cdat)  #compared mean between Thai and Global population.
    cdat$pvalue <- res$p.value 
    print(res)
    cdat
  }

CAD_thai <- Compare_Mean(df.txt)
CAD_thai$disease <- "CAD"
CAD_thai$Heritability <- 0.55
CAD_thai$mortality_rate <- 60.4
CAD_thai$`Compared with Global Population` <- "Thai > Global Average"
CAD_thai_02 <- CAD_thai[1,c(4,5,6,7)]


DM_thai <- Compare_Mean(df.txt)
DM_thai$disease <- "DM"
DM_thai$Heritability <- 0.26
DM_thai$mortality_rate <- 23.9
DM_thai$`Compared with Global Population` <- "Thai < Global Average"
DM_thai_02 <- DM_thai[1,c(4,5,6,7)]


ST_thai <- Compare_Mean(df.txt)
ST_thai$disease <- "ST"
ST_thai$Heritability <- 0.32
ST_thai$mortality_rate <- 46.2
ST_thai$`Compared with Global Population` <- "Thai > Global Average"
ST_thai_02 <- ST_thai[1,c(4,5,6,7)]


DBP_thai <- Compare_Mean(df.txt)
DBP_thai$disease <- "DBP" 
DBP_thai$Heritability <-  0.49
DBP_thai$mortality_rate <- 2.3
DBP_thai$`Compared with Global Population` <- "Thai > Global Average"
DBP_thai_02 <- DBP_thai[1,c(4,5,6,7)]


SBP_thai <- Compare_Mean(df.txt)
SBP_thai$disease <- "SBP"
SBP_thai$Heritability <- .30
SBP_thai$mortality_rate <- 2.3
SBP_thai$`Compared with Global Population` <- "Thai > Global Average"
SBP_thai_02 <- SBP_thai[1,c(4,5,6,7)]


FEV_thai <- Compare_Mean(df.txt)
FEV_thai$disease <- "FEV" 
FEV_thai$Heritability <-  0.40
FEV_thai$mortality_rate <- 26.8
FEV_thai$`Compared with Global Population` <- "Thai < Global Average"
FEV_thai_02 <- FEV_thai[1,c(4,5,6,7)]


FVC_thai <- Compare_Mean(df.txt)
FVC_thai$disease <- "FVC"
FVC_thai$Heritability <- 0.70
FVC_thai$mortality_rate <- 26.8
FVC_thai$`Compared with Global Population` <- "Thai > Global Average"
FVC_thai_02 <- FVC_thai[1,c(4,5,6,7)]

ratio_thai <- Compare_Mean(df.txt)
ratio_thai$disease <- "FEV1/FVC ratio"
ratio_thai$Heritability <- 0.91
ratio_thai$mortality_rate <- 26.8
ratio_thai$`Compared with Global Population` <- "Thai > Global Average"
ratio_thai_02 <- ratio_thai[1,c(4,5,6,7)]

cdat <- rbind(CAD_thai_02,DM_thai_02,ST_thai_02,DBP_thai_02,SBP_thai_02,FEV_thai_02,FVC_thai_02,ratio_thai_02)

cdat$`Compared with Global Population` <- factor(cdat$`Compared with Global Population`, levels=c("Thai > Global Average",
                                           "Thai < Global Average"))

rownames(cdat) = cdat$disease

ggplot(cdat, aes(mortality_rate, Heritability, color=`Compared with Global Population`)) +
  geom_point(alpha= 0.6,size = 5) +
  geom_text_repel(aes(mortality_rate,Heritability,label = rownames(cdat)),
                  size = 4,
                  family = 'Times',
                  fontface = 'bold',box.padding = unit(0.5, 'lines'),
                  # Add extra padding around each data point.
                  point.padding = unit(0.5, 'lines'),
                  # Color of the line segments.
                  segment.color = '#cccccc',
                  # Width of the line segments.
                  segment.size = 0.5,
                  # Draw an arrow from the label to the data point.
                  arrow = arrow(length = unit(0.01, 'npc')),
                  # Strength of the repulsion force.
                  force = 1,
                  # Maximum iterations of the naive repulsion algorithm O(n^2).
                  max.iter = 3e3,
                  colour = 'black') +
  theme_bw() +
  xlab("Mortality rate per 100,000 individuals") +
  ylab("Proportion") +
  geom_hline(yintercept=0.5, linetype="dashed", 
             color = "grey", size=0.5) +
  geom_vline(xintercept = 30.2, linetype="dashed", 
               color = "grey", size=0.5) +
  ylab("Heritability") + scale_color_manual(breaks = c("Thai > Global Average",
                                                       "Thai < Global Average"),
                                            values=c("red", "grey")) +
  ylim(c(0,1))

