export TOOL_DIR='${__tool_directory__}' &&

Rscript '${__tool_directory__}/'fastq_dump_render.R

	-o '$report'
	-d '$report.files_path'
	-s '$sink_message'
	-A '$accessions_single_end'
	-B '$accessions_paired_end'
