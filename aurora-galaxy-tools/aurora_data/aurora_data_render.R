##============ Sink warnings and errors to a file ==============
## use the sink() function to wrap all code within it.
##==============================================================
zz = file(paste0(Sys.getenv('REPORT_FILES_PATH'), '/.r_rendering.log.txt'))
sink(zz)
sink(zz, type = 'message')

#------------import libraries--------------------
options(stringsAsFactors = FALSE)

library(getopt)
library(rmarkdown)
library(htmltools)
#------------------------------------------------


#---------------------get paths and names of collective datasets ---------------------------
data_paths_and_names = read.table(paste0(Sys.getenv('REPORT_FILES_PATH'), '/.data_paths_and_names.txt'), 
                                   sep = '|', header = TRUE)
#-------------------------------------------------------------------------------------------



#-----------------render Rmd--------------
# copy R markdown file to working directory and render it within the working directory.
render(paste0(Sys.getenv('TOOL_INSTALL_DIR'), '/aurora_data.Rmd'),
       output_file = paste0(Sys.getenv('REPORT_FILES_PATH'), '/report.html'))

# for some unknow reason, directly using REPORT as the input value for output_file parameter
# in the render function can cause empty report file when the tool runs in batch mode.
# the solution is to render the rmarkdown to a explicitly specified file and then copy the
# file to ${REPORT}
system(command = 'cp ${REPORT_FILES_PATH}/report.html ${REPORT}')
#------------------------------------------

#==============the end==============


##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================
