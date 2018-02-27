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
library(DESeq2)
library(pheatmap)
library(DT)
library(ggplot2)
library(genefilter)
library(RColorBrewer)
#------------------------------------------------


#------------get arguments into R--------------------
# getopt_specification_matrix(extract_short_flags('DESeq_results.xml')) %>%
#   write.table(file = 'spec.txt', sep = ',', row.names = FALSE, col.names = TRUE, quote = FALSE)


spec_matrix = as.matrix(
  data.frame(stringsAsFactors=FALSE,
              long_flags = c("X_e", "X_W", "X_C", "X_T", "X_K", "X_M", "X_o",
                             "X_d", "X_s", "X_R", "X_t"),
             short_flags = c("e", "W", "C", "T", "K", "M", "o", "d", "s", "R",
                             "t"),
     argument_mask_flags = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
         data_type_flags = c("character", "character", "character", "character",
                             "character", "character", "character",
                             "character", "character", "character", "character")
  )
)
opt = getopt(spec_matrix)
opt
#----------------------------------------------------


#-----------using passed arguments in R 
#           to define system environment variables---
do.call(Sys.setenv, opt[-1])
#----------------------------------------------------

#---------- often used variables ----------------
# OUTPUT_DIR: path to the output associated directory, which stores all outputs
# TOOL_DIR: path to the tool installation directory
# RMD_NAME: name of Rmd file to be rendered
# OUTPUT_REPORT: path to galaxy output report
OUTPUT_DIR = opt$X_d
TOOL_DIR =   opt$X_t
RMD_NAME = 'DESeq_results.Rmd'
OUTPUT_REPORT = opt$X_o

# create the output associated directory to store all outputs
dir.create(OUTPUT_DIR, recursive = TRUE)

#-----------------render Rmd--------------
render(paste0(TOOL_DIR, '/', RMD_NAME), output_file = OUTPUT_REPORT)
#------------------------------------------

#==============the end==============


##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================