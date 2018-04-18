#--- build skewer job script ---
## change directory to output dir
cd ${X_d}

cat >temp.sh <<EOL
skewer \\
	${X_A} \\
	${X_B} \\
	-x ${X_x} \\ 
	-y ${X_y} \\
	-m ${X_m} \\
	-r ${X_r} \\
	-d ${X_D} \\
	-q ${X_q} \\
	-Q ${X_Q} \\
	-l ${X_l} \\
	-j ${X_j} \\
	-M ${X_M} \\
	-b ${X_b} \\
	-c ${X_b} \\
	-n ${X_n} \\
	-u ${X_u} \\
	-f ${X_f} \\
	-z ${X_z} \\
	-qiime ${X_E} \\
	-quiet ${X_F} \\
	-i ${X_i} \\
	-o trim > /dev/null 2>&1

EOL

# remove empty input lines
grep -v '\-M  \\' temp.sh |\
  grep -v 'None' |\
  grep -v 'NO_ARGUMENT_NO' |\
  sed 's/NO_ARGUMENT_YES//g' > skewer-job.sh

sh skewer-job.sh

# expose files to galaxy history
if [ -e trim-trimmed-pair1.fastq ]; then
  cp trim-trimmed-pair1.fastq ${X_1}
fi

if [ -e trim-trimmed-pair2.fastq ]; then
  cp trim-trimmed-pair2.fastq ${X_2}
fi

if [ -e trim-trimmed.fastq ]; then
  cp trim-trimmed.fastq ${X_3}
fi

# rename log file
if [ -e trim-trimmed.log ]; then
  cp trim-trimmed.log trim-trimmed.txt
fi

# remove temp.sh
rm temp.sh