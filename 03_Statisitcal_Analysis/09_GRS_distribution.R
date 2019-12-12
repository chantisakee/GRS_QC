library(data.table)
library(dplyr)
library(ggpubr)

# This code is used to visualize GRS distribution among Thai and 1000 Genome Project Phase 1 
# Score.profile: output file created by PLINK 1.9 (--score 'sum') from 08_statistical_analysis.sh in 1.2 calculate weighted and unweigted GRS
# Output file is available here (https://docs.google.com/spreadsheets/d/1MuvxvT7t_kfWTGqsW0k8HxOvtift6pEl2G0wObLPh4I/edit?ts=5d6ccdf2#gid=1542574829)


#Prepare Population code to annotate ethnicity in score file
pop_list <- fread("../../../population_code/population-p1.list",header = FALSE) %>% setnames(c("V1","V2","V3"),c("FID","Population","Ethnic"))

#read score file from PLINK output
df_Thai <- fread(score.profile)

#Annotating Ethnicity
cdat <- merge(pop_list,df_Thai, all = TRUE) 
cdat[is.na(cdat)] <- "Thai"
cdat[,8] <- sapply(cdat[,8], as.numeric)

#summarize score across populations
plyr::ddply(cdat,~Ethnic,summarise,mean=mean(SCORESUM),sd=sd(SCORESUM))

mean_Thai <- cdat %>% filter(Ethnic == "Thai")

# plot the result
ggboxplot(cdat, x = "Ethnic", y = "SCORESUM", color = "Ethnic",
          add.params = list(fill = "white"),add = "jitter")+
  rotate_x_text(angle = 45)+
  geom_hline(yintercept = mean(mean_Thai$SCORESUM), linetype = 2)+ # Add horizontal line at base mean
  stat_compare_means(method = "anova",label.y = -150)+        # Add global annova p-value
  stat_compare_means(method = "t.test",
                     ref.group = "Thai",label.y = -200, hide.ns = TRUE) +
  xlab("Ethnicity") +
  ylab("wGRS") +
  theme(legend.position="right") +
  theme_bw()

