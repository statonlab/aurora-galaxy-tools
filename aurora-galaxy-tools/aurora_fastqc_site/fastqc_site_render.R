##============ Sink warnings and errors to a file ==============
## use the sink() function to wrap all code within it.
##==============================================================
zz = file('warnings_and_errors.txt')
sink(zz)
sink(zz, type = 'message')
  
library(getopt)
library(rmarkdown)
library(htmltools)
library(plyr)
library(dplyr)
library(stringr)
library(DT)
library(reshape2)
library(plotly)
options(stringsAsFactors = FALSE)

# getopt_specification_matrix(extract_short_flags('fastqc_report.xml')) %>%
#   write.table(file = 'spec.txt', sep = ',', row.names = FALSE, col.names = TRUE, quote = FALSE)


# get arguments into R
spec_matrix = as.matrix(
  data.frame(stringsAsFactors=FALSE,
              long_flags = c("X_e", "X_r", "X_n", "X_R", "X_N", "X_c", "X_l",
                             "X_o", "X_d", "X_s", "X_t"),
             short_flags = c("e", "r", "n", "R", "N", "c", "l", "o", "d", "s",
                             "t"),
     argument_mask_flags = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
         data_type_flags = c("character", "character", "character", "character",
                             "character", "character", "character",
                             "character", "character", "character", "character")
  )
)
opt = getopt(spec_matrix)
#----------------------------------------------------


#-----------using passed arguments in R 
#           to define system environment variables---
do.call(Sys.setenv, opt[-1])
#----------------------------------------------------

#---------- often used variables ----------------
# OUTPUT_REPORT: path to galaxy output report
# OUTPUT_DIR: path to the output associated directory, which stores all outputs
# TOOL_DIR: path to the tool installation directory
OUTPUT_DIR = opt$X_d
TOOL_DIR =   opt$X_t
OUTPUT_REPORT = opt$X_o


# create the output associated directory to store all outputs
dir.create(OUTPUT_DIR, recursive = TRUE)

# copy site generating materials into OUTPUT_DIR
dir.create(paste0(OUTPUT_DIR, '/site_generator'), recursive = TRUE)
system(paste0('cp -r ', TOOL_DIR, '/*.Rmd ', OUTPUT_DIR, '/site_generator/'))
system(paste0('cp -r ', TOOL_DIR, '/_site.yml ', OUTPUT_DIR, '/site_generator/_site.yml'))
system(paste0('cp -r ', TOOL_DIR, '/index.Rmd ', OUTPUT_DIR, '/site_generator/index.Rmd'))
# render site to OUTPUT_DIR/_site, this is configured in the "_site.yml" file
render_site(input = paste0(OUTPUT_DIR, '/site_generator'))
# remove site generating materials from output associated directory
unlink(paste0(OUTPUT_DIR, '/site_generator'), recursive = TRUE)
# move _site/* into output associated directory
move_cmd = paste0('mv ', OUTPUT_DIR, '/_site/* ', OUTPUT_DIR)
system(move_cmd)
#------------------------------------------

#-----link index.html to output-----
cp_index = paste0('cp ', opt$X_d, '/index.html ', opt$X_o)
system(cp_index)
#-----------------------------------

#==============the end==============



# file.copy(paste0(opt$X_d, '/index.html'), opt$X_o, recursive = TRUE)

##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================