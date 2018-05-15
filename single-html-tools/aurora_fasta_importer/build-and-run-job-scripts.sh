# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run job 1 script ============
cat >curl-download.sh <<EOF
if [[ $(wc -l <$X_f) -ge 2 ]];then
  cp $X_f $X_O
else
  curl $(head -1 $X_f) > $X_O
fi
EOF

# run job 1 script
sh curl-download.sh

