# run SHELL_SCRIPT within tool outputs directory
cd ${REPORT_FILES_PATH}

#--------- job 1: index genome --------
# create genome directory for genome indexes
mkdir -p ${X_d}/genomeDir

cat >temp.sh <<EOF
STAR \\
  --runMode genomeGenerate \\
  --genomeDir ${X_d}/genomeDir \\
  --genomeFastaFiles $( echo ${X_A} | sed 's/,/ /g' ) \\
  --sjdbGTFfile ${X_B} \\
  --sjdbOverhang ${X_C} \\
  > genome-indexing.log.txt 2>&1
EOF

grep -v None temp.sh > index-genome.sh

# run star
sh index-genome.sh

#--------- job 2: mapping ---------
cat >temp.sh <<EOF
STAR \\
  --genomeDir ${X_d}/genomeDir \\
  --readFilesIn \\
  ${X_F} \\
  ${X_R} \\
  > mapping.log.txt 2>&1
EOF

grep -v None temp.sh > mapping.sh

# remove temp.sh
rm temp.sh

# run mapping
sh mapping.sh



#--------- job 3: SAM to sorted BAM ------
echo "samtools sort -o Aligned.out.sorted.bam Aligned.out.sam" > sam2bam.sh
sh sam2bam.sh

#--------- job 4: evaluate mapping -------
echo "samtools flagstat Aligned.out.sorted.bam > flagstat.txt" > flagstat.sh
sh flagstat.sh