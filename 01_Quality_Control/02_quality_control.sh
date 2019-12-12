### This Script demonstrate how to (1) flip strand, (2) the quality control process, and (3) merge data in RIKEN I and II ### 

#Argument
plink=$1 # path to plink1.9
bfile=$2 # the binary file converted from PLINK flatfile format in supplementay script 1

## (1) Before perforoming QC, I have flipped negative strand to positive strand 
      # Originally, all SNPs in RIKEN I & II are reported as TOP strand as illumina designation.
      # So, I need to converted all TOP strand to forward strand (+) for reference compatibility in genotpe imputation process.
    
    ${plink} --bfile $bfile \
             --flip flip.list \
             --make-bed bfile_flip


## (2) After flipping to forward strand, QC is performed 
#QC will be mainly divided into 2 sections: Individual and variant level
# 2.1.Individual Level
  #2.1.1 Genotype Missing

${plink} --bfile bfile_flip \
         --missing \
         --chr 1-22 \
         --snps-only just-acgt \
         --out missing_sumstat 

  #2.1.2 heterozygosity

${plink} --bfile bfile_flip \
         --het \
         --chr 1-22 \
         --snps-only just-acgt \
         --out heterozygosity
    
  #2.1.3 exclude low quality sample based on individuals level
      # fail.txt file contains those individuals with heterozygosity rate over 3 s.d and high missing genotype rate.

${plink} --bfile bfile_flip \
         --chr 1-22 \
         --snps-only just-acgt \
         --remove fail.txt
         --make-bed \
         --out pass_individuals_qc  

# 2.2 Variant Level
  #2.2.1  select cut-off with call rate > 99 percent
${plink} --bfile pass_individuals_qc \
         --geno 0.01 \
         --make-bed \
         --out pass_variant_qc
         
         
## (3) merge RIKEN I and II
#output file from varaint QC level of RIKEN I and II will be merged in this step
 #3.1 Merge RIKENI and RIKEN II

${plink} --bfile pass_variant_qc_RIKENI \
         --bmerge pass_variant_qc_RIKENII \
         --make-bed \
         --out merge_01
                   
## --exclude duplicate SNPs from duplicate.all file

${plink}  --bfile  merge_01 \
          --exclude duplicate.all \
          --make-bed \
          --out Thai


## After merging done, I will converted binary file to VCF file (--recode vcf) for phasing by Eagle2
           
  