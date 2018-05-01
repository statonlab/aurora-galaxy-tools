export TOOL_DIR='${__tool_directory__}' &&

Rscript '${__tool_directory__}/'split_fasta_render.R

	-o '$report'
	-d '$report.files_path'
	-s '$sink_message'
	-A '$fasta_input'
	-B '$number'
