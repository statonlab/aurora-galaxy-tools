# change directory to tool outputs directory
cd ${REPORT_FILES_PATH}

# copy outputs from tool outputs directory to corresponding galaxy output path
if [ -e "rmarkdown_report.html "] {
  cp rmarkdown_report.html ${REPORT}
}

if [ -e "index.html "] {
  cp index.html ${REPORT}
}
