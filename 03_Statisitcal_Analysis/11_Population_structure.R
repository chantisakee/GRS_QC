#Package Preparation
library(dplyr)
library(ggplot2)
library(data.table)

#This scripts plot output of PCA result among Thai and 1000 Genome Project Phase 3 (1KGp3) against all population and East Asian only.
#Principal component was calculated by using PLINK 1.9 (--pca) from 08_statistical_analysis.sh in 2.1  PCA plot among Thai sample and 1KGp3

#pop_list: dataframe of all sample from 1KGp3
#Disease-all.eigenvec: dataframe containing principal component of every sample produced by PLINK 1.9
#Disease-eas.eigenvec: dataframe containing principal component of EAS sample only produced by PLINK 1.9

# prepare population list for annotating with eigenvector dataframe
pop_list <- fread("ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel",header = F,select = c(1,2,3)) %>% setnames(c("V1","V2","V3"),c("sample","pop","super_pop"))

# preparing for plotting PCA in Thai population and all 1KGp3 populations
principal_all_population <- fread(Disease-all.eigenvec) %>% setnames(c("V1","V2","V3"),c("sample","pc1","pc2"))
#Annotating ethnic group with eigenvector dataframe.
Annotate_Ethnic_all <- merge(pop_list,principal_all_population,by="sample", all = T) %>% setnames("super_pop","Populations")
Annotate_Ethnic_all[is.na(plot_annotate_ethnic)] <- "Thai" 

# preparing for plotting PCA in Thai population and East Asian
principal_eas <- fread(Disease-eas.eigenvec) %>% setnames(c("V1","V2","V3"),c("sample","pc1","pc2"))
#selecting East Asian population to annotate Ethnic column in principal_eas dataframe
select_EAS <- pop_list[pop_list$super_pop == "EAS",]
Annotate_Ethnic_EAS <- merge(pop_list,select_EAS,by="sample", all = T) %>% setnames("pop","Populations")
Annotate_Ethnic_EAS[is.na(Annotate_Ethnic_EAS)] <- "Thai" 


# plotting scatter plot between pc1 and pc2 to visualize population structure.

# Thai and Every 1KGp3 Population
ggplot(Annotate_Ethnic_all, aes(x = pc1, y = pc2)) + 
  geom_point(aes(shape = Populations, color = Populations),size = 2)+ 
  xlab("PC1 (15.45 %)") +
  ylab("PC2 (11.65%)") +
  theme_minimal() +
  theme(legend.position = "right")


# Thai and East Asian
ggplot(plot_annotate_ethnic, aes(x = pc1, y = pc2)) + 
  geom_point(aes(shape = Populations, color = Populations),size = 2)+ 
  xlab("PC1 (24 %)") +
  ylab("PC2 (9%)") +
  theme_minimal() +
  theme(legend.position = "right") +
  labs("Populations")


# Plotting Map in South East Asia region to provide visual aid for closely related population to Thai

some.eu.countries <- c(
  "China", "laos", "Myanmar", "Cambodia", "Vietnam","Japan","Thai"
)

# Selecting Country
cities = c("CHB","CHS","CDX","JPT","KHV","Thailand")
coors <- data.frame(
  lat = c(39.916668,35.86166,22.007351,35.652832,10.762622,13.690419),
  long = c(116.383331,104.195397,100.797775,139.839478,106.660172,101.077957),
  stringsAsFactors = FALSE
)
coors$cities <- cities

# Retrievethe map data
some.eu.maps <- map_data("world", region = some.eu.countries) 
#Plotting map
ggplot(some.eu.maps, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = region), alpha=0.5,colour = "white")+
  geom_text(aes(label = cities), data = coors,size = 3,hjust=1.2)+
  scale_fill_viridis_d()+
  geom_point(data=coors, aes(long, lat, colour=cities,shape=cities), size=2) +
  theme_void()+
  theme(legend.position = "none")
