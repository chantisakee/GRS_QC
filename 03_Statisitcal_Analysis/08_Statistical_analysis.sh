# This script aims to analyze Thai sample deried from 07_dosage_to_plink.sh with 1KGp1 and p3.

# 1KGp1 file can download at google bucket: https://console.cloud.google.com/storage/browser/yean_thesis/reference_file/1KGp1/post_qc_vcf/?project=bhoom-lab-01&authuser=1
# 1KGp3 file can download at google bucket: https://console.cloud.google.com/storage/browser/_details/yean_thesis/reference_file/1KGp3/post_qc_vcf/1hgp_combine.vcf.gz?project=bhoom-lab-01&authuser=1

#Argument
#Thai: imputed genotype of Thai - this will be used for GRS calculation
#original_Thai: original genotype of Thai samples (before imputation) - this will be used for PCA calculation
#Hgp1: path to 1KGp1 file (for GRS calculation) and 1KGp3 (for PCA plotting)
#sum_stat: path to summary statistics of both weighted and unweighted
#disease: Disesae name (string) in five NCDs
#snplist: snplists in five NCDs (one snp per line)
#pop_code: population code from 1Kgp1 (for extract RAF and count risk allele) and 1Kgp3 (for PCA analysis)


# 1. Thai vs. 1KGp1

# 1.1 Merge Thai and 1KGp1

  plink1.9 --bfile Thai \
         --bmerge Hgp \
         --make-bed \
         --out GRS
                   
## If variants with strand consistency are still present.I will --extract those SNPs and --exclude it.
## Output of strand error is in GRS-merge.missnp file
## After getting strand error, I remove it from our target file (Thai sample)

  plink1.9  --bfile Thai \
          --exclude GRS-merge.missnp \
          --make-bed \
          --out thai

## And then merge it with reference file again. Merging is successful but the call rate is very low (Total genotyping rate is 0.553355) !!
# the low Genotpying rate is occurred because there are only 18 million SNPs successfully imputed in Thai but there are ~38 million SNPs in 1KGp1
  plink1.9 --bfile thai \
         --bmerge Hgp \
         --make-bed \
         --out GRS-02

## To solve this problem,  I have --write-snplist from both Thai sample and 1KGp1.
## Then grep -Fwf thai.snplist hgp.snplist > common.snplist. 
## Extract those commmon SNPs
  
  plink1.9  --bfile GRS-02 \
          --extract common.snplist \
          --make-bed \
          --out GRS-03 
                    

## Total genotyping rate is 0.999999 after extracting common SNPs both cohort.
## These files (GRS-03.bed GRS-03.bim GRS-03.fam) are ready to capture all SNPs in summary statistics in five NCDs.

#1.2 calculate weighted and unweigted GRS

  plink1.9 --bfile GRS-03 \
         --score sum_stat 'sum' \
         --out disease

#1.3 Extract Risk Allele Frequency

  plink1.9 --bfile GRS-03 \
         --extract snplist \
         --keep or --remove pop_code \
         --freq \
         --out disease

# 2. Thai vs. 1KGp3

# 2.1  PCA plot among Thai sample and 1KGp3

# To plot PCA plot in 1KGp3, we merge Thai and 1KGp3 similar to #1. Merge Thai and 1KGp1
# After merging successful, we calculate PCA plot 

# Plot all population including Thai
  plink1.9  --bfile original_Thai \
          --extract prune_global.prune.in \ ## correlated SNPs (--indep-pairwise 50 5 0.2)
          --pca \
          --out global

# Extract specific population and Thai

  plink1.9  --bfile original_Thai \
          --extract prune_global.prune.in \ ## correlated SNPs (--indep-pairwise 50 5 0.2)
          --pca \
          --keep pop_code \ #contain East and Thai only
          --out East_Asian


# 3. Calcuate allelic Heterogeniety
# comparing Thai and ASN risk allele count
for snp in (cat snplist);do 
  grep $snp sum_stat > snp.txt # using unweighted summary statistics
  plink1.9--bfile GRS-03 --score $snp.txt 'sum' --keep pop_code --out ASN_DM_$snp &  #pop code contain only ASN only
  plink1.9 --bfile GRS-03 --score $snp.txt 'sum' --remove pop_code --out Thai_Thai_$snp #pop code contain only Thai only
done





