### This scirpt aims to perferm genotype imputation in Thai samples ###
### Reference file can be downloaded from https://mathgen.stats.ox.ac.uk/impute/impute_v2.html #

#This function will be sourced into another text file to perform imputation. For example,
#source 04_imputation_function.sh
#impute	4	10010242	15010242	&
#impute	4	15010243	20010243	&
#impute	4	20010244	25010244	&


function impute () {

  # Number of chromosome $1  
  # Directories
    Ref_dir=/turtle/BSL/amd/yean_data
    Tools_dir=$Ref_dir/tools #gtool,impute2,eagle,plink1.9
    Impute_dir=$Ref_dir/analysis/full_data/imputation
    result=$Impute_dir/result

  # Reference file
    Hap_impute=$Impute_dir/ALL.integrated_phase1_SHAPEIT_16-06-14.nomono/ALL.chr$1.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nomono.haplotypes.gz
    legend_impute=$Impute_dir/ALL.integrated_phase1_SHAPEIT_16-06-14.nomono/ALL.chr$1.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.nomono.legend.gz
    Map_impute=$Impute_dir/ALL.integrated_phase1_SHAPEIT_16-06-14.nomono/genetic_map_chr$1_combined_b37.txt

  #Others
    Target_file=$Ref_dir/analysis/full_data/phasing/result/$1/chr$1.gen
    Impute_interval_start=$2
    Impute_interval_end=$3	
  #command
    $Tools_dir/impute2 -m $Map_impute \
                       -h $Hap_impute \
                       -l $legend_impute \
                       -g $Target_file \
                       -int $Impute_interval_start $Impute_interval_end  \
                       -Ne 20000 \
                       -o $result/$1/chr${1}.chunk_${Impute_interval_start}_${Impute_interval_end}
 }
 
 
