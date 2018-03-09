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
library(ggplot2)
library(plotly)
library(htmltools)
library(DESeq2)
library(pheatmap)
library(DT)
#------------------------------------------------


#------------get arguments into R--------------------
# library(dplyr)
# getopt_specification_matrix(extract_short_flags('deseq2.xml')) %>%
#   write.table(file = 'spec.txt', sep = ',', row.names = FALSE, col.names = TRUE, quote = FALSE)


spec_matrix = as.matrix(
  data.frame(stringsAsFactors=FALSE,
              long_flags = c("X_e", "X_o", "X_d", "X_s", "X_t", "X_A", "X_B",
                             "X_C", "X_D", "X_E", "X_F", "X_G", "X_H", "X_I", "X_J"),
             short_flags = c("e", "o", "d", "s", "t", "A", "B", "C", "D", "E",
                             "F", "G", "H", "I", "J"),
     argument_mask_flags = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                             1L, 1L),
         data_type_flags = c("character", "character", "character", "character",
                             "character", "character", "character", "character",
                             "character", "character", "character", "character",
                             "character", "double", "character")
  )
)
opt = getopt(spec_matrix)
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
RMD_NAME = 'deseq2.Rmd'
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