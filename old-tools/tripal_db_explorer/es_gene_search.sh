export TOOL_DIR='${__tool_directory__}' &&

Rscript '${__tool_directory__}/'es_gene_search_render.R

	-o '$report'
	-d '$report.files_path'
	-U '$tripal_db_url'
	-O '$organism'
	-K '$search_keywords'
	-R '$fasta_results'
