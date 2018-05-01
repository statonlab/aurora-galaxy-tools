# change directory to tool outputs directory
cd ${REPORT_FILES_PATH}

# copy outputs from tool outputs directory to corresponding galaxy output path
if [ -e "rmarkdown_report.html" ]; then
  cp rmarkdown_report.html ${REPORT}
fi

if [ -e "index.html" ]; then
  cp index.html ${REPORT}
fi


if [ -e trim-trimmed-pair1.fastq ]; then
  cp trim-trimmed-pair1.fastq ${X_1}
fi

if [ -e trim-trimmed-pair2.fastq ]; then
  cp trim-trimmed-pair2.fastq ${X_2}
fi

if [ -e trim-trimmed.fastq ]; then
  cp trim-trimmed.fastq ${X_3}
fi