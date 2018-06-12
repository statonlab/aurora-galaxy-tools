# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}
mkdir download_dir

#========== build and run bdss-download.sh script ============
echo 'export PATH=/main/sites/galaxy/galaxy/tools/_conda/bin:$PATH' > bdss-download.sh
echo 'for u in $(echo $X_u | sed "s/,/ /g");' >> bdss-download.sh
echo 'do' >> bdss-download.sh
echo '  bdss transfer --destination download_dir -u $u' >> bdss-download.sh
echo 'done' >> bdss-download.sh

sh bdss-download.sh
# copy data from REPORT_FILES_PATHS to JOB_WORKING_DIR so that files can be discovered automatically.
cp -r download_dir ${JOB_WORKING_DIR}