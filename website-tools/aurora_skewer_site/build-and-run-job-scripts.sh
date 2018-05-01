# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run job 1 script ============
cat >temp.sh <<EOF
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
	-o trim > skewer.log.txt 2>&1
EOF

# remove empty input lines
grep -v '\-M  \\' temp.sh |\
  grep -v 'None' |\
  grep -v 'NO_ARGUMENT_NO' |\
  sed 's/NO_ARGUMENT_YES//g' > job-1-script.sh

rm temp.sh

# run job 1 script
sh job-1-script.sh

# rename log file
if [ -e trim-trimmed.log ]; then
  cp trim-trimmed.log trim-trimmed.txt
fi