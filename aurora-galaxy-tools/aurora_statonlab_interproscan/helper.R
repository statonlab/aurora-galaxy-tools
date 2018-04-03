#' \code{getopt_specification_matrix} returns a getopt specification matrix.
#'
#' @param specification_file a cvs file within the \code{galaxy_tool_directory} which stores getopt specification matrix data.
#' The first column are short flags, the second column are argument masks, the third column
#' is data types. The fourth column are variable names used in the tool XML. These three columns are required.
#' @param gtg_name the name of a running GTG.
getopt_specification_matrix = function(specification_file, gtg_name = 'gtg', tool_dir = Sys.getenv('TOOL_DIRECTORY')) {
  df = read.csv(paste0(tool_dir, specification_file),
                header = TRUE, stringsAsFactors = FALSE)
  # check if there are duplicated short flags
  short_flags = df[, 1]
  if (length(unique(short_flags)) < length(short_flags)) {
    cat('----Duplicated short flags found ----\n')
    cat('short flags: ', df[, 1][duplicated(df[, 1])], '\n')
    stop('Duplicated short flags are not allowed.')
  }
  
  # use short flags to generate long flags
  long_flags = paste0('X_', df[, 1])
  
  # specification matrix
  df2 = data.frame(long_flags = long_flags,
                   short_flags = df[, 1],
                   argument_mask = df[, 2],
                   data_type = df[, 3])
  
  as.matrix(df2)
}