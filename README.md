# The QC steps can be categorized into 3 parts
- 01_Quality_Control <br/>
  - This process can be divided into 2 parts including **individuals level and variant level**
    - In each step, only low quality sample and variant will be excluded.
    - population stratification and relatedness is ignored in this step because GRS exploration will not be afftected by these concerns.

- 02_Genotype_imputation <br/>
  - The genotype of RIKEN I and II will be imputed by using 1000 genome project phase I as reference in order to capture all SNPs in the summary statistics.

- 03_Statistical_Analysis <br/>
  - There are two main parts including Exploring GRS distribution in five NCDs and evaluating weighting straties (weighted genetic risk score and unweighted genetic risk score)
  - All graph are plotted by using Rscript 
