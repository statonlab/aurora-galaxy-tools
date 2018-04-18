Rscript '${__tool_directory__}/htseq_count_render.R'

			-e $echo
			-o $report
			-d $report.files_path
			-s $sink_message
			-t '${__tool_directory__}'
			
			-A '$alignment_files'
			-B '$sample_names'
			-G $gff
			-f $format
			-r $order
			-S $stranded
			-a $minaqual
			-T $feature_type
			-i $idattr
			-m $mode
			-c $count
			-O $count_rdata