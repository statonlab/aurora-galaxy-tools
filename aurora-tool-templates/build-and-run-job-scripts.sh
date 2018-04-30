# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run job 1 script ============
cat >job_1_script.sh <<EOF
#------------ BELOW IS WHERE YOU WRITE YOUR OWN SHELL SCRIPT --------------


#------------ END OF SHELL SCRIPT ------------------------------------------  
EOF

# run SHELL_SCRIPT
sh job_1_script.sh


#========== build and run job 2 script ============
cat >job_2_script.sh <<EOF
#------------ BELOW IS WHERE YOU WRITE YOUR OWN SHELL SCRIPT --------------


#------------ END OF SHELL SCRIPT ------------------------------------------  
EOF

# run SHELL_SCRIPT
sh job_2_script.sh