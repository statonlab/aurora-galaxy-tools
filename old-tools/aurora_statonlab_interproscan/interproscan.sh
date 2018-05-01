export TOOL_DIR='${__tool_directory__}' &&

Rscript '${__tool_directory__}/'interproscan_render.R

	-o '$report'
	-d '$report.files_path'
	-s '$sink_message'
	-A '$fasta_input'
	-B '$output_format'
	-C '$disable_precalc'
	-D '$iprlookup'
	-E '$goterms'
	-F '$pathways'
