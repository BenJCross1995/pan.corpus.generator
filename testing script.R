library(devtools)
load_all()
##check()
library(dplyr)


test <- create_corpus("/Users/user/Documents/PAN AV Competition Corpus")

unique(test$competition)

test |> dplyr::as_tibble() |> dplyr::pull(text) |> unname()
test |> dplyr::as_tibble() |> dplyr::select(text) |> pull()

#### GETTING THE DATA FOR 2021 ####
test_21_loc <- "/Users/user/Documents/PAN AV Competition Corpus/2021/pan21-authorship-verification-test"

test_21 <- create_corpus(test_21_loc)

test_21 <- test_21 %>%
  arrange(truth) %>%
  pull(text) %>%
  unname()


test_21 <- test_21[[1]] %>%
  left_join(test_21[[2]],
            by = 'id')

test_21

#### GETTING THE DATA FOR 2020 ####
test %>%
  filter(competition == 'pan20') %>%
  arrange(truth)

test_20 <- create_corpus("/Users/user/Documents/PAN AV Competition Corpus/2020")
stringr::str
stringr::str
library(stringr)
str_detect(unique(test$competition), "pan21")
