#############################################################
################ FUNCTIONS TO LOAD THE FILES ################
#############################################################

#' Read a jsonl/json file
#'
#' @param file_loc The location of the jsonl file to read.
#'
#' @return A dataframe.
read_jsonl <- function(file_loc){
  # Read each line as seperate object
  lines <- readLines(file_loc)
  # Convert to list as we read from json
  lines <- lapply(lines, jsonlite::fromJSON)
  # Unlist the object
  lines <- lapply(lines, unlist)
  # Bind rows to create a dataframe
  lines <- dplyr::bind_rows(lines)

  return(lines)
}

#' Read a txt file
#'
#' @param file_loc The filepath of the txt file to read.
#'
#' @return A dataframe.
read_txt <- function(file_loc){

  # Read the lines of data within the txt file
  lines <- readLines(file_loc)

  # Combine all elements from the vector produced above.
  lines <- paste(lines, collapse = "\n")

  return(lines)
}

#' Read the files required for the corpus
#'
#' @param file_loc The filepath of the file to read
#'
#' @return A dataframe.
#' @export
read_files <- function(file_loc){

  if(tools::file_ext(file_loc) %in% c('json', 'jsonl')){
    read_jsonl(file_loc)
    } else {
      read_txt(file_loc)
    }
}
