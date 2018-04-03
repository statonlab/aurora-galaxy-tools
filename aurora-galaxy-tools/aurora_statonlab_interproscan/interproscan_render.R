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
library(htmltools)
#------------------------------------------------


#------------get arguments into R--------------------
# load helper function
source(paste0(Sys.getenv('TOOL_DIR'), '/helper.R'))
# import getopt specification matrix from a csv file
opt = getopt(getopt_specification_matrix(specification_file = '/getopt_specification.csv', 
                                         tool_dir = Sys.getenv('TOOL_DIR')))
opt$X_t = Sys.getenv('TOOL_DIR')
#----------------------------------------------------


#-----------using passed arguments in R 
#           to define system environment variables---
do.call(Sys.setenv, opt[-1])
#----------------------------------------------------

#---------- often used variables ----------------
# OUTPUT_DIR: path to the output associated directory, which stores all outputs
# TOOL_DIR: path to the tool installation directory
OUTPUT_DIR = opt$X_d
TOOL_DIR =   opt$X_t
OUTPUT_REPORT = opt$X_o
RMD_NAME = 'interproscan.Rmd'

# create the output associated directory to store all outputs
dir.create(OUTPUT_DIR, recursive = TRUE)

#-----------------render Rmd--------------
# for some unknow reason, directly using REPORT as the input value for output_file parameter
# in the render function can cause empty report file when the tool runs in batch mode.
# the solution is to render the rmarkdown to a explicitly specified file and then copy the
# file to ${REPORT}
render(paste0(TOOL_DIR, '/', RMD_NAME), 
       output_file = paste0(OUTPUT_DIR, '/report.html'))
system(command = 'cp ${X_d}/report.html ${X_o}')
#------------------------------------------

#==============the end==============


##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================