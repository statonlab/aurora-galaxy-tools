# run SHELL_SCRIPT within tool outputs directory
cd ${REPORT_FILES_PATH}


# generate dustmasker.sh script
cat >temp.sh <<EOF
dustmasker \\
  -in ${X_A} \\
  -window ${X_B} \\
  -level ${X_C} \\
  -linker ${X_D} \\
  -infmt ${X_E} \\
  -outfmt ${X_F} \\
  -parse_seqids ${X_G} \\
  -out masked_file.txt > dustmasker.log.txt 2>&1

EOF

grep -v 'NO_ARGUMENT_NO' temp.sh > dustmasker.sh
rm temp.sh

# run dustmasker job
sh dustmasker.sh