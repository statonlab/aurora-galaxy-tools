# change directory to tool outputs directory
cd ${REPORT_FILES_PATH}

# copy outputs from tool outputs directory to corresponding galaxy output path
if [ -e "rmarkdown_report.html" ]; then
  cp rmarkdown_report.html ${REPORT}
fi

if [ -e "index.html" ]; then
  cp index.html ${REPORT}
fi


if [ -e "input.ssr.fasta" ]; then
  cp "input.ssr.fasta" ${X_F}
fi

if [ -e "input.ssr_stats.txt" ]; then
  cp "input.ssr_stats.txt" ${X_S}
fi

if [ -e "input.ssr_report.txt" ]; then
  cp "input.ssr_report.txt" ${X_R}
fi

