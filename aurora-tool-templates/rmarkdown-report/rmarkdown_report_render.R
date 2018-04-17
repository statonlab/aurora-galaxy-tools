##============ Sink warnings and errors to a file ==============
## use the sink() function to wrap all code within it.
##==============================================================
zz = file(paste0(Sys.getenv('REPORT_FILES_PATH'), '/.r_rendering.log.txt'))
sink(zz)
sink(zz, type = 'message')

#-------------------preparation -----------------
options(stringsAsFactors = FALSE)
# import libraries
library(getopt)
library(rmarkdown)
# load helper functions
source(paste0(Sys.getenv('TOOL_INSTALL_DIR'), '/helper.R'))
# import getopt specification matrix from a csv file
opt = getopt(getopt_specification_matrix('getopt_specification.csv'))
opt$X_t = Sys.getenv('TOOL_INSTALL_DIR')
# define a unix variable versions for all input values. this is useful when we 
# want to use input values by other programming language in r markdown
do.call(Sys.setenv, opt[-1])
#------------------------------------------------


#-----------------render Rmd files --------------
# NOTICE: 
#       we should copy all rmarkdown files from tool install directory to current working directory.
#       we should render rmarkdown files in the current working directory.
system(command = 'cp -r ${TOOL_INSTALL_DIR}/*.Rmd .')
for (rmd_file in list.files(pattern = "\\.Rmd$")) {
  render(rmd_file)
}
#------------------------------------------


#---------------- copy the output html to REPORT ----
system(command = 'cp ACTUAL_HTML_FILE ${REPORT}')
#==============the end==============


##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================