
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
spec_list$G_ANALYSIS_FILES = c('g_analysis_files', 'G', '1', 'character')
spec_list$BLAST_TABLE = c('blast_table', 'b', '1', 'character')
spec_list$GAP_SIZE = c('gap_size', 'g', '1', 'character')
spec_list$CLUSTER_GAP = c('cluster_gap', 'c', '1', 'character')
spec_list$Q_VALUE = c('q_value', 'q', '1', 'character')
spec_list$PROB_CUTOFF = c('prob_cutoff', 'p', '1', 'character')
spec_list$ANCHOR_POINTS = c('anchor_points', 'a', '1', 'character')
spec_list$ALIGNMENT_METHOD = c('alignment_method', 'm', '1', 'character')
spec_list$LEVEL2ONLY = c('level2only', 'l', '1', 'character')
spec_list$TABLE_TYPE = c('table_type', 'T', '1', 'character')
spec_list$MULTI_HYPOTHESIS_CORRECTION = c('multi_hypothesis_correction', 'h', '1', 'character')


##--------2. output report and report site directory --------------
spec_list$I_ADHORE_CONFIGURE_TXT = c('i_adhore_configure_txt', 'x', '1', 'character')
spec_list$OUTPUT_HTML = c('i_adhore_configure_html', 'o', '1', 'character')
spec_list$OUTPUT_DIR = c('i_adhore_configure_dir', 'd', '1', 'character')


##--------3. Rmd templates sitting in the tool directory ----------
spec_list$I_ADHORE_CONFIGURE_RMD = c('i_adhore_configure_rmd', '-t', '1', 'character')


spec = t(as.data.frame(spec_list))
opt = getopt(spec)
# arguments are accessed by long flag name (the first column in the spec matrix)
#                        NOT by element name in the spec_list
# example: opt$help, opt$expression_file
##====== End of arguments handling ==========

#------ Load libraries ---------
library(rmarkdown)
library(plyr)
library(dplyr)
library(htmltools)


#----- 1. create the report directory ------------------------
system(paste0('mkdir -p ', opt$i_adhore_configure_dir))
# set working directory to output files directory
setwd(opt$i_adhore_configure_dir)


#----- 2. generate Rmd files with Rmd templates --------------
#   a. templates without placeholder variables:
#         copy templates from tool directory to the working directory.
#   b. templates with placeholder variables:
#         substitute variables with user input values and place them in the working directory.


#----- 01 i_adhore_configure.Rmd -----------------------
readLines(opt$i_adhore_configure_rmd) %>%
    (function(x) {
        gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
        gsub('I_ADHORE_CONFIGURE_TXT', opt$i_adhore_configure_txt, x)
    }) %>%
    (function(x) {
        fileConn = file('i_adhore_configure.Rmd')
        writeLines(x, con=fileConn)
        close(fileConn)
    })


#------ 3. render all Rmd files --------
render('i_adhore_configure.Rmd', output_file = opt$i_adhore_configure_html)
