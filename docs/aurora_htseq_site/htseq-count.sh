 htseq-count \
    /export/galaxy-central/database/files/000/dataset_34.dat /export/galaxy-central/database/files/000/dataset_35.dat \
    /export/galaxy-central/database/files/000/dataset_36.dat \
    -f bam \
    -r name \
    -s yes \
    -a 10 \
    -t exon \
    -i gene_id \
    -m union > htseq-counts-raw.txt

  grep -v '__no_feature\|__ambiguous\|__too_low_aQual\|__not_aligned\|__alignment_not_unique' htseq-counts-raw.txt > counts.txt

