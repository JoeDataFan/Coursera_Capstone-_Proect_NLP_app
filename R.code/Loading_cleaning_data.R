# clear environment
rm(list = ls())


# Libraries----
library(tidyverse)
library(forcats)
library(readr)
library(scales)
library(tidytext)
library(stringr)
library(purrr)
library(quanteda)
library(tm)
library(hunspell)
library(pacman)
p_load("cld2")
p_load("cld3")
library(knitr)


# Themes----


# Fucntions-----
getwd()

# Load data----
# download and unzip data folder
if(!dir.exists("../data/Coursera-SwiftKey/")){
    file.url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    temp <- tempfile()
    download.file(file.url, temp, mode = "wb")
    unzip(temp, exdir = "../data/Coursera-SwiftKey")
    rm(temp)
}


# Load then sample a portion of data then save to file
sample.size <- 0.05 # proportion of orignal text data to save to file

# load en_US.blogs.txt----
if(file.exists("../data/temp.data/data.blogs.txt")){
    sample.blogs <- read_tsv("../data/temp.data/data.blogs.txt")
} else {
    data.raw.blogs <- readLines("../data/Coursera-SwiftKey/final/en_US/en_US.blogs.txt",
                                skipNul = TRUE,
                                encoding="UTF-8")
    # create a sample
    sample.blogs <- sample(data.raw.blogs,
                           size = sample.size * length(data.raw.blogs),
                           replace = FALSE)
    # write the sample to txt file in "output"
    writeLines(sample.blogs,
               "../data/temp.data/sample.blogs.txt")
}

# load en_US.news.txt----
if(file.exists("../data/temp.data/data.news.txt")){
    sample.news <- read_tsv("../data/temp.data/data.news.txt")
} else {
    data.raw.news <- readLines(con = file("../data/Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"),
                               skipNul = TRUE)
    # create a sample
    sample.news <- sample(data.raw.news,
                          size = sample.size * length(data.raw.news),
                          replace = FALSE)
    # write the sample to txt file in "output"
    writeLines(sample.news,
               "../data/temp.data/sample.news.txt")
}

# load en_US.twitter.txt----
if(file.exists("../data/temp.data/data.twitter.txt")){
    sample.twitter <- read_tsv("../data/temp.data/data.twitter.txt")
} else {
    data.raw.twitter <- readLines("../data/Coursera-SwiftKey/final/en_US/en_US.twitter.txt",
                                  skipNul = TRUE,
                                  encoding="UTF-8")
    # create a sample
    sample.twitter <- sample(data.raw.twitter,
                             size = sample.size * length(data.raw.twitter),
                             replace = FALSE)
    # write the sample to txt file in "output"
    writeLines(sample.twitter,
               "../data/temp.data/sample.twitter.txt")
}

# Add line variable to data----
data.blogs <- tibble(line = 1:length(sample.blogs),
                     txt_sample = sample.blogs)
data.news <- tibble(line = 1:length(sample.news),
                    txt_sample = sample.news)
data.twitter <- tibble(line = 1:length(sample.twitter),
                       txt_sample = sample.twitter)


# Tokenize data ----
# list of data frames to manipulate
data.list <- list(data.blogs, data.news, data.twitter)

# list of names for tokenized to words data frames
sources <- c("blogs", "news", "twitter")

## Tokenize to individual words
#unigram_tokens <- function(x, y){
#    df <- unnest_tokens(tbl = x,
#                        output = words,
#                        input = txt_sample,
#                        token = "words",
#                        to_lower = TRUE)
#    df.names <- paste("data.unigram", y, sep = ".")
#    assign(df.names, df, envir = .GlobalEnv)
#    }
#
#map2(.x = data.list, .y = sources, .f = unigram_tokens)
#
#
## Tokenize to two word groups
#bigram_tokens <- function(x, y){
#    df <- unnest_tokens(tbl = x,
#                        output = words,
#                        input = txt_sample,
#                        token = "ngrams",
#                        n = 2,
#                        to_lower = TRUE)
#    df.names <- paste("data.bigram", y, sep = ".")
#    assign(df.names, df, envir = .GlobalEnv)
#    }
#
#map2(.x = data.list, .y = sources, .f = bigram_tokens)
#
## Tokenize to three word groups
#trigram_tokens <- function(x, y){
#    df <- unnest_tokens(tbl = x,
#                        output = words,
#                        input = txt_sample,
#                        token = "ngrams",
#                        n = 3,
#                        to_lower = TRUE)
#    df.names <- paste("data.trigram", y, sep = ".")
#    assign(df.names, df, envir = .GlobalEnv)
#    }
#
#map2(.x = data.list, .y = sources, .f = trigram_tokens)
