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
##------- 1. input data ---------------------
spec_list=list()
spec_list$FORWARD_INPUT = c('forward_input', 'L', '1', 'character')
spec_list$REVERSE_INPUT = c('reverse_input', 'R', '1', 'character')
spec_list$ECHO = c('echo', 'e', '1', 'character')
spec_list$FORMAT = c('format', 'f', '1', 'character')
##--------2. output report and outputs --------------
spec_list$OUTPUT_HTML = c('paired_collection_html', 'r', '1', 'character')
spec_list$OUTPUT_DIR = c('paired_collection_dir', 'd', '1', 'character')
##--------3. Rmd templates in the tool directory ----------
spec_list$PAIRED_COLLECTION_RMD = c('paired_collection_rmd', 't', '1', 'character')

spec = t(as.data.frame(spec_list))
opt = getopt(spec)
##====== End of arguments handling ==========

#------ Load libraries ---------
library(rmarkdown)
library(htmltools)
library(dplyr)

#----- 1. create the report directory ------------------------
system(paste0('mkdir -p ', opt$paired_collection_dir))

#----- 2. generate Rmd files with Rmd templates --------------
#   a. templates without placeholder variables:
#         copy templates from tool directory to the working directory.
#   b. templates with placeholder variables:
#         substitute variables with user input values and place them in the working directory.

#----- 01 paired_collection.Rmd -----------------------
readLines(opt$paired_collection_rmd) %>%
  (function(x) {
    gsub('ECHO', opt$echo, x)
  }) %>%
  (function(x) {
    gsub('FORMAT', opt$format, x)
  }) %>%
  (function(x) {
    gsub('FORWARD_INPUT', opt$forward_input, x)
  }) %>%
  (function(x) {
    gsub('REVERSE_INPUT', opt$reverse_input, x)
  }) %>%
  (function(x) {
    gsub('OUTPUT_DIR', opt$paired_collection_dir, x)
  }) %>%
  (function(x) {
    fileConn = file('paired_collection.Rmd')
    writeLines(x, con=fileConn)
    close(fileConn)
  })

#------ 3. render all Rmd files --------
render('paired_collection.Rmd', output_file = opt$paired_collection_html)


#-------4. manipulate outputs -----------------------------
