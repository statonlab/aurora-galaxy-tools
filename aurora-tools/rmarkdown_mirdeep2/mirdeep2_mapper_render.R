##======= Handle arguments from command line ========
# setup R error handline to go to stderr
options(show.error.messages=FALSE,
        error=function(){
          cat(geterrmessage(), file=stderr())
          quit("no", 1, F)
        })

# we need that to not crash galaxy with an UTF8 error on German LC settings.
loc = Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

# suppress warning
options(warn = -1)

options(stringsAsFactors=FALSE, useFancyQuotes=FALSE)
args = commandArgs(trailingOnly=TRUE)

suppressPackageStartupMessages({
  library(getopt)
  library(tools)
})

# column 1: the long flag name
# column 2: the short flag alias. A SINGLE character string
# column 3: argument mask
#           0: no argument
#           1: argument required
#           2: argument is optional
# column 4: date type to which the flag's argument shall be cast.
#           possible values: logical, integer, double, complex, character.
spec_list=list()

##------- 1. input data ---------------------
spec_list$FASTQ_READS = c('reads', 'r', '1', 'character')
spec_list$REFERENCE_GENOME = c('reference_genome', 'g', 1, 'character')
spec_list$ECHO = c('echo', 'e', '1', 'character')

##--------2. output report and report site directory --------------
spec_list$OUTPUT_HTML = c('mirdeep2_mapper', 'o', '1', 'character')
spec_list$OUTPUT_DIR = c('mirdeep2_mapper_dir', 'd', '1', 'character')
spec_list$READS_COLLAPSED = c('reads_collapsed', 'm', '1', 'character')
spec_list$READ_X_COLLAPSED_VS_GENOME = c('reads_collapsed_vs_genome', 'n', '1', 'character')
spec_list$REPORT_LOG = c("report_log", 't', '1', 'character')

##---------other parameters---------------
spec_list$PARSE_TO_FASTA = c('parse_to_fasta', 'b', '1', 'character')
spec_list$CLEAN_ENTRIES = c('clean_entries', 'c', '1', 'character')
spec_list$CLIP_3_ADAPTER = c('clip_3_adapter', 'f', '2', 'character')
spec_list$DISCARD_SHORTER_READS = c('discard_shorter_reads', 'h', '1', 'character')
spec_list$COLLAPSE_READS_OR_NOT = c('collapse_reads_or_not', 'j', '1', 'character')
spec_list$MAP_WITH_ONE_MISMATCH = c('map_with_one_mismatch', 'k', '1', 'character')
spec_list$MAP_UP_TO_POSITION = c('map_up_to_position', 'l', '1', 'character')

##--------3. Rmd templates sitting in the tool directory ----------

## _site.yml and index.Rmd files
spec_list$SITE_YML = c('site_yml', 's', 1, 'character')
spec_list$INDEX_Rmd = c('index_rmd', 'i', 1, 'character')

## other Rmd body template files
spec_list$MIRDEEP2_MAPPER_RMD = c('mirdeep2_mapper_rmd', 'p', '1', 'character')



##------------------------------------------------------------------

spec = t(as.data.frame(spec_list))
opt = getopt(spec)
# arguments are accessed by long flag name (the first column in the spec matrix)
#                        NOT by element name in the spec_list
# example: opt$help, opt$expression_file
##====== End of arguments handling ==========

#------ Load libraries ---------
library(rmarkdown)
library(plyr)
# library(stringr)
library(dplyr)
# library(highcharter)
# library(DT)
# library(reshape2)
# library(plotly)
# library(formattable)
library(htmltools)


#----- 1. create the report directory ------------------------
paste0('mkdir -p ', opt$mirdeep2_mapper_dir) %>%
  system()

#----- 2. generate Rmd files with Rmd templates --------------
#   a. templates without placeholder variables:
#         copy templates from tool directory to the working directory.
#   b. templates with placeholder variables:
#         substitute variables with user input values and place them in the working directory.


#----- mirdeep2_mapper.Rmd -----------------------
readLines(opt$mirdeep2_mapper_rmd) %>%
  (function(x) {
    gsub('ECHO', opt$echo, x)
  }) %>%
  (function(x) {
    gsub('FASTQ_READS', opt$reads, x)
  }) %>% 
  (function(x) {
    gsub('REFERENCE_GENOME', opt$reference_genome, x)
  }) %>%
  (function(x) {
    gsub('PARSE_TO_FASTA', opt$parse_to_fasta, x)
  }) %>%
  (function(x) {
    gsub('CLEAN_ENTRIES', opt$clean_entries, x)
  }) %>%
  (function(x) {
    gsub('CLIP_3_ADAPTER', opt$clip_3_adapter, x)
  }) %>%
  (function(x) {
    gsub('DISCARD_SHORTER_READS', opt$discard_shorter_reads, x)
  }) %>%
  (function(x) {
    gsub('COLLAPSE_READS', opt$collapse_reads, x)
  }) %>%
  (function(x) {
    gsub('MAP_WITH_ONE_MISMATCH', opt$map_with_one_mismatch, x)
  }) %>%
  (function(x) {
    gsub('MAP_UP_TO_POSITION', opt$map_up_to_position, x)
  }) %>%
  (function(x) {
    gsub('OUTPUT_DIR', opt$mirdeep2_mapper_dir, x)
  }) %>%
  (function(x) {
    fileConn = file('mirdeep2_mapper.Rmd')
    writeLines(x, con=fileConn)
    close(fileConn)
  })


#------ 3. render all Rmd files with render() --------
render('mirdeep2_mapper.Rmd', output_file = opt$mirdeep2_mapper)


#-------4. manipulate outputs -----------------------------
#   a. copy non-site files
file.copy('reads_collapsed.fa', opt$reads_collapsed, recursive=TRUE)
file.copy('reads_collapsed_vs_genome.arf', opt$reads_collapsed_vs_genome, recursive=TRUE)
file.copy('report.log', opt$report_log, recursive=TRUE)





