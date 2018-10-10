# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== freebayes.sh ============
cat >temp.sh <<EOF
freebayes \\
  -f ${X_f} \\
  -s ${X_s} \\
  -t ${X_t} \\
  -r ${X_r} \\
  -T ${X_T} \\
  -p ${X_p} \\
  ${X_b} > var.vcf

EOF

grep -v "None" temp.sh > freebayes.sh
rm temp.sh && sh freebayes.sh