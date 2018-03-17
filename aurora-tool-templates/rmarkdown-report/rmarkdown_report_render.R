##============ Sink warnings and errors to a file ==============
## use the sink() function to wrap all code within it.
##==============================================================
zz = file('warnings_and_errors.txt')
sink(zz)
sink(zz, type = 'message')

#------------import libraries--------------------
options(stringsAsFactors = FALSE)

library(getopt)
library(rmarkdown)
#------------------------------------------------


#------------get arguments into R--------------------
# load helper function
source('https://raw.githubusercontent.com/statonlab/aurora-galaxy-tools/master/aurora-tool-templates/helper.R')
# import getopt specification matrix from a csv file
spec_csv = paste0(Sys.getenv('TOOL_DIR'), '/getopt_specification.csv')
opt = getopt(getopt_specification_matrix(spec_csv))
opt$X_t = Sys.getenv('TOOL_DIR')
#----------------------------------------------------


#-----------using passed arguments in R 
#           to define system environment variables---
do.call(Sys.setenv, opt[-1])
#----------------------------------------------------

#---------- often used variables ----------------
# OUTPUT_DIR: path to the output associated directory, which stores all outputs
# TOOL_DIR: path to the tool installation directory
OUTPUT_DIR = opt$X_o
TOOL_DIR =   opt$X_t
RMD_NAME = ''
OUTPUT_REPORT = opt$X_o

# create the output associated directory to store all outputs
dir.create(OUTPUT_DIR, recursive = TRUE)

#-----------------render Rmd--------------
render(paste0(TOOL_DIR, RMD_NAME, sep = '/'), output_file = OUTPUT_REPORT)
#------------------------------------------

#==============the end==============


##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================