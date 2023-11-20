library(devtools)
load_all()
##check()
library(dplyr)


test <- create_corpus("/Users/user/Documents/PAN AV Competition Corpus")

test

#### GETTING THE DATA FOR 2020 ####

test_20 <- get_file_details("/Users/user/Documents/PAN AV Competition Corpus")

test_20 <- test_20 |>
  dplyr::filter(test_20$competition == 'pan20', large == FALSE) |>
  dplyr::arrange(large, category, truth)

test_20$text <- sapply(test_20$file, read_files)

test_20 <- test_20 |> dplyr::as_tibble() |>
  dplyr::select(ncol(test_20)) |>
  dplyr::pull() |>
  unname()

if(length(test_20) == 6){
  pan20_large <- test_20[[5]] %>%
    left_join(test_20[[6]],
              by = 'id')
}

pan20_test <- test_20[[1]] |>
  dplyr::left_join(test_20[[2]],
                   by = 'id')

pan20_train <- test_20[[3]] |>
  dplyr::left_join(test_20[[4]],
                   by = 'id')


pan20_train |> dplyr::as_tibble()

pan20_test |> dplyr::as_tibble()
