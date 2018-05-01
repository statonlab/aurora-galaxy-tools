 htseq-count \
    /export/galaxy-central/database/files/000/dataset_13.dat /export/galaxy-central/database/files/000/dataset_14.dat \
    /export/galaxy-central/database/files/000/dataset_15.dat \
    -f bam \
    -r name \
    -s yes \
    -a 10 \
    -t exon \
    -i gene_id \
    -m union > htseq-counts-raw.txt

  grep -v '__no_feature\|__ambiguous\|__too_low_aQual\|__not_aligned\|__alignment_not_unique' htseq-counts-raw.txt > counts.txt

