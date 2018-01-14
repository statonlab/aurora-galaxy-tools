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
spec_list$READS = c('reads', 'r', '1', 'character')
spec_list$ECHO = c('echo', 'e', '1', 'character')

##--------2. output report and report site directory --------------
spec_list$OUTPUT_HTML = c('template_tool', 'o', '1', 'character')
spec_list$OUTPUT_DIR = c('template_tool_dir', 'd', '1', 'character')

##--------3. Rmd templates sitting in the tool directory ----------

## _site.yml and index.Rmd files
spec_list$SITE_YML = c('site_yml', 's', 1, 'character')
spec_list$INDEX_Rmd = c('index_rmd', 'i', 1, 'character')

## other Rmd body template files
spec_list$x = c('x01_template', 'x', '1', 'character')
spec_list$y = c('x02_template', 'y', '1', 'character')


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
library(stringr)
library(dplyr)
library(highcharter)
library(DT)
library(reshape2)
library(Kmisc)
library(plotly)
library(formattable)
library(htmltools)


#----- 1. create the report directory ------------------------
paste0('mkdir -p ', opt$template_tool_dir) %>%
    system()

#----- 2. generate Rmd files with Rmd templates --------------
#   a. templates without placeholder variables:
#         copy templates from tool directory to the working directory.
#   b. templates with placeholder variables:
#         substitute variables with user input values and place them in the working directory.


#----- Copy index.Rmd and _site.yml files to job working direcotry -----
file.copy(opt$index_rmd, 'index.Rmd', recursive=TRUE)
file.copy(opt$site_yml, '_site.yml', recursive=TRUE)
#---------------------------------------------------------

#----- 01_template.Rmd -----------------------
readLines(opt$x01_template) %>%
    (function(x) {
        gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
        gsub('OUTPUT_DIR', opt$template_tool_dir, x)
    }) %>%
    (function(x) {
        fileConn = file('01_template.Rmd')
        writeLines(x, con=fileConn)
        close(fileConn)
    })

#----- 02_template.Rmd --------------------
readLines(opt$x02_template) %>%
    (function(x) {
        gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
        fileConn = file('02_template.Rmd')
        writeLines(x, con=fileConn)
        close(fileConn)
    })

#------ 3. render all Rmd files with render_site() --------
render_site()


#-------4. manipulate outputs -----------------------------
#   a. copy index.html to the report output path
#   b. copy all files in 'my_site' to the report output directory
file.copy('my_site/index.html', opt$template_tool, recursive=TRUE)
paste0('cp -r my_site/* ', opt$template_tool_dir) %>%
    system()


