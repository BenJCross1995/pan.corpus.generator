library(dplyr)

test <- get_file_details("/Users/user/Documents/PAN AV Competition Corpus")

test_sample <- test[sample(nrow(test), 25),] %>%
  mutate(data_type = ifelse(stringr::str_count(file, "train") >
                              stringr::str_count(file, "test"),
                            "train", "test"))

test_read <- test

test_read$text <- sapply(test_read$file, read_files)
unique(test$file_type)

test_sample$text <- sapply(test_sample$file, read_txt)


test_corpus <- quanteda::corpus(test_sample,
                                text_field = "text")

summary(test_corpus, 5)
