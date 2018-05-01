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
spec_list$ECHO = c('echo', 'e', '1', 'character')
spec_list$COLLASPED_READS = c('collapsed_reads', 'a', '1', 'character')
spec_list$REFERENCE_GENOME = c('reference_genome', 'b', '1', 'character')
spec_list$READS_MAPPING = c('reads_mapping', 'c', '1', 'character')

##--------2. output report and report site directory --------------
spec_list$OUTPUT_HTML = c('mirdeep2_html', 'o', '1', 'character')
spec_list$OUTPUT_DIR = c('mirdeep2_output_dir', 'd', '1', 'character')
spec_list$CSV_RESULT = c('csv_result', 'r', '1', 'character')
spec_list$HTML_RESULT = c('html_result', 't', '1', 'character')
spec_list$REPORT_LOG = c('report_log', 'u', '1', 'character')

##---------other parameters---------
spec_list$SPECIES_MATURE_MIRNA = c('species_mature_mirna', 'f', '2', 'character')
spec_list$SPECIES_RELATED_MATURE_MIRRNA = c('related_species_mature_mirna', 'g', '2', 'character')
spec_list$PRECURSOR_SEQUENCES = c('precursor_sequences', 'h', '2', 'character')
spec_list$MIN_READ_STACK_HEIGHT = c('min_read_stack_height', 'j', '2', 'character')
spec_list$MIN_SCORE_CUTOFF = c('min_score_cutoff', 'k',  '2', 'character')
spec_list$RANDFOLD_ANALYSIS = c('randfold_analysis', 'l', '2', 'character')
spec_list$MAX_PRECURSOR_NUMBER = c('max_precursor_number', 'm', '2', 'character')
spec_list$SPECIES = c('species', 'n', '2', 'character')
spec_list$SWITCH = c('switch', 'q', '2', 'character')

##--------3. Rmd templates sitting in the tool directory ----------

## _site.yml and index.Rmd files
spec_list$SITE_YML = c('site_yml', 's', 1, 'character')
spec_list$INDEX_Rmd = c('index_rmd', 'i', 1, 'character')

## other Rmd body template files
spec_list$MIRDEEP2_RMD = c('mirdeep2_rmd', 'p', '1', 'character')



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
paste0('mkdir -p ', opt$mirdeep2_output_dir) %>%
system()

#----- 2. generate Rmd files with Rmd templates --------------
#   a. templates without placeholder variables:
#         copy templates from tool directory to the working directory.
#   b. templates with placeholder variables:
#         substitute variables with user input values and place them in the working directory.


#----- mirdeep2.Rmd -----------------------
readLines(opt$mirdeep2_rmd) %>%
  (function(x) {
    gsub('ECHO', opt$echo, x)
  }) %>%
  (function(x) {
    gsub('COLLAPSED_READS', opt$collapsed_reads, x)
  }) %>%
  (function(x) {
    gsub('REFERENCE_GENOME', opt$reference_genome, x)
  }) %>%
  (function(x) {
    gsub('READS_MAPPING', opt$reads_mapping, x)
  }) %>%
  (function(x) {
    gsub('SPECIES_MATURE_MIRNA', opt$species_mature_mirna, x)
  }) %>%
  (function(x) {
    gsub('SPECIES_RELATED_MATURE_MIRNA', opt$related_species_mature_mirna, x)
  }) %>%
  (function(x) {
    gsub('PRECURSOR_SEQUENCES', opt$precursor_sequences, x)
  }) %>%
  (function(x) {
    gsub('MIN_READ_STACK_HEIGHT', opt$min_read_stack_height, x)
  }) %>%
  (function(x) {
    gsub('MIN_SCORE_CUTOFF', opt$min_score_cutoff, x)
  }) %>%
  (function(x) {
    gsub('RANDFOLD_ANALYSIS', opt$randfold_analysis, x)
  }) %>%
  (function(x) {
    gsub('MAX_PRECURSOR_NUMBER', opt$max_precursor_number, x)
  }) %>%
  (function(x) {
    gsub('SPECIES', opt$species, x)
  }) %>%
  (function(x) {
    gsub('SWITCH', opt$switch, x)
  }) %>%
  (function(x) {
    gsub('OUTPUT_DIR', opt$mirdeep2_output_dir, x)
  }) %>%
  (function(x) {
    fileConn = file('mirdeep2.Rmd')
    writeLines(x, con=fileConn)
    close(fileConn)
  })


#------ 3. render all Rmd files with render() --------
render('mirdeep2.Rmd',output_file = opt$mirdeep2_html)


#-------4. manipulate outputs -----------------------------
#   a. copy non-site files
file.copy('result.csv', opt$csv_result, recursive=TRUE)
file.copy('result.html', opt$html_result, recursive=TRUE)
file.copy('report.log', opt$report_log, recursive=TRUE)




