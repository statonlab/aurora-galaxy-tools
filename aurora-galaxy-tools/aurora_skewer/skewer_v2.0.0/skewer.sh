Rscript '${__tool_directory__}/skewer_render.R'

    -e $echo
    -o $report
    -d $report.files_path
    -s $sink_message
    -t '${__tool_directory__}'
    
    ## Adapter
    -x $adapter_first_reads
    -y $adapter_second_reads
    -M $tab_adapter
    -j $junction_adapter
    -m $trimming_mode
    -b $barcode
    -c $cut
    
    ## Tolerance
    -r $maximum_allowed_error_rate
    -d $maximum_allowed_indel_error_rate
    -k $maximum_overlap_length
    
    ## Filtering
    -q $quality_trimming_3_end
    -Q $mean_quality
    -l $minimum_read_length
    -L $maximum_read_length
    -n $filter_degenerative_reads
    -u $filter_undetermined_mate_pair_reads
    
    ## Input/Output
    -f $format
    -o $output_base_name
    -z $compress
    -Q $qiime
    -S $quiet
    
    ## Miscellaneous
    -i $intelligent


