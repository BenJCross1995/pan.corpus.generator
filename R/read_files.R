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
read_files <- function(file_loc){

  if(tools::file_ext(file_loc) %in% c('json', 'jsonl')){
    read_jsonl(file_loc)
    } else {
      read_txt(file_loc)
    }
}

#' Create a corpus object from a folder containing PAN competition data.
#'
#' @param file_loc The location of the files
#' @param selected_comp A vector containing competitions to select e.g. c('pan21')
#' @param read_large A Binary argument TRUE/FALSE whether the large documents are read
#' @param convert_to_corpus A Binary argument TRUE/FALSE to detemine whether to convert to Quanteda corpus object.
#' @param x_and_y Split the corpus into x and y as opposed to a single corpus.
#'
#' @return A dataframe or corpus object depending on the user's selection.
#' @export
create_corpus <- function(file_loc, selected_comp = 'pan21',
                          read_large = FALSE, convert_to_corpus = FALSE,
                          x_and_y = FALSE){

  # Use function to get the details of files in the folder
  file_details <- get_file_details(file_loc)

  # Get the different competitions in the fobject
  competitions <- unique(file_details$competition)

  # Check to see if user has decided to filter for specific comps
  if(all(selected_comp %in% competitions)){
    file_details <- file_details |>
      dplyr::filter(file_details$competition %in% selected_comp)

    competitions <- selected_comp
  }

  # Does the user want the large file from 2020? 12GB of data.
  if(read_large == FALSE){
    file_details <- file_details |>
      dplyr::filter(file_details$large == FALSE)
  }

  results <- list()

  # Check for "pan21" and load.
  if(sum(stringr::str_detect(competitions, "pan21")) == 1){

    # Filter the file details for pan21
    pan21 <- file_details |>
      dplyr::filter(file_details$competition == 'pan21')

    # Apply the read_files function on the file column
    pan21$text <- sapply(pan21$file, read_files)

    # Arrange by the truth column and convert to tibble so that column
    # stays as a named list
    pan21 <- pan21 |>
      dplyr::arrange(pan21$truth) |>
      dplyr::as_tibble()

    # Select and Pull were not working without this step, the named list column
    # was ruining this
    pan21_content <- pan21[,ncol(pan21)] |>
      dplyr::pull() |>
      unname()

    # Get details of content
    num_docs <- nrow(pan21_content[[1]])
    comp <- rep('pan21', num_docs)
    category <- rep(as.character(pan21[1, 4]), num_docs)

    # Join the truth with the text, might add other formatting to this
    pan21 <- pan21_content[[1]] |>
      dplyr::left_join(pan21_content[[2]],
                       by = 'id')

    # Add the details
    pan21 <- cbind(pan21, 'competition' = comp, 'category' = category)

    results <- c(results, pan21 = list(pan21))
  }

  # Check for "pan20" and load.
  if(sum(stringr::str_detect(competitions, "pan20")) == 1){

    # Filter the file details for pan21
    pan20 <- file_details |>
      dplyr::filter(file_details$competition == 'pan20')

    # Apply the read_files function on the file column
    pan20$text <- sapply(pan20$file, read_files)

    # Arrange by the truth column and convert to tibble so that column
    # stays as a named list
    pan20 <- pan20 |>
      dplyr::arrange(pan20$large, pan20$category, pan20$truth) |>
      dplyr::as_tibble()

    # Select and Pull were not working without this step, the named list column
    # was ruining this
    pan20_content <- pan20[,ncol(pan20)] |>
      dplyr::pull() |>
      unname()

    # Now we need to join together - the first is if the large dataset is included
    if(length(pan20_content) == 6){

      num_docs <- nrow(pan20_content[[5]])
      comp <- rep('pan20', num_docs)
      category <- rep(as.character(pan20[5, 4]), num_docs)

      pan20_large <- pan20_content[[5]] |>
        dplyr::left_join(pan20_content[[6]],
                         by = 'id')

      # Add the details
      pan20_large <- cbind(pan20_large, 'competition' = comp, 'category' = category)

      # Append the data to the list
      results <- c(results, pan20_large = list(pan20_large))

    }

    # Complete the joins for the test and training data
    pan20_test <- pan20_content[[1]] |>
      dplyr::left_join(pan20_content[[2]],
                       by = 'id')

    # Test details
    num_docs_test <- nrow(pan20_test)
    comp_test <- rep('pan20', num_docs_test)
    category_test <- rep('test', num_docs_test)

    pan20_train <- pan20_content[[3]] |>
      dplyr::left_join(pan20_content[[4]],
                       by = 'id')

    # Train details
    num_docs_train <- nrow(pan20_train)
    comp_train <- rep('pan20', num_docs_train)
    category_train <- rep('train', num_docs_train)

    # Add the details
    pan20_test <- cbind(pan20_test, 'competition' = comp_test, 'category' = category_test)
    pan20_train <- cbind(pan20_train, 'competition' = comp_train, 'category' = category_train)

    # Append these results to the list as named entities
    results <- c(results, list(pan20_test = pan20_test,
                               pan20_train = pan20_train))
  }

  # Bind the results together from the list
  results <- data.table::rbindlist(results)

  if(x_and_y == FALSE){
    # Here we convert the results into a table consisting of author, fandom, and text. Returning only distinct results.
    results <- as.data.frame(rbind(cbind(author = results$authors1, competition = results$competition, category = results$category,
                                         fandom = results$fandoms1, text = results$pair1),
                                   cbind(author = results$authors2, competition = results$competition, category = results$category,
                                         fandom = results$fandoms2, text = results$pair2))) |>
      dplyr::distinct()

    results <- cbind('id' = seq(1, nrow(results)), results)

    # Convert to quanteda corpus if required by the user.
    if(convert_to_corpus == TRUE){
      results = quanteda::corpus(results, text_field = "text")
    }

  } else if(x_and_y == TRUE){

    results_x <- as.data.frame(cbind(id = results$id, author = results$authors1,
                                     competition = results$competition, category = results$category,
                                     fandom = results$fandoms1, text = results$pair1))

    results_y <- as.data.frame(cbind(id = results$id, author = results$authors2,
                                     competition = results$competition, category = results$category,
                                     fandom = results$fandoms2, text = results$pair2))

    # Convert to quanteda corpus if required by the user.
    if(convert_to_corpus == TRUE){
      results_x = quanteda::corpus(results_x, text_field = "text")

      results_y = quanteda::corpus(results_y, text_field = "text")
    }

    results <- list(x = results_x, y = results_y)
  }

  #  Return the list
  return(results)
}
