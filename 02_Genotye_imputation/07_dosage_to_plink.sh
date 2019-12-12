### this script aims to convert dosage file to PLINK binary file format ### 

convert_dosage () {

  # Number of chromosome $1  
  # Directories
    Ref_dir=/turtle/BSL/amd/yean_data
    Tools_dir=$Ref_dir/tools #gtool,impute2,eagle,plink1.9
    Dosage_dir=$Ref_dir/analysis/full_data/dosage_to_plink
    result=$Dosage_dir/result

  #Others
    Gen_file=$Ref_dir/analysis/full_data/imputation/result/${1}
    Sample_file=$Ref_dir/analysis/full_data/phasing/result/${1}
  #command
   mkdir $Gen_file/log_file
   mv $Gen_file/*warnings $Gen_file/log_file
   mv $Gen_file/*summary $Gen_file/log_file
   mv $Gen_file/*sample $Gen_file/log_file
   mv $Gen_file/*info $Gen_file/log_file
   cat $Gen_file/chr${1}.chunk* > $Gen_file/all_chr${1}.gen
   cat $Gen_file/log_file/*info > $Gen_file/log_file/summary.info 
   mkdir $result/${1}
   $Tools_dir/plink1.9 --gen $Gen_file/all_chr${1}.gen --sample $Sample_file/chr${1}.sample --hard-call-threshold random --allow-extra-chr --make-bed --out $result/chr${1}
 }

 
#Example of using this function
convert_dosage 1 &
convert_dosage 2 


##After converting dosage file to binary file, I will convert these dosage file to binary file format (--make-bed) 
