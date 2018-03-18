export TOOL_DIR='${__tool_directory__}' &&

Rscript '${__tool_directory__}/'get_content_types_render.R

	-o '$report'
	-d '$report.files_path'
	-s '$sink_message'
	-u '$web_services_root_url'
