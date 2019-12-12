###This Script aims to convert csv file to PLINK flat file format###

## $1 SNP file  (using original format reported from RIKEN without header and control row)
## $2 Genotype file with commma delim. (c1=rs,c2=genotype of each sample)
## $3 Sample file from RIKEN  (SampleID,Gender)

# 1. creating tped

#1.1 creating map first before merging with ped

cat $1 | cut -d',' -f2,10,11 > info.csv 
sed 's/$/,0/' info.csv > full_info.csv
awk -F, '{ print $2,$1,$4,$3}' full_info.csv | tr ' ' '\t' > final_info.csv 

#1.2 Creating Ped file and Merging with Map in 1.1
 
cat $2 > out.tmp
sed 's/AA/A,A/g; s/AT/A,T/g; s/AG/A,G/g; s/AC/A,C/g; s/TA/T,A/g; s/TG/T,G/g; s/TT/T,T/g; s/TC/T,C/g; s/CA/C,A/g; s/CT/C,T/g; s/CG/C,G/g; s/CC/C,C/g; s/GG/G,G/g; s/GA/G,A/g; s/GT/G,T/g; s/GC/G,C/g;  s/DD/D,D/g;  s/DI/D,I/g;  s/II/I,I/g;  s/ID/I,D/g;  s/--/0,0/g;' out.tmp  | tr ',' '\t' | cut -f2- > out_c.tmp
paste -d "\t" final_info.csv out_c.tmp > sample.tped
head -n 964193 sample_pre.tped > sample.tped #exclude Control SNPs, Non - Polymorphism SNPs, etc. in RIKEN I.
#head -n 958497 sample_pre.tped > sample.tped #exclude Control SNPs, Non - Polymorphism SNPs, etc. in RIKEN II.
  

# 2. creating tfam

#Family ID ('FID')
#Individual ID ('IID'; cannot be '0')
#Individual ID of father ('0' if father isn't in dataset)
#Individual ID of mother ('0' if mother isn't in dataset)
#Sex code ('1' = male, '2' = female, '0' = unknown)
#Phenotype value ('1' = control, '2' = case, '-9'/'0'/non-numeric = missing data if case/control)

cat $1 | awk -F',' '{ print $1,$1,0,0,$2,2}' > sample_pre.tfam 
sed 's/M/1/g; s/F/2/g' sample_pre.tfam > sample.tfam
#sed -i '/RJRS0397/d' sample.tfam #missing individuals from phase I only