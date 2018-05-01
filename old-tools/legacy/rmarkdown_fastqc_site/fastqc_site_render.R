library(getopt)
library(rmarkdown)
library(htmltools)
library(plyr)
library(dplyr)
library(stringr)
library(DT)
library(reshape2)
library(plotly)
options(stringsAsFactors=FALSE, useFancyQuotes=FALSE)

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
  args_list$READS_1 = c('reads_1', 'r', '1', 'character')
  args_list$NAME_1 = c('name_1', 'n', '1', 'character')
  args_list$READS_2 = c('reads_2', 'R', '1', 'character')
  args_list$NAME_2 = c('name_2', 'N', '1', 'character')
  args_list$CONTAMINANTS = c('contaminants', 'c', '1', 'character')
  args_list$LIMITS = c('limits', 'l', '1', 'character')
  ##--------2. output report and outputs --------------
  args_list$REPORT_HTML = c('report_html', 'o', '1', 'character')
  args_list$REPORT_DIR = c('report_dir', 'd', '1', 'character')
  args_list$SINK_MESSAGE = c('sink_message', 's', '1', 'character')
  ##--------3. .Rmd templates in the tool directory ----------
  args_list$SITE_YML = c('site_yml', 'S', '1', 'character')
  args_list$INDEX_RMD = c('index_rmd', 'I', '1', 'character')
  args_list$X01_EVALUATION_OVERVIEW = c('x01_evaluation_overview', 'A', '1', 'character')
  args_list$X02_PER_BASE_SEQUENCE_QUALITY = c('x02_per_base_sequence_quality', 'B', '1', 'character')
  args_list$X03_PER_TILE_SEQUENCE_QUALITY = c('x03_per_tile_sequence_quality', 'C', '1', 'character')
  args_list$X04_PER_SEQUENCE_QUALITY_SCORE = c('x04_per_sequence_quality_score', 'D', '1', 'character')
  args_list$X05_PER_BASE_SEQUENCE_CONTENT = c('x05_per_base_sequence_content', 'E', '1', 'character')
  args_list$X06_PER_SEQUENCE_GC_CONTENT = c('x06_per_sequence_gc_content', 'F', '1', 'character')
  args_list$X07_PER_BASE_N_CONTENT = c('x07_per_base_n_content', 'G', '1', 'character')
  args_list$X08_SEQUENCE_LENGTH_DISTRIBUTION = c('x08_sequence_length_distribution', 'H', '1', 'character')
  args_list$X09_SEQUENCE_DUPLICATION_LEVELS = c('x09_sequence_duplication_levels', 'J', '1', 'character')
  args_list$X10_ADAPTER_CONTENT = c('x10_adapter_content', 'K', '1', 'character')
  args_list$X11_KMER_CONTENT = c('x11_kmer_content', 'L', '1', 'character')
  ##-----------------------------------------------------------
  opt = getopt(t(as.data.frame(args_list)))


  
  ##=======STEP 2: create report directory (optional)==========
  ##
  ##===========================================================
  dir.create(opt$report_dir)
  
  ##==STEP 3: copy index.Rmd and _site.yml to job working directory======
  ##
  ##=====================================================================
  file.copy(opt$index_rmd, 'index.Rmd')
  file.copy(opt$site_yml, '_site.yml')
  
  ##=STEP 4: replace placeholders in .Rmd files with argument values=
  ##
  ##=================================================================
  #++ need to replace placeholders with args values one by one+
  
  # 01_evaluation_overview.Rmd
  readLines(opt$x01_evaluation_overview) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('READS_1', opt$reads_1, x)
    }) %>%
    (function(x) {
      gsub('NAME_1', opt$name_1, x)
    }) %>%
    (function(x) {
      gsub('READS_2', opt$reads_2, x)
    }) %>%
    (function(x) {
      gsub('NAME_2', opt$name_1, x)
    }) %>%
    (function(x) {
      gsub('CONTAMINANTS', opt$contaminants, x)
    }) %>%
    (function(x) {
      gsub('LIMITS', opt$limits, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x01_evaluation_overview.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 02_per_base_sequence_quality.Rmd
  readLines(opt$x02_per_base_sequence_quality) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x02_per_base_sequence_quality.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 03_per_tile_sequence_quality.Rmd
  readLines(opt$x03_per_tile_sequence_quality) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x03_per_tile_sequence_quality.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 04_per_sequence_quality_score.Rmd
  readLines(opt$x04_per_sequence_quality_score) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x04_per_sequence_quality_score.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 05_per_base_sequence_content.Rmd
  readLines(opt$x05_per_base_sequence_content) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x05_per_base_sequence_content.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 06_per_sequence_gc_content.Rmd
  readLines(opt$x06_per_sequence_gc_content) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x06_per_sequence_gc_content.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 07_per_base_n_content.Rmd
  readLines(opt$x07_per_base_n_content) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x07_per_base_n_content.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })

  # 08_sequence_length_distribution.Rmd
  readLines(opt$x08_sequence_length_distribution) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x08_sequence_length_distribution.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 09_sequence_duplication_levels.Rmd
  readLines(opt$x09_sequence_duplication_levels) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x09_sequence_duplication_levels.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 10_adapter_content.Rmd
  readLines(opt$x10_adapter_content) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x10_adapter_content.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  # 11_kmer_content.Rmd
  readLines(opt$x11_kmer_content) %>%
    (function(x) {
      gsub('ECHO', opt$echo, x)
    }) %>%
    (function(x) {
      gsub('REPORT_DIR', opt$report_dir, x)
    }) %>%
    (function(x) {
      fileConn = file('x11_kmer_content.Rmd')
      writeLines(x, con=fileConn)
      close(fileConn)
    })
  
  ##=============STEP 5: render all .Rmd templates=================
  ##
  ##===========================================================
  extract_data_module = function(fastqc_data, module_name, header = TRUE, comment.char = "") {
    f = readLines(fastqc_data)
    start_line = grep(module_name, f)
    end_module_lines = grep('END_MODULE', f)
    end_line = end_module_lines[which(end_module_lines > start_line)[1]]
    module_data = f[(start_line+1):(end_line-1)]
    writeLines(module_data, 'temp.txt')
    read.csv('temp.txt', sep = '\t', header = header, comment.char = comment.char)
  }
  render_site()
  
  ##=============STEP 6: manipulate outputs====================
  ##
  ##===========================================================
  file.copy('my_site/index.html', opt$report_html, recursive = TRUE)
  system(paste0('cp -r my_site/* ', opt$report_dir))


  ##--------end of code rendering .Rmd templates----------------
sink()
##=========== End of sinking output=============================