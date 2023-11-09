#############################################################
################ FUNCTIONS TO GET FILE PATHS ################
#############################################################

check_pan_exists <- function(file_loc){
  if(!file.exists(file_loc)){
    stop("Please enter a valid PAN-AV dataset location.")
  }
}

#' Return file paths of all files in location
#'
#' @param file_loc PAN-AV data location
#'
#' @return A vector
#' @export
get_file_locs <- function(file_loc){

  # Check the location is valid
  check_pan_exists(file_loc)

  # Initialise the files and temporary location
  unchecked_files <- c(file_loc)
  checked_files <- c()
  tempdir <- tempdir()

  # Loop to check all file paths iteratively
  while(length(unchecked_files) > 0){
    file_to_check <- unchecked_files[1]

    # Check file information
    temp_file <- file.info(file_to_check)

    # If the file is a directory save here
    folder <- temp_file |> dplyr::filter(temp_file$isdir == TRUE)

    # First deal with the case that the file is a directory
    if(nrow(folder) > 0){

      # We need to append the unchecked files with the files within the directory,
      # pasting the original location with the new files
      unchecked_files <- append(unchecked_files,
                                paste0(file_to_check, "/", list.files(file_to_check)))

      # Next we check for .zip files as they don't show as directories
    } else if(tools::file_ext(file_to_check) == 'zip'){
      # Unzip any files to a temporary location and store the locations as unchecked

      files <- utils::unzip(file_to_check, exdir = tempdir)
      unchecked_files <- append(unchecked_files, files)

      # Finally add any other files to the checked list, assuming all of these files
      # are now in a state to be read. I will test this.
    } else {
      checked_files <- append(checked_files, file_to_check)
    }

    # Remove the unchecked file
    unchecked_files <- unchecked_files[unchecked_files != file_to_check]
  }

  # Store the vector containing the filepath of all checked files.
  return(checked_files)
}

#' Get paths and info about PAN-AV docs
#'
#' @param file_loc Location of the PAN-AV files.
#'
#' @return A dataframe
#' @export
get_file_details <- function(file_loc){

  file_info <- data.frame('file' = get_file_locs(file_loc))

  file_info <- file_info |>
    dplyr::mutate(file_type = tools::file_ext(file),
                  competition = stringr::str_extract(file_info$file, "pan[^-]+"),
                  category = dplyr::case_when(
                    stringr::str_count(file, "test") > stringr::str_count(file, "train") ~ "test",
                    stringr::str_count(file, "train") > stringr::str_count(file, "test") ~ "train",
                    TRUE ~ as.character(NA)
                  ),
                  truth = ifelse(stringr::str_detect(file, "truth"), TRUE, FALSE),
                  known = ifelse(stringr::str_detect(file, "/known"), TRUE, FALSE),
                  contents = ifelse(stringr::str_detect(file, "contents"), TRUE, FALSE)) |>
    dplyr::arrange(dplyr::desc(file_info$competition))

  return(file_info)
}
