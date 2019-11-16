# ------------------------------------------------------------------
# Set options and load libraries.
# ------------------------------------------------------------------

# setup R error handline to go to stderr
options(show.error.messages=FALSE, error=function() {
          cat(geterrmessage(), file=stderr())
          quit("no", 1, F)
})

# We need  to not crash galaxy with an UTF8 error on German LC settings.
loc = Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

# suppress warning
options(warn = -1)

options(stringsAsFactors=FALSE, useFancyQuotes=FALSE)

args = commandArgs(trailingOnly=TRUE)

suppressPackageStartupMessages({
  library(getopt)
  library(tools)
  library(WGCNA)
})

# Load libraries
library(rmarkdown)
library(WGCNA)
library(DT)
library(htmltools)
library(ggplot2)

# ------------------------------------------------------------------
# Handle arguments from command line
# ------------------------------------------------------------------

# Get the tool arguments.
spec = matrix(c(
    'height_cut','h',2,'double',
    'trait_data','t',1,'character',
    'expression_data','e',1,'character',
    'soft_threshold_power','p',2,'double',
    'plot_genes','n',2,'integer',
    'report_html', 'r', 1, 'character',
    'genes_info_file', 'g', 1, 'character'
  ),
  byrow=TRUE, ncol=4)

opt = getopt(spec)

# Define environment variables for all input values. This will allow use
# of the input arguments in the Rmarkdown template file.
do.call(Sys.setenv, opt[-1])

# ------------------------------------------------------------------
# Render Rmd files
# ------------------------------------------------------------------

# Copy the Rmarkdown file to the working directory. The TOOL_INSTALL_DIR
# environment variable is set in the <command? tag of the aurora_wgcna.xml file.
tool_directory = Sys.getenv('TOOL_INSTALL_DIR')
system(command = paste0('cp ', tool_directory, '/aurora_wgcna.Rmd ./'))

# Next render the R markdown template file.
render(input = 'aurora_wgcna.Rmd',  output_file = opt$report_html)
