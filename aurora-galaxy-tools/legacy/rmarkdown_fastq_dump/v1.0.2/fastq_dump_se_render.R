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

#/////////////////////// SINK WARNINGS AND ERRORS TO A FILE FOR DEBUGGING ///////////
zz = file('warnings_and_errors.txt')
sink(zz)
sink(zz, type = 'message')

# column 1: the long flag name
# column 2: the short flag alias. A SINGLE character string
# column 3: argument mask
#           0: no argument
#           1: argument required
#           2: argument is optional
# column 4: date type to which the flag's argument shall be cast.
#           possible values: logical, integer, double, complex, character.
##------- 1. input data ---------------------
spec_list=list()
spec_list$SRA_ACCESSION = c('sra_accession', 'i', '1', 'character')
spec_list$FORMAT = c('format', 'f', '1', 'character')
##--------2. output report and outputs --------------
spec_list$REPORT_HTML = c('report_html', 'r', '1', 'character')
spec_list$OUTPUT_DIR = c('output_dir', 'd', '1', 'character')
spec_list$SINK_OUTPUT = c('sink_message', 's', '1', 'character')
##--------3. Rmd templates in the tool directory ----------
spec_list$FASTQ_DUMP_SE_RMD = c('fastq_dump_se_rmd', 't', '1', 'character')

spec = t(as.data.frame(spec_list))
opt = getopt(spec)

#------ Load libraries ---------
library(rmarkdown)
library(htmltools)
library(dplyr)

#----- 1. create the report directory ------------------------
dir.create(opt$output_dir)

#----- 2. generate Rmd files with Rmd templates --------------
#   a. templates without placeholder variables:
#         copy templates from tool directory to the working directory.
#   b. templates with placeholder variables:
#         substitute variables with user input values and place them in the working directory.

#----- 01 fastq_dump_se.Rmd -----------------------
readLines(opt$fastq_dump_se_rmd) %>%
  (function(x) {
    gsub('SRA_ACCESSION', opt$sra_accession, x)
  }) %>%
  (function(x) {
    gsub('FORMAT', opt$format, x)
  }) %>%
  (function(x) {
    gsub('OUTPUT_DIR', opt$output_dir, x)
  }) %>%
  (function(x) {
    fileConn = file('fastq_dump_se.Rmd')
    writeLines(x, con=fileConn)
    close(fileConn)
  })

#------ 3. render all Rmd files --------
render('fastq_dump_se.Rmd', output_file = opt$report_html)


#-------4. manipulate outputs -----------------------------





sink()
#/////////// END OF SINK OUTPUT ///////////////////////////