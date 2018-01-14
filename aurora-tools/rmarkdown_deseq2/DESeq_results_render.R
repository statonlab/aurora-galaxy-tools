library(getopt)
library(rmarkdown)
library(htmltools)
library(dplyr)
library(DESeq2)
library(pheatmap)
library(genefilter)
library(DT)
library(stringi)
library(RColorBrewer)
library(ggplot2)

##============ Sink warnings and errors to a file ==============
## use the sink() function to wrap all code within it.
##==============================================================
zz = file('warnings_and_errors.txt')
sink(zz)
sink(zz, type = 'message')
  ##---------below is the code for rendering .Rmd templates-----
  
  ##=============STEP 1: handle command line arguments==========
  ##
  ##============================================================
  # column 1: the long flag name
  # column 2: the short flag alias. A SINGLE character string
  # column 3: argument mask
  #           0: no argument
  #           1: argument required
  #           2: argument is optional
  # column 4: date type to which the flag's argument shall be cast.
  #           possible values: logical, integer, double, complex, character.
  #-------------------------------------------------------------
  #++++++++++++++++++++ Best practice ++++++++++++++++++++++++++
  # 1. short flag alias should match the flag in the command section in the XML file.
  # 2. long flag name can be any legal R variable names
  # 3. two names in args_list can have common string but one name should not be a part of another name.
  #    for example, one name is "ECHO", if another name is "ECHO_XXX", it will cause problems.
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  args_list=list()
  ##------- 1. input data ---------------------
  args_list$ECHO = c('echo', 'e', '1', 'character')
  args_list$DESEQ_WORKSPACE = c('deseq_workspace', 'W', '1', 'character')
  args_list$CONTRAST_FACTOR = c('contrast_factor', 'C', '1', 'character')
  args_list$TREATMENT_LEVEL = c('treatment_level', 'T', '1', 'character')
  args_list$CONDITION_LEVEL = c('condition_level', 'K', '1', 'character')
  args_list$CLUSTERING_FACTORS = c('clustering_factors', 'M', '1', 'character')
  ##--------2. output report and outputs --------------
  args_list$REPORT_HTML = c('report_html', 'r', '1', 'character')
  args_list$REPORT_DIR = c('report_dir', 'd', '1', 'character')
  args_list$SINK_MESSAGE = c('sink_message', 's', '1', 'character')
  args_list$DESEQ_RESULTS = c('deseq_results', 'R', '1', 'character')
  ##--------3. .Rmd templates in the tool directory ----------
  args_list$deseq_results_RMD = c('deseq_results_rmd', 't', '1', 'character')
  ##-----------------------------------------------------------
  opt = getopt(t(as.data.frame(args_list)))


  
  ##=======STEP 2: create report directory (optional)==========
  ##
  ##===========================================================
  dir.create(opt$report_dir)
  
  ##=STEP 3: replace placeholders in .Rmd with argument values=
  ##
  ##===========================================================
  #++ need to replace placeholders with args values one by one+
  readLines(opt$deseq_results_rmd) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('DESEQ_WORKSPACE', opt$deseq_workspace, x)
    }) %>%
    (function(x) {
      gsub('CONTRAST_FACTOR', opt$contrast_factor, x)
    }) %>%
    (function(x) {
      gsub('TREATMENT_LEVEL', opt$treatment_level, x)
    }) %>%
    (function(x) {
      gsub('CONDITION_LEVEL', opt$condition_level, x)
    }) %>%
    (function(x) {
      gsub('CLUSTERING_FACTORS', opt$clustering_factors, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      gsub('DESEQ_RESULTS', opt$deseq_results, x)
    }) %>%
    (function(x) {
      fileConn = file('deseq_results.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  

  ##=============STEP 4: render .Rmd templates=================
  ##
  ##===========================================================
  render('deseq_results.Rmd', output_file = opt$report_html)


  ##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================