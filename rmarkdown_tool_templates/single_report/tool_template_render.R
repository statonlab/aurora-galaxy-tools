library(getopt)
library(rmarkdown)
library(htmltools)
library(dplyr)

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
  ##--------2. output report and outputs --------------
  args_list$REPORT_HTML = c('report_html', 'r', '1', 'character')
  args_list$REPORT_DIR = c('report_dir', 'd', '1', 'character')
  args_list$SINK_MESSAGE = c('sink_message', 's', '1', 'character')
  ##--------3. .Rmd templates in the tool directory ----------
  args_list$TOOL_TEMPLATE_RMD = c('tool_template_rmd', 't', '1', 'character')
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
  readLines(opt$tool_template_rmd) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$output_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('tool_template.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  

  ##=============STEP 4: render .Rmd templates=================
  ##
  ##===========================================================
  render('tool_template.Rmd', output_file = opt$report_html)


  ##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================