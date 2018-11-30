 htseq-count \
    /export/galaxy-central/database/files/000/dataset_41.dat /export/galaxy-central/database/files/000/dataset_42.dat /export/galaxy-central/database/files/000/dataset_43.dat /export/galaxy-central/database/files/000/dataset_44.dat \
    /export/galaxy-central/database/files/000/dataset_45.dat \
    -f bam \
    -r name \
    -s yes \
    -a 10 \
    -t exon \
    -i ID \
    -m union > htseq-counts-raw.txt

  grep -v '__no_feature\|__ambiguous\|__too_low_aQual\|__not_aligned\|__alignment_not_unique' htseq-counts-raw.txt > counts.txt

