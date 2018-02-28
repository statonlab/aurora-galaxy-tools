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
# getopt_specification_matrix(extract_short_flags('fastqc_report.xml')) %>%
#   write.table(file = 'spec.txt', sep = ',', row.names = FALSE, col.names = TRUE, quote = FALSE)


spec_matrix = as.matrix()
opt = getopt(spec_matrix)
#----------------------------------------------------


#-----------using passed arguments in R 
#           to define system environment variables---
do.call(Sys.setenv, opt[-1])
#----------------------------------------------------

#---------- often used variables ----------------
# OUTPUT_DIR: path to the output associated directory, which stores all outputs
# TOOL_DIR: path to the tool installation directory
OUTPUT_DIR = ''
TOOL_DIR =   ''
RMD_NAME = ''

# create the output associated directory to store all outputs
dir.create(OUT_DIR, recursive = TRUE)

#-----------------render Rmd--------------
render(paste0(TOOL_DIR, RMD_NAME, sep = '/'), OUTPUT_DIR)
#------------------------------------------

#==============the end==============


##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================