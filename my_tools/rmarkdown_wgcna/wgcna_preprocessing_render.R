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
spec_list$EXPRESSION_DATA = c('expression_data', 'E', '1', 'character')


##--------2. output report and report site directory --------------
spec_list$OUTPUT_HTML = c('wgcna_preprocessing_html', 'o', '1', 'character')
spec_list$OUTPUT_DIR = c('wgcna_preprocessing_dir', 'd', '1', 'character')
spec_list$PREPROCESSING_WORKSPACE = c('preprocessing_workspace', 'w', '1', 'character')

##--------3. Rmd templates sitting in the tool directory ----------

spec_list$WGCNA_PREPROCESSING_RMD = c('wgcna_preprocessing_rmd', 'D', '1', 'character')



##------------------------------------------------------------------

spec = t(as.data.frame(spec_list))
opt = getopt(spec)
# arguments are accessed by long flag name (the first column in the spec matrix)
#                        NOT by element name in the spec_list
# example: opt$help, opt$expression_file
##====== End of arguments handling ==========

#------ Load libraries ---------
library(rmarkdown)
library(WGCNA)
library(DT)
library(htmltools)


#----- 1. create the report directory ------------------------
system(paste0('mkdir -p ', opt$wgcna_preprocessing_dir))


#----- 2. generate Rmd files with Rmd templates --------------
#   a. templates without placeholder variables:
#         copy templates from tool directory to the working directory.
#   b. templates with placeholder variables:
#         substitute variables with user input values and place them in the working directory.


#----- 01 wgcna_preprocessing.Rmd -----------------------
readLines(opt$wgcna_preprocessing_rmd) %>%
  (function(x) {
    gsub('ECHO', opt$echo, x)
  }) %>%
  (function(x) {
    gsub('EXPRESSION_DATA', opt$expression_data, x)
  }) %>%
  (function(x) {
    gsub('OUTPUT_DIR', opt$wgcna_preprocessing_dir, x)
  }) %>%
  (function(x) {
    gsub('PREPROCESSING_WORKSPACE', opt$preprocessing_workspace, x)
  }) %>%
  (function(x) {
    fileConn = file('wgcna_preprocessing.Rmd')
    writeLines(x, con=fileConn)
    close(fileConn)
  })


#------ 3. render all Rmd files --------
render('wgcna_preprocessing.Rmd', output_file = opt$wgcna_preprocessing_html)

#-------4. manipulate outputs -----------------------------


