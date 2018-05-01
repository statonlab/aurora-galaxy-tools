export TOOL_DIR='${__tool_directory__}' &&

Rscript '${__tool_directory__}/'search_contents_render.R

	-o '$report'
	-d '$report.files_path'
	-u '$content_type_url'

	#set $sep = ''
	#set $search_paths = ''
	#for $search_path in $search_section.search_field_repeat:
	  #set $search_paths += $sep + str($search_path.field_path) + ';' + str($search_path.search_operator)
	  #set $sep = '|'
	#end for
	-s '$search_paths'

	#set $sep = ''
	#set $extract_paths = ''
	#for $extract_path in $extract_section.extract_field_repeat:
	  #set $extract_paths += $sep + str($extract_path.field_path)
	  #set $sep = '|'
	#end for
	-e '$extract_paths'

	-l '$records_number'
	-r '$search_results'
