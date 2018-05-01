
#------------import libraries--------------------
library(getopt)
library(rmarkdown)
#------------------------------------------------

#------------1. collect input values in R--------
#------------2. define environment variables-----
spec_matrix = as.matrix(
  data.frame(stringsAsFactors=FALSE,
              long_flags = c("X_r", "X_c", "X_R", "X_O", "X_T"),
             short_flags = c("r", "c", "R", "O", "T"),
     argument_mask_flags = c(1L, 1L, 1L, 1L, 1L),
         data_type_flags = c("integer", "integer", "character", "character", "character")
  )
)
opt = getopt(spec_matrix)
do.call(Sys.setenv, opt[-1])
#------------------------------------------------


#-----------------render Rmd--------------
render(paste0(opt$X_T, '/aurora_demo.Rmd'), 
       output_file = opt$X_R)
#------------------------------------------

