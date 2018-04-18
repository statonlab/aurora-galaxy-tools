Rscript '${__tool_directory__}/skewer_render.R'

    -e $echo
    -o $report
    -d $report.files_path
    -s $sink_message
    -t '${__tool_directory__}'
    
    -X $first_reads
    -Y $second_reads
    -x $adapter_x
    -y $adapter_y
    -A $end_quality
    -B $mean_quality
    
    -f $trimmed_r1
    -r $trimmed_r2
