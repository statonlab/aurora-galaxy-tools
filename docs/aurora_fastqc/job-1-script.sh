
cp /export/galaxy-central/database/files/000/dataset_1.dat read_1.fq
cp /export/galaxy-central/database/files/000/dataset_5.dat read_2.fq

fastqc \
  -q \
  /export/galaxy-central/database/job_working_directory/000/3/dataset_6_files/read_1.fq > /dev/null 2>&1
  
fastqc \
  -q \
  /export/galaxy-central/database/job_working_directory/000/3/dataset_6_files/read_2.fq > /dev/null 2>&1

