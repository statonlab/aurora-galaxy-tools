#' \code{getopt_specification_matrix} returns a getopt specification matrix.
#'
#' @param specification_file a cvs file within the \code{galaxy_tool_directory} which stores getopt specification matrix data.
#' The first column are short flags, the second column are argument masks, the third column
#' is data types. The fourth column are variable names used in the tool XML. These three columns are required.
#' @param gtg_name the name of a running GTG.
getopt_specification_matrix = function(specification_file,
                                       gtg_name = 'gtg',
                                       tool_dir = Sys.getenv('TOOL_DIR')) {
  df = read.csv(
    paste0(tool_dir, '/', specification_file),
    header = TRUE,
    stringsAsFactors = FALSE
  )
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
  df2 = data.frame(
    long_flags = long_flags,
    short_flags = df[, 1],
    argument_mask = df[, 2],
    data_type = df[, 3]
  )
  
  as.matrix(df2)
}



#' \code{file_tree} generate file tree of a directory in the format of HTML lists.
#'
#' @param dir the path to the directory for generating the file tree.
#' @param output_dir the REPORT_FILES_PATH folder name, which has the name style: dataset_NUMBER_files.
# define a recursive function to build html string of the file tree
file_tree = function(dir = '.') {
  # get the OUTPUT_DIR folder data: dataset_NUMBER_files
  report_files_path = Sys.getenv('REPORT_FILES_PATH')
  output_dir = tail(strsplit(report_files_path, '/')[[1]], 1)
  
  files = list.files(path = dir,
                     recursive = FALSE,
                     full.names = TRUE)
  # files also include directorys, need to remove directorys
  files = files[!dir.exists(files)]
  dirs = list.dirs(path = dir,
                   recursive = FALSE,
                   full.names = TRUE)
  tags$ul({
    if (length(files) > 0) {
      lapply(files, function(x) {
        path_end = tail(strsplit(x, '/')[[1]], 1)
        href_path = strsplit(x, paste0(output_dir, '/'))[[1]][2]
        li_item = tags$li(tags$a(path_end, href = href_path))
        li_item$attribs = list('data-jstree' = '{"icon":"jstree-file"}')
        li_item
      })
    }
  },
  {
    if (length(dirs) > 0) {
      lapply(dirs, function(x) {
        path_end = tail(strsplit(x, '/')[[1]], 1)
        # hide vakata-jstree-3.3.5 folder
        if (path_end != 'vakata-jstree-3.3.5') {
          # x_path = strsplit(x, paste0(output_dir, '/'))[[1]][2]
          li_item = tags$li(path_end, file_tree(x))
          li_item$attribs = list('data-jstree' = '{"icon":"jstree-folder"}')
          li_item
        }
      })
    }
  })
}
