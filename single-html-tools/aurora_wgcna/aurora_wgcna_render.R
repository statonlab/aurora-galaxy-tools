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

# Import getopt specification matrix from a csv file
opt = getopt(getopt_specification_matrix('getopt_specification.csv',
                                         tool_dir=Sys.getenv('TOOL_INSTALL_DIR')))
# Define environment variables for all input values. this is useful when we
# want to use input values by other programming language in R markdown.
do.call(Sys.setenv, opt[-1])

# ------------------------------------------------------------------
# Render Rmd files
# ------------------------------------------------------------------

# We must first copy all rmarkdown files from tool install
# directory to REPORT_FILES_PATH directory, and render rmarkdown files
# in the REPORT_FILES_PATH directory.
system(command = 'cp -r ${TOOL_INSTALL_DIR}/*.Rmd ${REPORT_FILES_PATH}')

# Next render the R markdown template file.
render(input = paste0(Sys.getenv('REPORT_FILES_PATH'), '/aurora_wgcna.Rmd')
       output = paste0(Sys.getenv('REPORT_FILES_PATH'), '/wgcna_report.html'))
