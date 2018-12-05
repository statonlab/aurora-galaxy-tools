
cp /export/galaxy-central/database/files/000/dataset_6.dat read_1.fq
cp /export/galaxy-central/database/files/000/dataset_14.dat read_2.fq

fastqc \
  -q \
  /export/galaxy-central/database/job_working_directory/000/42/dataset_49_files/read_1.fq > /dev/null 2>&1
  
fastqc \
  -q \
  /export/galaxy-central/database/job_working_directory/000/42/dataset_49_files/read_2.fq > /dev/null 2>&1

