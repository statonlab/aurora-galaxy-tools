# run job scripts within the tool outputs directory
cd ${REPORT_FILES_PATH}

#========== build and run hmmscan.sh script ============
#------------ BELOW IS WHERE YOU WRITE YOUR OWN SHELL SCRIPT --------------
cat >temp.sh <<EOF

wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam31.0/Pfam-A.hmm.gz > /dev/null 2>&1
gunzip Pfam-A.hmm.gz > /dev/null 2>&1
hmmpress Pfam-A.hmm > hmmpress.log.txt 2>&1

hmmscan \\
  --tblout tblout.txt \\
  -E ${X_E} \\
  -T ${X_T} \\
  --domE ${X_e} \\
  --domT ${X_t} \\
  Pfam-A.hmm selected_protein_seqs.fasta > hmmscan.log.txt 2>&1

EOF
#------------ END OF SHELL SCRIPT ------------------------------------------

grep -v 'TRUE' temp.sh |\
  grep -v 'NO_ARGUMENT_NO' |\
  sed 's/NO_ARGUMENT_YES//g' > hmmscan.sh
  
rm temp.sh
# run job 1 script
sh hmmscan.sh

