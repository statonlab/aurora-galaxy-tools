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
    # Input Files
    'trait_data',                  't', 2, 'character',
    'expression_data',             'e', 1, 'character',

    # Input Arguments
    'missing_value',               'i', 1, 'character',
    'sname_col',                   'c', 2, 'integer',
    'min_cluster_size',            's', 1, 'integer',
    'height_cut',                  'h', 2, 'double',
    'power',                       'p', 2, 'double',
    'block_size',                  'b', 1, 'integer',
    'hard_threshold',              'j', 1, 'integer',

    # Output Files
    'gene_module_file',            'k', 1, 'character',
    'network_edges_file',          'w', 1, 'character',
    'gene_association_file',       'g', 2, 'character',
    'module_association_file',     'm', 2, 'character',
    'module_association_report',   'q', 2, 'character',
    'network_construction_report', 'r', 1, 'character',
    'r_data',                      'a', 1, 'character',
    'render_log_file',             'l', 1, 'character'
  ),
  byrow=TRUE, ncol=4)

opt = getopt(spec)

# Define environment variables for all input values. This will allow use
# of the input arguments in the Rmarkdown template file.
do.call(Sys.setenv, opt[-1])

# ------------------------------------------------------------------
# Render Rmd files
# ------------------------------------------------------------------
tool_directory = Sys.getenv('TOOL_INSTALL_DIR')


# We don't want the Rmarkdown STDOUT to show up in Galaxy, so save it to a file.
zz = file(opt$render_log_file)
sink(zz)
sink(zz, type = 'message')

# Next render the R markdown template file.
system(command = paste0('cp ', tool_directory, '/aurora_wgcna.Rmd ./'))
render(input = 'aurora_wgcna.Rmd',  output_file = opt$network_construction_report)

# If the trait data was provided then we'll continue the
# analysis.
if (!is.null(opt$trait_data)) {
  system(command = paste0('cp ', tool_directory, '/aurora_wgcna_trait.Rmd ./'))
  render(input = 'aurora_wgcna_trait.Rmd',  output_file = opt$module_association_report)
}

sink()
