        ######### each aurora tool generates a html file and have an files path directory associated with it.
        mkdir -p $report.files_path &&

        ######### three important paths:
        #########   1. path to tool installation directory
        #########   2. path to report html
        #########   3. path to files_path directory associated with the report output.
        export TOOL_INSTALL_DIR='${__tool_directory__}' &&
        export REPORT='$report' &&
        export REPORT_FILES_PATH='$report.files_path' &&

        ############ create a hidden file to store r markdown rendering log
        touch $report.files_path/r_rendering.log.txt &&

        ############ finally run the render.R script
        Rscript '${__tool_directory__}/rmarkdown_report_render.R'

            -o $report
            -d $report.files_path

            -f '$input.reference_genome'
            -b '$input.bam_file'
            -s '$input.samples_file'
            -t '$input.targets_file'
            -r '$input.region'


            -T '$population_model.theta'
            -p '$population_model.ploidy'

            -v '$vcf_file'
