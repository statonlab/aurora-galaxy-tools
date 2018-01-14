##======= Handle arguments from command line ========
# setup R error handline to go to stderr
options(show.error.messages=FALSE,
        error=function(){
          cat(geterrmessage(), file=stderr())
          quit("no", 1, F)
        })

# we need that to not crash galaxy with an UTF8 error on German LC settings.
loc = Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

# suppress warning
options(warn = -1)

options(stringsAsFactors=FALSE, useFancyQuotes=FALSE)
args = commandArgs(trailingOnly=TRUE)

suppressPackageStartupMessages({
  library(getopt)
  library(tools)
})

# column 1: the long flag name
# column 2: the short flag alias. A SINGLE character string
# column 3: argument mask
#           0: no argument
#           1: argument required
#           2: argument is optional
# column 4: date type to which the flag's argument shall be cast.
#           possible values: logical, integer, double, complex, character.
spec_list=list()
spec_list$READS = c('reads', 'r', '1', 'character')
spec_list$ECHO = c('echo', 'e', '1', 'character')
spec_list$FASTQC_TPL = c('fastqc_tpl', 'p', 1, 'character')
spec_list$REPORT = c('report', 'o', '1', 'character')
spec_list$REPORT_OUTPUT_DIR = c('report_output_dir', 'd', '1', 'character')


spec = t(as.data.frame(spec_list))

opt = getopt(spec)
# arguments are accessed by long flag name (the first column in the spec matrix)
#                        NOT by element name in the spec_list
# example: opt$help, opt$expression_file
##====== End of arguments handling ==========


mgsub = function(pattern, replacement, x) {
  if(length(pattern) != length(replacement) ) {
    stop("pattern and replacement have to be the same in length")
  }
  
  result = x
  
  for(i in 1:length(pattern)) {
    result = try( gsub(pattern[i], replacement[i], x = result) )
  }
  
  result
}


##====== replace variables in tpl file ======
p = c('READS', 
      'ECHO',
      'FASTQC_TPL',
      'REPORT_OUTPUT_DIR',
      'REPORT')
r = c(opt$reads,
      opt$echo,
      opt$fastqc_tpl,
      opt$report_output_dir,
      opt$report)

fastqc_report_tpl = mgsub(p, r, readLines(opt$fastqc_tpl))

##====== write replaced text into Rmd file ===
fileConn = file('fastqc_report.Rmd')
writeLines(fastqc_report_tpl, con=fileConn)
close(fileConn)

##====== render Rmd files ====================
rmarkdown::render('fastqc_report.Rmd')
file.copy('fastqc_report.html', opt$report, recursive=TRUE)
paste0('cp -r ./* ', opt$report_output_dir) %>%
  system()

