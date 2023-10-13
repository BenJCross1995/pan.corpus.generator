#' Read a jsonl file
#'
#' @param file_loc The location of the jsonl file to read.
#'
#' @return A dataframe.
#' @export
#'
#' @examples
#' # file_loc <- ".data/pan20-authorship-verification-training-example.jsonl"
#' # usedf <- read_jsonl(file_loc)
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
