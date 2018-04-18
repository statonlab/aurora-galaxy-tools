cd ${X_d}

#--------- index genome --------
# create genome directory for genome indexes
mkdir -p ${X_d}/genomeDir

cat >temp.sh <<EOF
STAR \\
  --runMode genomeGenerate \\
  --genomeDir ${X_d}/genomeDir \\
  --genomeFastaFiles $( echo ${X_A} | sed 's/,/ /g' ) \\
  --sjdbGTFfile ${X_B} \\
  --sjdbOverhang ${X_C} \\
  > /dev/null 2>&1
EOF

grep -v None temp.sh > index-genome.sh

# run star
sh index-genome.sh

#---- mapping ---------
cat >temp.sh <<EOF
STAR \\
  --genomeDir ${X_d}/genomeDir \\
  --readFilesIn \\
  ${X_F} \\
  ${X_R} \\
  > /dev/null 2>&1
EOF

grep -v None temp.sh > mapping.sh

# run mapping
sh mapping.sh

# remove temp.sh
rm temp.sh

#----- SAM to sorted BAM ------
echo "samtools sort -o Aligned.out.sorted.bam Aligned.out.sam" > sam2bam.sh
sh sam2bam.sh

#----- evaluate mapping -------
echo "samtools flagstat Aligned.out.sorted.bam > flagstat.txt" > flagstat.sh
sh flagstat.sh


#====== expose outputs to galaxy history =======
cp Aligned.out.sorted.bam ${X_S}