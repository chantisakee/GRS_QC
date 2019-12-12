library(ggplot2)
library(dplyr)
library(data.table)

#df.txt: GRS derived from 08_Statistical_analysis.sh
pop_list <- fread("../../../population_code/population-p1.list",header = FALSE) %>% setnames(c("V1","V2","V3"),c("FID","Population","Ethnic"))
wGRS <- fread(df.txt) %>% setnames("SCORESUM","wGRS")
uGRS <- fread(df.txt) %>% setnames("SCORESUM","uGRS")
cdat <- inner_join(uGRS,wGRS,by= "FID")

#Annotating Ethnicity
cdat_ethnic <- merge(pop_list,cdat, all = TRUE) 
cdat_ethnic[is.na(cdat_ethnic)] <- "Thai"


ggplot(cdat_ethnic, aes(x=wGRS, y=uGRS, color=Ethnic, shape=Ethnic)) +
  geom_point() + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  stat_cor(size = 3) +
  theme_bw()
