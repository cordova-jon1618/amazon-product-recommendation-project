# CSUN Comp 541-3 Data Mining 
# Project 1
#
# Authors: Jonathan Cordova and Jesse Carrillo
################################################################
# Libraries (uncomment to install)
################################################################
# Used for all of the data cleaning
#install.packages("tidyverse")
library(tidyverse)

# Library for visualization
library(ggplot2)

#install.packages("GGally")
library(GGally)

# install package for sentiment analysis
# install.packages("SentimentAnalysis")
library(SentimentAnalysis)

# for text processing
# install.packages("SnowballC")
library(SnowballC)

################################################################
# Product Categories
################################################################
# Keeps track of which categories are relevant based on the type
allowed_categories <- vector()

# Overall categories that have been scraped
book_categories <- c("books", "digital-text", "comics-manga", "audible","audiobooks","ebooks") # Some of these are human readable forms
beauty_categories <- c("beauty")
office_categories <- c("furniture","office-products")
home_categories <- c("kitchen")
electronics_categories <- c("videogames","electronics","vdo-devices-store","hi","pc","apple-devices","aht", "amazon-home", "wireless-prepaid","amazon-smp","hpc")
amazon_categories <- c("amazon-smp","amazon-home")
sporting_goods_categories <- c("sporting-goods")
subscription_categories <- c("subscribe-with-amazon","local-services", "digital-skills")

################################################################
# Data Integration (combining all of the scraped data)
###############################################################
### Books Category###

# Get the current working directory
print(getwd())

# Change the working directory
#setwd("<Path here if needed>")

### Books ###############
# Specify the file path to your CSV file and read it into data
file_path <- "./amazon_book_data_04012024.csv"
book_data <- read.csv(file_path)
allowed_categories <- append(allowed_categories, book_categories)

file_path <- "./amazon_data_test_run_03312024.csv"
book_data_two <- read.csv(file_path)

loaded_book_data <- bind_rows(book_data, book_data_two)

### Office Equipment #####
file_path <- "amazon_officechair_data_0401202.csv"
office_data <- read.csv(file_path)

file_path <- "amazon_officechair_data_part2_0402202.csv"
office_data_two <- read.csv(file_path)

allowed_categories <- append(allowed_categories, office_categories)
loaded_office_data <- bind_rows(office_data, office_data_two)

## Combine all of the data ##
data <- bind_rows(loaded_book_data, loaded_office_data)

### Electronics Category ###############
#file_path <- "./electronics.csv"
#electronic_data <- read.csv(file_path)
#allowed_categories <- append(allowed_categories, electronics_categories)

#data <- bind_rows(book_data,new_data)#, electronic_data)

###############################################################
# Remove Incomplete Data and Split the data into 5 entries
###############################################################
processed_data_one <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody1, ReviewRating1, ProductCategory, ReviewAuthor1) %>%  

  # filter out any data that is incomplete for later use
  filter(complete.cases(.)) %>%
  
  
  # filter out any stray ratings and prices that are incomplete
  filter(AverageRating != "" & ProductPrice != "") %>%
  
  # Rename the ReviewBody1 column to ReviewBody
  mutate(ReviewBody = ReviewBody1) %>%
  select(-ReviewBody1) %>%
  
  # Rename the ReviewRating1 column to ReviewRating
  mutate(ReviewRating = ReviewRating1) %>%
  select(-ReviewRating1) %>% 
  
  # Rename the ReviewAuthor1 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor1) %>%
  select(-ReviewAuthor1) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)


processed_data_two <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody2, ReviewRating2, ProductCategory, ReviewAuthor2) %>%  
  
  # filter out any data that is incomplete for later use
  filter(complete.cases(.)) %>%
  
  
  # filter out any stray ratings and prices that are incomplete
  filter(AverageRating != "" & ProductPrice != "") %>%
  
  # Rename the ReviewBody4 column to ReviewBody
  mutate(ReviewBody = ReviewBody2) %>%
  select(-ReviewBody2) %>%
  
  # Rename the ReviewRating4 column to ReviewRating
  mutate(ReviewRating = ReviewRating2) %>%
  select(-ReviewRating2) %>% 
  
  # Rename the ReviewAuthor4 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor2) %>%
  select(-ReviewAuthor2) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)


processed_data_three <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody3, ReviewRating3, ProductCategory, ReviewAuthor3) %>%  
  
  # filter out any data that is incomplete for later use
  filter(complete.cases(.)) %>%
  
  
  # filter out any stray ratings and prices that are incomplete
  filter(AverageRating != "" & ProductPrice != "") %>%
  
  # Rename the ReviewBody4 column to ReviewBody
  mutate(ReviewBody = ReviewBody3) %>%
  select(-ReviewBody3) %>%
  
  # Rename the ReviewRating4 column to ReviewRating
  mutate(ReviewRating = ReviewRating3) %>%
  select(-ReviewRating3) %>% 
  
  # Rename the ReviewAuthor4 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor3) %>%
  select(-ReviewAuthor3) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)


processed_data_four <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody4, ReviewRating4, ProductCategory, ReviewAuthor4) %>%  
  
  # filter out any data that is incomplete for later use
  filter(complete.cases(.)) %>%
  
  # filter out any stray ratings and prices that are incomplete
  filter(AverageRating != "" & ProductPrice != "") %>%
  
  # Rename the ReviewBody4 column to ReviewBody
  mutate(ReviewBody = ReviewBody4) %>%
  select(-ReviewBody4) %>%
  
  # Rename the ReviewRating4 column to ReviewRating
  mutate(ReviewRating = ReviewRating4) %>%
  select(-ReviewRating4) %>% 
  
  # Rename the ReviewAuthor4 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor4) %>%
  select(-ReviewAuthor4) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)
  
  
processed_data_five <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody5, ReviewRating5, ProductCategory, ReviewAuthor5) %>%  
  
  # filter out any data that is incomplete for later use
  filter(complete.cases(.)) %>%
  
  
  # filter out any stray ratings and prices that are incomplete
  filter(AverageRating != "" & ProductPrice != "") %>%
  
  # Rename the ReviewBody4 column to ReviewBody
  mutate(ReviewBody = ReviewBody5) %>%
  select(-ReviewBody5) %>%
  
  # Rename the ReviewRating4 column to ReviewRating
  mutate(ReviewRating = ReviewRating5) %>%
  select(-ReviewRating5) %>% 
  
  # Rename the ReviewAuthor4 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor5) %>%
  select(-ReviewAuthor5) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

# Combine Processed Data
processed_data <- bind_rows(processed_data_one, processed_data_two)
processed_data <- bind_rows(processed_data, processed_data_three)
processed_data <- bind_rows(processed_data, processed_data_four)
processed_data <- bind_rows(processed_data, processed_data_five)


###############################################################
# Storing Incomplete but usable Data (and splitting entries into five)
###############################################################
processed_incomplete_data_one <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody1, ReviewRating1, ProductCategory, ReviewAuthor1) %>%  
  
  filter(!complete.cases(.)) %>%
  
  # filter out prices that are incomplete and have an averagerating
  filter(!is.na(AverageRating) & AverageRating != "" & is.na(ProductPrice)) %>%
  
  # Rename the ReviewBody1 column to ReviewBody
  mutate(ReviewBody = ReviewBody1) %>%
  select(-ReviewBody1) %>%
  
  # Rename the ReviewRating1 column to ReviewRating
  mutate(ReviewRating = ReviewRating1) %>%
  select(-ReviewRating1) %>% 
  
  # Rename the ReviewAuthor1 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor1) %>%
  select(-ReviewAuthor1) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

processed_incomplete_data_two <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody2, ReviewRating2, ProductCategory, ReviewAuthor2) %>%  
  
  filter(!complete.cases(.)) %>%
  
  # filter out prices that are incomplete and have an averagerating
  filter(!is.na(AverageRating) & AverageRating != "" & is.na(ProductPrice)) %>%
  
  # Rename the ReviewBody1 column to ReviewBody
  mutate(ReviewBody = ReviewBody2) %>%
  select(-ReviewBody2) %>%
  
  # Rename the ReviewRating1 column to ReviewRating
  mutate(ReviewRating = ReviewRating2) %>%
  select(-ReviewRating2) %>% 
  
  # Rename the ReviewAuthor1 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor2) %>%
  select(-ReviewAuthor2) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

processed_incomplete_data_three <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody3, ReviewRating3, ProductCategory, ReviewAuthor3) %>%  
  
  filter(!complete.cases(.)) %>%
  
  # filter out prices that are incomplete and have an averagerating
  filter(!is.na(AverageRating) & AverageRating != "" & is.na(ProductPrice)) %>%
  
  # Rename the ReviewBody1 column to ReviewBody
  mutate(ReviewBody = ReviewBody3) %>%
  select(-ReviewBody3) %>%
  
  # Rename the ReviewRating1 column to ReviewRating
  mutate(ReviewRating = ReviewRating3) %>%
  select(-ReviewRating3) %>% 
  
  # Rename the ReviewAuthor1 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor3) %>%
  select(-ReviewAuthor3) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

processed_incomplete_data_four <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody4, ReviewRating4, ProductCategory, ReviewAuthor4) %>%  
  
  filter(!complete.cases(.)) %>%
  
  # filter out prices that are incomplete and have an averagerating
  filter(!is.na(AverageRating) & AverageRating != "" & is.na(ProductPrice)) %>%
  
  # Rename the ReviewBody1 column to ReviewBody
  mutate(ReviewBody = ReviewBody4) %>%
  select(-ReviewBody4) %>%
  
  # Rename the ReviewRating1 column to ReviewRating
  mutate(ReviewRating = ReviewRating4) %>%
  select(-ReviewRating4) %>% 
  
  # Rename the ReviewAuthor1 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor4) %>%
  select(-ReviewAuthor4) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

processed_incomplete_data_five <- data %>% 
  # Select the columns that we will be looking at
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody5, ReviewRating5, ProductCategory, ReviewAuthor5) %>%  
  
  filter(!complete.cases(.)) %>%
  
  # filter out prices that are incomplete and have an averagerating
  filter(!is.na(AverageRating) & AverageRating != "" & is.na(ProductPrice)) %>%
  
  # Rename the ReviewBody1 column to ReviewBody
  mutate(ReviewBody = ReviewBody5) %>%
  select(-ReviewBody5) %>%
  
  # Rename the ReviewRating1 column to ReviewRating
  mutate(ReviewRating = ReviewRating5) %>%
  select(-ReviewRating5) %>% 
  
  # Rename the ReviewAuthor1 column to ReviewAuthor
  mutate(ReviewAuthor = ReviewAuthor5) %>%
  select(-ReviewAuthor5) %>%
  
  select(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

# Combine Processed Incomplete Data
processed_incomplete_data <- bind_rows(processed_incomplete_data_one, processed_incomplete_data_two)
processed_incomplete_data <- bind_rows(processed_incomplete_data, processed_incomplete_data_three)
processed_incomplete_data <- bind_rows(processed_incomplete_data, processed_incomplete_data_four)
processed_incomplete_data <- bind_rows(processed_incomplete_data, processed_incomplete_data_five)

unique(processed_data$ProductCategory)
unique(processed_incomplete_data$ProductCategory)

###############################################################
# Clean Data
###############################################################
## Change Average Rating to double and trim text
processed_data$AverageRating <- sapply(strsplit(processed_data$AverageRating, " out of 5"), function(x) as.numeric(x[1]))
processed_incomplete_data$AverageRating <- sapply(strsplit(processed_incomplete_data$AverageRating, " out of 5"), function(x) as.numeric(x[1]))

## Change User's ReviewRating to double
processed_data$ReviewRating <- as.double(processed_data$ReviewRating) 
processed_incomplete_data$ReviewRating <- as.double(processed_incomplete_data$ReviewRating) 

## Change ProductPrice to double and remove $ text
processed_data$ProductPrice <- as.numeric(gsub("\\$", "", processed_data$ProductPrice))
processed_incomplete_data$ProductPrice <- as.numeric(gsub("\\$", "", processed_incomplete_data$ProductPrice))

## Remove products from categories that are not relevant
processed_data <- processed_data %>% 
  filter(ProductCategory %in% allowed_categories)

## Remove products from irrelevant categories from incomplete data
processed_incomplete_data <- processed_incomplete_data %>% 
  filter(ProductCategory %in% allowed_categories)

## Fill in missing data in incomplete data
processed_incomplete_data <- processed_incomplete_data %>%
  # When there is no User rating, replace with average rating
  mutate(ReviewRating = case_when(is.na(ReviewRating) | ReviewRating == "" ~ AverageRating, TRUE ~ ReviewRating)) %>% 
  mutate(ReviewAuthor = replace(ReviewAuthor, is.na(ReviewAuthor) | ReviewAuthor == "", "None"))

# Remove duplicate format reviews for complete data
processed_data <- processed_data %>% 
  distinct(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

# Remove duplicate format reviews for incomplete data
processed_incomplete_data <- processed_incomplete_data %>% 
  distinct(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor)

# Get the average price from the complete data to use for incomplete data
processed_ProductPrice <- mean(processed_data$ProductPrice)
processed_ProductPrice <- round(processed_ProductPrice, 2)

# Remove commas and the word "ratings", then convert to numeric
processed_data$NumberOfRatings <- as.numeric(gsub(",", "", gsub(" ratings", "", processed_data$NumberOfRatings)))

processed_incomplete_data$NumberOfRatings <- as.numeric(gsub(",", "", gsub(" ratings", "", processed_incomplete_data$NumberOfRatings)))

###############################################################
# Sentiment Analysis
###############################################################

# Add a unique row identifier to processed_data
processed_data = processed_data %>% 
  mutate(unique_id = row_number())

processed_incomplete_data = processed_incomplete_data %>% 
  mutate(unique_id_2 = row_number())

# Perform the filtering and sentiment analysis
# Filter out NA values in ReviewBody before sentiment analysis
non_na_reviews = processed_data %>%
  filter(!is.na(ReviewBody))

non_na_reviews_incomplete_data = processed_incomplete_data %>%
  filter(!is.na(ReviewBody))


# Perform sentiment analysis on non-NA ReviewBody entries
sentiment_results = analyzeSentiment(non_na_reviews$ReviewBody)

sentiment_results_incomplete_data = analyzeSentiment(non_na_reviews_incomplete_data$ReviewBody)

# Add the sentiment scores back to non_na_reviews
non_na_reviews$SentimentScore = sentiment_results$SentimentQDAP

non_na_reviews_incomplete_data$SentimentScore = sentiment_results_incomplete_data$SentimentQDAP

# Merge the sentiment scores back into processed_data using the unique identifier
processed_data = left_join(processed_data, non_na_reviews %>% 
                             select(unique_id, SentimentScore),
                           by = 'unique_id')


# Merge the sentiment scores back into processed_data using the unique identifier
processed_incomplete_data = left_join(processed_incomplete_data, non_na_reviews_incomplete_data %>% 
                             select(unique_id_2, SentimentScore),
                           by = 'unique_id_2')


#Add sentiment category based on SentimentScore
processed_data = processed_data %>%
  mutate(SentimentCategory = case_when(
    SentimentScore > 0  ~ "Positive",
    SentimentScore == 0 ~ "Neutral",
    SentimentScore < 0  ~ "Negative",
    TRUE                ~ "Unknown" # Handles NA or any other case not covered
  ))

processed_incomplete_data = processed_incomplete_data %>%
  mutate(SentimentCategory = case_when(
    SentimentScore > 0  ~ "Positive",
    SentimentScore == 0 ~ "Neutral",
    SentimentScore < 0  ~ "Negative",
    TRUE                ~ "Unknown" # Handles NA or any other case not covered
  ))


# remove the temporary 'unique_id' and 'unique_id_2' column if you no longer need it
processed_data = processed_data %>%
  select(-unique_id)

processed_incomplete_data = processed_incomplete_data %>%
  select(-unique_id_2)

print(names(processed_data))
print(names(processed_incomplete_data))

###############################################################
# Use Imputation to estimate price of incomplete data
###############################################################
# Get averageprice for items in category and put them into incomplete's ProductPrice
processed_incomplete_data <- processed_incomplete_data %>% 
  mutate(ProductPrice = ifelse(is.na(ProductPrice) | ProductPrice == "", processed_ProductPrice, ProductPrice))

###############################################################
# Combine all data together into new final data
###############################################################
# Combine complete and incomplete data and store as new dataset
final_data <- bind_rows(processed_data, processed_incomplete_data)

# Remove duplicate format reviews for complete data
final_data <- final_data %>% 
  distinct(ProductName, ProductPrice, AverageRating, NumberOfRatings, ReviewBody, ReviewRating, ProductCategory, ReviewAuthor, SentimentScore, SentimentCategory)

  # Remove duplicate reviews of the same item that are from the same person but at a cheaper price. 
  #group_by(ProductName) %>%
  #filter(ProductPrice == min(ProductPrice)) %>%
  #ungroup() #%>% 

# Get the Average Rating for all of the products
Final_AverageRating <- mean(final_data$AverageRating)
Final_AverageRating <- round(Final_AverageRating, 2)

# Get the average price from the final data to use for visualization
Final_Average_ProductPrice <- mean(final_data$ProductPrice)
Final_Average_ProductPrice <- round(Final_Average_ProductPrice, 2)

print(names(final_data))
colnames(final_data)

# Saving the final data to a CSV file
write.csv(final_data, "results_with_sentiment_analysis.csv", row.names = FALSE)

## Make the categories more human readable ##################
final_data$ProductCategory <- ifelse(final_data$ProductCategory == "audible", "audiobooks", final_data$ProductCategory)
final_data$ProductCategory <- ifelse(final_data$ProductCategory == "digital-text", "ebooks", final_data$ProductCategory)

## Split graphs by category ################################
Book_Graph_Data <- final_data[final_data$ProductCategory %in% book_categories, ]
Office_Graph_Data <- final_data[final_data$ProductCategory %in% office_categories, ]

## Remove leftover unused categories #######################
readable_data <- final_data[, !names(final_data) %in% "NumberOfRatings"]
write.csv(readable_data, "Readable_Results.csv", row.names = FALSE)


###############################################################
# Get total number of unique items
###############################################################
unique_count <- processed_data %>%
  distinct(ProductName) %>%
  nrow()

cat("Total number of unique products is:", unique_count, "\n")

unique(final_data$ProductCategory)

###############################################################
# Visualization
###############################################################

# Triple Scatterplot for ProductPrice, AverageRating and ReviewRating
pairs(final_data[, c("ProductPrice", "AverageRating", "ReviewRating")])

# Histogram for ProductPrice
ggplot(data = final_data, aes(x = ProductPrice)) +
  geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
  labs(x = "Price", y = "Frequency", title = "Distribution of Prices")

# Histogram by category
ggplot(data = Book_Graph_Data, aes(x = ProductPrice)) +
  geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
  labs(x = "Price", y = "Frequency", title = "Distribution of Prices for Books")

ggplot(data = Office_Graph_Data, aes(x = ProductPrice)) +
  geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
  labs(x = "Price", y = "Frequency", title = "Distribution of Prices for Office Equipment")

# Box Plot for Product Price
ggplot(data = final_data, aes(x = "", y = ProductPrice)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  labs(x = "", y = "Price", title = "Box Plot of Prices")

# Box Plot for Product Price
ggplot(data = Book_Graph_Data, aes(x = "", y = ProductPrice)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  labs(x = "", y = "Price", title = "Box Plot of Prices for Books")

# Box Plot for Product Price
ggplot(data = Office_Graph_Data, aes(x = "", y = ProductPrice)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  labs(x = "", y = "Price", title = "Box Plot of Prices for Office Equipment")

ggplot(data = final_data, aes(x = ProductPrice, y = AverageRating)) +
  geom_point(color = "blue") +
  labs(x = "Price", y = "Average Rating", title = "Price vs. Average Rating")

ggplot(data = final_data, aes(x = ProductPrice, y = ReviewRating)) +
  geom_point(color = "blue") +
  labs(x = "Price", y = "Average Rating", title = "Price vs. Review Rating")

# Correlation - Correlograms
ggpairs(final_data[, c("ProductPrice", "AverageRating", "ReviewRating")])

ggpairs(Book_Graph_Data[, c("ProductPrice", "AverageRating", "ReviewRating")])+
  ggtitle("Product Price, Average Rating, and Review Rating for Items in Book Categories")

ggpairs(Office_Graph_Data[, c("ProductPrice", "AverageRating", "ReviewRating")])+
  ggtitle("Product Price, Average Rating, and Review Rating for Items in Office Categories")

# Plot by category
ggplot(data=Book_Graph_Data, aes(ProductPrice, AverageRating,colour=ProductCategory)) + 
  geom_point()+
  ggtitle("Product Price and Average Rating for Books")

ggplot(data=Office_Graph_Data, aes(ProductPrice, AverageRating,colour=ProductCategory)) + 
  geom_point()+
  ggtitle("Product Price and Average Rating for Office")

# Plot showing prices
plot(final_data$ProductPrice,final_data$AverageRating)
plot(final_data$ProductPrice,final_data$ReviewRating)
plot(final_data$AverageRating, final_data$ReviewRating)


ggplot(data=final_data, aes(ProductPrice, AverageRating,colour=ProductCategory)) + 
  geom_point()

ggplot(data=final_data, aes(ProductPrice, ReviewRating,colour=ProductCategory)) + 
  geom_point()

###############################################################
# Visualization for Sentiment Analysis
###############################################################
#install.packages("wordcloud")

library(wordcloud)
library(tm)

#########################
# Positive WordCloud
#########################
# Filter reviews for positive sentiment
positive_reviews = tolower(paste(final_data$ReviewBody[final_data$SentimentCategory == "Positive"], collapse = " "))

# Create a corpus and clean it
positive_corpus = Corpus(VectorSource(positive_reviews))
positive_corpus = tm_map(positive_corpus, content_transformer(tolower))
positive_corpus = tm_map(positive_corpus, removePunctuation)
positive_corpus = tm_map(positive_corpus, removeNumbers)
positive_corpus = tm_map(positive_corpus, removeWords, stopwords("en"))

# Generate the word cloud for positive sentiments
wordcloud(words = positive_corpus, scale = c(5, 0.5), max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
title("Positive Wordcloud")

## Filtered by category
# Filter reviews for positive sentiment
positive_reviews = tolower(paste(Book_Graph_Data$ReviewBody[Book_Graph_Data$SentimentCategory == "Positive"], collapse = " "))

# Create a corpus and clean it
positive_corpus = Corpus(VectorSource(positive_reviews))
positive_corpus = tm_map(positive_corpus, content_transformer(tolower))
positive_corpus = tm_map(positive_corpus, removePunctuation)
positive_corpus = tm_map(positive_corpus, removeNumbers)
positive_corpus = tm_map(positive_corpus, removeWords, stopwords("en"))

# Generate the word cloud for positive sentiments
wordcloud(words = positive_corpus, scale = c(5, 0.5), max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
title("Positive Wordcloud")

# Filter reviews for positive sentiment
positive_reviews = tolower(paste(Office_Graph_Data$ReviewBody[Office_Graph_Data$SentimentCategory == "Positive"], collapse = " "))

# Create a corpus and clean it
positive_corpus = Corpus(VectorSource(positive_reviews))
positive_corpus = tm_map(positive_corpus, content_transformer(tolower))
positive_corpus = tm_map(positive_corpus, removePunctuation)
positive_corpus = tm_map(positive_corpus, removeNumbers)
positive_corpus = tm_map(positive_corpus, removeWords, stopwords("en"))

# Generate the word cloud for positive sentiments
wordcloud(words = positive_corpus, scale = c(5, 0.5), max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
title("Positive Wordcloud for Office Category")


#########################
# Negative WordCloud
#########################
# Filter reviews for negative sentiment
negative_reviews = tolower(paste(final_data$ReviewBody[final_data$SentimentCategory == "Negative"], collapse = " "))

# Create a corpus and clean it
negative_corpus = Corpus(VectorSource(negative_reviews))
negative_corpus = tm_map(negative_corpus, content_transformer(tolower))
negative_corpus = tm_map(negative_corpus, removePunctuation)
negative_corpus = tm_map(negative_corpus, removeNumbers)
negative_corpus = tm_map(negative_corpus, removeWords, stopwords("en"))

# Generate the word cloud for negative sentiments
wordcloud(words = negative_corpus, scale = c(5, 0.5), max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Spectral"))
title("Negative Wordcloud")

## Wordclouds by Category ######################
# Books ###
negative_reviews = tolower(paste(Book_Graph_Data$ReviewBody[Book_Graph_Data$SentimentCategory == "Negative"], collapse = " "))

# Create a corpus and clean it
negative_corpus = Corpus(VectorSource(negative_reviews))
negative_corpus = tm_map(negative_corpus, content_transformer(tolower))
negative_corpus = tm_map(negative_corpus, removePunctuation)
negative_corpus = tm_map(negative_corpus, removeNumbers)
negative_corpus = tm_map(negative_corpus, removeWords, stopwords("en"))

# Generate the word cloud for negative sentiments
wordcloud(words = negative_corpus, scale = c(5, 0.5), max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Spectral"))
title("Negative Wordcloud for Books Category")

# Office ###
negative_reviews = tolower(paste(Office_Graph_Data$ReviewBody[Office_Graph_Data$SentimentCategory == "Negative"], collapse = " "))

# Create a corpus and clean it
negative_corpus = Corpus(VectorSource(negative_reviews))
negative_corpus = tm_map(negative_corpus, content_transformer(tolower))
negative_corpus = tm_map(negative_corpus, removePunctuation)
negative_corpus = tm_map(negative_corpus, removeNumbers)
negative_corpus = tm_map(negative_corpus, removeWords, stopwords("en"))

# Generate the word cloud for negative sentiments
wordcloud(words = negative_corpus, scale = c(5, 0.5), max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Spectral"))
title("Negative Wordcloud for Office Category")


#########################
# Neutral WordCloud
#########################
# Filter reviews for neutral sentiment
neutral_reviews = tolower(paste(final_data$ReviewBody[final_data$SentimentCategory == "Neutral"], collapse = " "))

# Create a corpus and clean it
neutral_corpus = Corpus(VectorSource(neutral_reviews))
neutral_corpus = tm_map(neutral_corpus, content_transformer(tolower))
neutral_corpus = tm_map(neutral_corpus, removePunctuation)
neutral_corpus = tm_map(neutral_corpus, removeNumbers)
neutral_corpus = tm_map(neutral_corpus, removeWords, stopwords("en"))

# Generate the word cloud for neutral sentiments
wordcloud(words = neutral_corpus, scale = c(8, 0.5), max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Spectral"))
title("Neutral Wordcloud", y = 5.25)


#########################
# Visualizing Sentiment Distribution
#########################

ggplot(final_data, aes(x = SentimentCategory)) +
  geom_bar(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Distribution of Sentiment Categories",
       x = "Sentiment Category",
       y = "Count") +
  geom_text(stat='count', aes(label=..count..), vjust=-1)


#########################
# Distribution of Sentiment Scores
#########################
ggplot(final_data, aes(x = SentimentScore)) +
  geom_histogram(binwidth = 0.1, fill = "lightblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Sentiment Scores",
       x = "Sentiment Score",
       y = "Frequency")


#########################
# Scatter Plot Matrix
#########################

ggpairs(final_data[, c("ProductPrice", "AverageRating", "SentimentScore")],
        title = "Scatter Plot Matrix of Price, Average Rating, and Sentiment Score",
        lower = list(continuous = "points"),  # Use points for the lower matrix
        upper = list(continuous = "cor"),     # Use correlation for the upper matrix
        diag = list(continuous = "barDiag")   # Use bar charts for the diagonal
)

## Sentiment by Books
ggpairs(Book_Graph_Data[, c("ProductPrice", "AverageRating", "SentimentScore")],
        title = "Scatter Plot Matrix of Price, Average Rating, and Sentiment Score for Books",
        lower = list(continuous = "points"),  # Use points for the lower matrix
        upper = list(continuous = "cor"),     # Use correlation for the upper matrix
        diag = list(continuous = "barDiag")   # Use bar charts for the diagonal
)

## Sentiment by Office
ggpairs(Office_Graph_Data[, c("ProductPrice", "AverageRating", "SentimentScore")],
        title = "Scatter Plot Matrix of Price, Average Rating, and Sentiment Score for Office",
        lower = list(continuous = "points"),  # Use points for the lower matrix
        upper = list(continuous = "cor"),     # Use correlation for the upper matrix
        diag = list(continuous = "barDiag")   # Use bar charts for the diagonal
)


###################################################################################################################

getwd()
# clearing the current workspace
rm(list = ls())
# clear plot
dev.off()
# clearning console
cat("\014")

rm(data)
cls
