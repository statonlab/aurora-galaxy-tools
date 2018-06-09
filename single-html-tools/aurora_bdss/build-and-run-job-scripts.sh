# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run job 1 script ============
cat >job-1-script.sh <<EOF
#------------ BELOW IS WHERE YOU WRITE YOUR OWN SHELL SCRIPT --------------


#------------ END OF SHELL SCRIPT ------------------------------------------  
EOF

# run job 1 script
sh job-1-script.sh


#========== build and run job 2 script ============
cat >job_2_script.sh <<EOF
#------------ BELOW IS WHERE YOU WRITE YOUR OWN SHELL SCRIPT --------------


#------------ END OF SHELL SCRIPT ------------------------------------------  
EOF

# run job 2 script
sh job_2_script.sh
