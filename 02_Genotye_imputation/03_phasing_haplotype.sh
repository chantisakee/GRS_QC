### This Scipt aims to phase haplotype of Thai sample before genotype imputation ###
### This Script will produce 22 output files 

#Argument
Path_to_Eagles2=$1
target_vcf=$2 #target vcfs were derived from 02_quality_control.sh
Genetic_map=$3

# the reference file can be downoaded from https://data.broadinstitute.org/alkesgroup/Eagle/ #

#cohort-based phasingd
function phase () {

$1 --vcf=$2 --geneticMapFile=$3 --noImpMissing --vcfOutFormat=z --chrom=$4 --outPrefix=phased_chr${4} --numThreads=2 2>&1 | tee output_phased_$4.log

}

#Example of using phasing function

phase ../Eagle_v2.4.1/eagle merge.vcf ../genetic_exclude_X.txt.gz 1 &
phase ../Eagle_v2.4.1/eagle merge.vcf ../genetic_exclude_X.txt.gz 2 &
phase ../Eagle_v2.4.1/eagle merge.vcf ../genetic_exclude_X.txt.gz 3 &
phase ../Eagle_v2.4.1/eagle merge.vcf ../genetic_exclude_X.txt.gz 4 &
phase ../Eagle_v2.4.1/eagle merge.vcf ../genetic_exclude_X.txt.gz 5 