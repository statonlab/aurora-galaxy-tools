# SHELL_SCRIPT file name
SHELL_SCRIPT='rmarkdown_report.sh'

# run SHELL_SCRIPT within tool outputs directory
cd ${REPORT_FILES_PATH}

# build job-script.sh
cat >${SHELL_SCRIPT} <<EOF
#------------ BELOW IS WHERE YOU WRITE YOUR OWN SHELL SCRIPT --------------

# for example:
echo 'this is is an aurora galaxy tool' > echo-output.txt


#------------ END OF SHELL SCRIPT ------------------------------------------  
EOF

# run SHELL_SCRIPT
sh ${SHELL_SCRIPT}