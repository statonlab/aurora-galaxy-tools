# change directory to tool outputs directory
cd ${REPORT_FILES_PATH}

# copy outputs from tool outputs directory to corresponding galaxy output path
if [ -e "rmarkdown_report.html" ]; then
  cp rmarkdown_report.html ${REPORT}
fi

if [ -e "index.html" ]; then
  cp index.html ${REPORT}
fi
