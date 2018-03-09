Rscript '${__tool_directory__}/deseq2_site_render.R'

  -e $echo
  -o $report
  -d $report.files_path
  -s $sink_message
  -t '${__tool_directory__}' 
  
  -A '$count_data'
  -B '$column_data'
  -C '$design_formula'
  -D '$treatment_name'
  -E '$treated'
  -F '$untreated'
  -G '$test_type'
  -H '$fit_type'
  -I '$alpha'
  -J '$significant_genes'