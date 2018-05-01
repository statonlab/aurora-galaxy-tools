# change directory to tool outputs directory
cd ${REPORT_FILES_PATH}

# copy outputs from tool outputs directory to corresponding galaxy output path
cp deseq2.html ${REPORT}
cp padj-sorted-significant-genes.txt ${X_J}