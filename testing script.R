library(devtools)
load_all()
check()
library(dplyr)

test <- get_file_details("/Users/user/Documents/PAN AV Competition Corpus")

test

test_read <- test %>%
  filter(competition == "pan21")

test_read$text <- sapply(test_read$file, read_files)
test_read

unique(test$file_type)

test_sample$text <- sapply(test_sample$file, read_txt)


test_corpus <- quanteda::corpus(test_sample,
                                text_field = "text")

summary(test_corpus, 5)
