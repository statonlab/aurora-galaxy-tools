
#create extra file directory
mkdir -p ${X_d}

cd ${X_d}
cp ${X_r} ${X_d}/read_1.fq
cp ${X_R} ${X_d}/read_2.fq

cat >temp.sh <<EOL
fastqc \\
  -q \\
  -c ${X_c} \\
  -l ${X_l} \\
  ${X_d}/read_1.fq > /dev/null 2>&1
  
fastqc \\
  -q \\
  -c ${X_c} \\
  -l ${X_l} \\
  ${X_d}/read_2.fq > /dev/null 2>&1
EOL

grep -v None temp.sh > fastqc.sh
rm temp.sh

# run fastqc
sh fastqc.sh

# unzip outputs
unzip -q read_1_fastqc.zip
unzip -q read_2_fastqc.zip