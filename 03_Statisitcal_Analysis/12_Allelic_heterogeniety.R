library(ggpubr)
library(ggplot2)
library(ggrepel)
## Rscript for calculating wilcoxon wilcoxon Mann Whitney test to investigate allelic heterogeniety in DM ##
## Snplist.txt: the list of SNPs in the summary statisitcs of interest (one SNPs per line)
## "count_RAF/Thai_",as.character(snp[var,]),".profile": this refers to unweighted genetic risk score per one SNP derived from 08_statistical_analysis.sh (3. Calcuate allelic Heterogeniety) 
## Ethnic_MAF.txt: RAF between Thai and target population (ASN in this case). Fire format shown as below.
#SNP	RAF	ethnic
#rs10811661	0.5629	ASN
#rs10830963	0.4371	ASN
#rs10811661	0.6321	Thai
#rs10830963	0.4244	Thai

## AnnotateSNPs.txt: SNPs with annotating information such as Gene and log (odd ratio). file format shown below.
#Gene	SNP	MAF	log(odd ratio)
#PPARG	rs4684847	0.07	0.12
#NOTCH2	rs10923931	0.85	0.06
#GRB14	rs3923113	0.38	0.05

pvalue <-c()
for(var in 1:52) { 
snp <- fread(snplist.txt,header = F)
THAI <- fread(paste("../../../tmp/count_RAF/DM/Thai/Thai_",as.character(snp[var,]),".profile",sep=""))[,6]
THAI$ethnic <- "THAI"
ASN <- fread(paste("../../../tmp/count_RAF/DM/ASN/ASN_",as.character(snp[var,]),".profile",sep=""))[,6]
ASN$ethnic <- "ASN"
combine <- rbind(THAI,ASN)
res <- wilcox.test(SCORESUM ~ ethnic, data = combine,exact = FALSE)
res$p.value
pvalue[[var]] <- res$p.value
}

#MAF
compare <- fread(Ethnic_MAF.txt)
THAI <- compare %>% filter(ethnic == "Thai")
ASN <- compare %>% filter(ethnic == "ASN")
combine_ehtnic <- inner_join(THAI,ASN,by="SNP") %>% setnames(c("RAF.x","RAF.y"),c("Thai","ASN")) 

#p-value and SNP
gene <- fread(AnnotateSNPs.txt)
new <- as.data.frame(pvalue) 
new_02 <- cbind(snp,new) %>% setnames("V1","SNP")

annotate_pvalue <- inner_join(new_02,gene,by="SNP")

cdat <- inner_join(combine_ehtnic,annotate_pvalue,by="SNP")
final <- cdat[,c(1,2,4,6,7,9)]

#scatter plot & heterogeniety
## p -value below demonstrate for bonferroni adjusting for p - value in DM with 52 SNPs

final$`Allelic Heterogeniety` <- ifelse(final$pvalue <  0.0009, 'Padjusted < 0.05', "Not Sig")


summary(final)

ggplot(final, aes(x = Thai, y = ASN)) +
  geom_point(aes(color = `Allelic Heterogeniety`,size = `log(odd ratio)`)) +
  scale_color_manual(values = c("grey","red")) +
  theme_bw(base_size = 12) +
  geom_text_repel(
    data = subset(final, pvalue < 0.0009),
    aes(label = Gene),
    size = 3,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  geom_abline(intercept = 0, slope = 1,size=0.1,linetype = "dashed")+
  stat_cor(method = "spearman",size = 3)+ 
  xlim(0, 1) +
  ylim(0, 1) +
  ylab("East Asian RAF") +
  xlab("Thai RAF")



