# change directory to tool outputs directory
cd ${REPORT_FILES_PATH}

# copy files to corresponding tool output paths.
cp htseq_count.html ${REPORT}
cp counts.RData ${X_O}
cp counts.txt ${X_c}