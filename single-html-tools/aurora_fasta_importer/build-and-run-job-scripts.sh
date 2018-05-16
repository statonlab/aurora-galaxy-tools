# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run job 1 script ============
cat >curl-download.sh <<EOF
if [ $(wc -l <$X_f) -gt 2 ]; then
  cp $X_f $X_O
else
  if [ "$X_e" = "twobit" ]; then
    cp $TOOL_INSTALL_DIR/twoBitToFa twoBitToFa
    chmod +x twoBitToFa
    ./twoBitToFa $(head -1 $X_f) $X_O
  elif [ "$X_e" = "gz" ]; then
    curl $(head -1 $X_f) > output.fa.gz 
    gunzip -c output.fa.gz > $X_O 
  else
    curl $(head -1 $X_f) > $X_O
  fi
fi

EOF

sh curl-download.sh

