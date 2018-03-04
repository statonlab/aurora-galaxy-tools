Rscript '${__tool_directory__}/aurora_star_site_render.R'

    -e $echo
    -o $report
    -d $report.files_path
    -s $sink_message
    -t '${__tool_directory__}'
    
    -A '$genomeFastaFiles'
    -B '$sjdbGTFfile'
    -C '$sjdbOverhang'
    -F '$first_reads'
    -R '$second_reads'
    -S '$sorted_bam'