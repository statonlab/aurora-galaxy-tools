
cp /export/galaxy-central/database/files/000/dataset_26.dat read_1.fq
cp /export/galaxy-central/database/files/000/dataset_22.dat read_2.fq

fastqc \
  -q \
  /export/galaxy-central/database/job_working_directory/000/18/dataset_27_files/read_1.fq > read_1.log.txt 2>&1
  
fastqc \
  -q \
  /export/galaxy-central/database/job_working_directory/000/18/dataset_27_files/read_2.fq > read_2.log.txt 2>&1

