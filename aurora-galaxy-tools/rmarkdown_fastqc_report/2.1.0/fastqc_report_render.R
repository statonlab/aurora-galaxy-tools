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

spec_matrix = as.matrix(
  data.frame(stringsAsFactors=FALSE,
              long_flags = c("X_e", "X_r", "X_n", "X_R", "X_N", "X_c", "X_l",
                             "X_o", "X_d", "X_s", "X_p"),
             short_flags = c("e", "r", "n", "R", "N", "c", "l", "o", "d", "s",
                             "p"),
     argument_mask_flags = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
         data_type_flags = c("character", "character", "character", "character",
                             "character", "character", "character",
                             "character", "character", "character", "character")
  )
)
# get arguments into R
opt = getopt(spec_matrix)
# define system environment variables
do.call(Sys.setenv, opt[-1])

# render R Markdowns
render(input = opt$X_p, output_file = opt$X_o)

##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================