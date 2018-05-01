# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run job 1 script ============
cat >htseq-count.sh <<EOF
 htseq-count \\
    $(echo ${X_A} | sed 's/,/ /g') \\
    ${X_G} \\
    -f ${X_f} \\
    -r ${X_r} \\
    -s ${X_S} \\
    -a ${X_a} \\
    -t ${X_T} \\
    -i ${X_i} \\
    -m ${X_m} > htseq-counts-raw.txt

  grep -v '__no_feature\|__ambiguous\|__too_low_aQual\|__not_aligned\|__alignment_not_unique' htseq-counts-raw.txt > counts.txt

EOF

# run job 1 script
sh htseq-count.sh

