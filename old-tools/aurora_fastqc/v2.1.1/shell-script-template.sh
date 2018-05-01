# SHELL_SCRIPT file name
SHELL_SCRIPT='fastqc.sh'

# run SHELL_SCRIPT within tool outputs directory
cd ${REPORT_FILES_PATH}

# build job-script.sh
cat >temp.sh <<EOF

cp ${X_r} read_1.fq
cp ${X_R} read_2.fq

fastqc \\
  -q \\
  -c ${X_c} \\
  -l ${X_l} \\
  ${X_d}/read_1.fq > /dev/null 2>&1
  
fastqc \\
  -q \\
  -c ${X_c} \\
  -l ${X_l} \\
  ${X_d}/read_2.fq > /dev/null 2>&1

EOF

grep -v None temp.sh > ${SHELL_SCRIPT}
rm temp.sh

# run SHELL_SCRIPT
sh ${SHELL_SCRIPT}


# unzip outputs
unzip -q read_1_fastqc.zip
unzip -q read_2_fastqc.zip