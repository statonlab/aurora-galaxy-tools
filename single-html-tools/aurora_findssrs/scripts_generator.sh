# run SHELL_SCRIPT within tool outputs directory
cd ${REPORT_FILES_PATH}

cp $X_f input

# generate findSSRs.sh script
cat >findSSRs.sh <<EOF

perl ${TOOL_INSTALL_DIR}/findSSRs_altered.pl \\
  -f input \\
  -m $X_m > log.txt 2>&1

EOF

# run dustmasker job
sh findSSRs.sh