### this script create interval for 05_imputation_function.sh file in each chromosme with 5 MB in each chromosme ###
	
chromstart=$1
# End of chromosome (in basepairs)
chromend=$2
# Size of chunks (in basepairs)
chunksize=5000000
# Chromosome number
chr=$3
# Loop through chunks
chunknum=1
st=${chromstart}

while ((st<=chromend)); do
  ((end=st+chunksize))
  echo ${st} ${end} >> chunk_${3}.txt
  ((st=st+chunksize+1))
  ((chunknum=chunknum+1))
done

awk '$1="impute\t"$1' chunk_${3}.txt > chunk-pre.txt
awk '$2="nchr\t"$2' chunk-pre.txt > chunk-pre-01.txt
awk '{print $1"\t"$2"\t"$3"\t"$4"\t""&"}' chunk-pre-01.txt > chunk-pre-02.txt
sed "s/nchr/$chr/g" "chunk-pre-02.txt"  | tr -s " " > chunk-${chr}-final.txt
sed -i '1 i\source impute_function.sh' chunk-${chr}-final.txt
