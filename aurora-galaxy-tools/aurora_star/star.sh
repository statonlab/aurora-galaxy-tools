Rscript '${__tool_directory__}/star_render.R'

    -e $echo
    -o $report
    -d $report.files_path
    -s $sink_message
    -t '${__tool_directory__}'
    
    -A '$genomeFastaFiles'
    -B '$sjdbGTFfile'
    -C '$sjdbOverhang'