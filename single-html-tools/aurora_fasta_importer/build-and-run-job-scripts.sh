# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run job 1 script ============
cat >curl-download.sh <<EOF
# use the first line as an url and start downloading. If it failed, run the second command.
curl $(head -1 $X_f) > $X_O || cp $X_f $X_O
EOF

# run job 1 script
sh curl-download.sh

