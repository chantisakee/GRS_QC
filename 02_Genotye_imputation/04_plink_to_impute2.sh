### This Script aims to convert PLINK file format into Gen format for genotype phasing ###
### Flow: VCF.gz -> MAP/PED -> .gen/.sample -> IMPUTE2

# 1. VCF to PED/MAP

for i in $(seq 1 22)
do
mkdir $i;cd $i

path_to_plink --vcf ../phased_chr${i}.vcf.gz \
              --recode \
              --out chr${i}
cd ..
done


# 2. MAP/PED to .gen/.sample

for i in $(seq 1 21)
do
cd ${i}
path_to_gtools -P --ped chr${i}.ped --map chr${i}.map --og chr${i}.gen --os chr${i}.sample
cd ..
done



