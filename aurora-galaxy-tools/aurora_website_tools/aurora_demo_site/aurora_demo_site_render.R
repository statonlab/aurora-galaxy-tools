
#------------import libraries--------------------
library(getopt)
library(rmarkdown)
#------------------------------------------------

#------------1. collect input values in R--------
#------------2. define environment variables-----
spec_matrix = as.matrix(
  data.frame(stringsAsFactors=FALSE,
             long_flags = c("X_r", "X_c", "X_R", "X_d", "X_O", "X_T"),
             short_flags = c("r", "c", "R", "d", "O", "T"),
             argument_mask_flags = c(1L, 1L, 1L, 1L, 1L, 1L),
             data_type_flags = c("integer", "integer", "character", "character", "character", "character")
  )
)
opt = getopt(spec_matrix)
do.call(Sys.setenv, opt[-1])
#------------------------------------------------

#---------- often used variables ----------------
# OUTPUT_REPORT: path to galaxy output report
# OUTPUT_DIR: path to the output associated directory, which stores all outputs
# TOOL_DIR: path to the tool installation directory
OUTPUT_DIR = opt$X_d
TOOL_DIR =   opt$X_T
OUTPUT_REPORT = opt$X_R


# create the output associated directory to store all outputs
dir.create(OUTPUT_DIR, recursive = TRUE)

#-----------------render site--------------
# copy site generating materials into OUTPUT_DIR
dir.create(paste0(OUTPUT_DIR, '/site_generator'), recursive = TRUE)
system(paste0('cp -r ', TOOL_DIR, '/aurora_demo_site_*.Rmd ', OUTPUT_DIR, '/site_generator/'))
system(paste0('cp -r ', TOOL_DIR, '/aurora_demo_site_site.yml ', OUTPUT_DIR, '/site_generator/_site.yml'))
system(paste0('cp -r ', TOOL_DIR, '/aurora_demo_site_index.Rmd ', OUTPUT_DIR, '/site_generator/index.Rmd'))
# render site to OUTPUT_DIR/_site, this is configured in the "_site.yml" file
render_site(input = paste0(OUTPUT_DIR, '/site_generator'))
# remove site generating materials from output associated directory
unlink(paste0(OUTPUT_DIR, '/site_generator'), recursive = TRUE)
# move _site/* into output associated directory
move_cmd = paste0('mv ', OUTPUT_DIR, '/_site/* ', OUTPUT_DIR)
system(move_cmd)
#------------------------------------------

#-----link index.html to output-----
cp_index = paste0('cp ', OUTPUT_DIR, '/index.html ', OUTPUT_REPORT)
system(cp_index)
#-----------------------------------

#==============the end==============