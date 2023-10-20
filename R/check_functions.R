#' Check File Exists
#'
#' @param file_loc The supposed location of the PAN files
#'
#' @export
check_pan_exists <- function(file_loc){
  if(!file.exists(file_loc)){
    stop("Please enter a valid PAN-AV dataset location.")
  }
}

load_pan <- function(file_loc){

  # Check the location is valid
  check_pan_exists(file_loc)

  # Initialise the files
  unchecked_files <- c(file_loc)
  checked_files <- c()

  while(length(unchecked_files) > 0){
    file_to_check <- unchecked_files[1]
    print(file_to_check)
    # Check file information
    temp_file <- file.info(file_to_check)

    # If the file is a directory save here
    folder <- temp_file |> dplyr::filter(isdir == TRUE)

    # First deal with the case that the file is a directory
    if(nrow(folder) > 0){

      # We need to append the unchecked files with the files within the directory,
      # pasting the original location with the new files
      unchecked_files <- append(unchecked_files,
                                paste0(file_to_check, "/", list.files(file_to_check)))

      # Next we check for .zip files as they don't show as directories
    } else if(tools::file_ext(file_to_check) == 'zip'){
      # Unzip any files to a temporary location and store the locations as unchecked
      tempdir <- tempdir()
      files <- unzip(file_to_check, exdir = tempdir)
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