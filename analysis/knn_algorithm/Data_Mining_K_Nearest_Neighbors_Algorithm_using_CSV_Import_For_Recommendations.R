#####################################################################
# California State University Northridge   
# COMP 541 Data Mining
# Spring 2024
# Course Number 16633

# By:
#     Jonathan Cordova and Jesse Carrillo
#
# Amazon Product Recommendation Project
# Using Data Mining to Compare Amazon Ratings to Customer Sentiment
#
#####################################################################

library(tidyverse)

# Import dataset
# data_frame = read.csv("Readable_Results.csv") # Preliminary Data
data_frame = read.csv("Complete_Readable_Results.csv") # All Data

# Columns
names(data_frame)

# Rename the AverageRating attribute as Rating
# The Amazon Webstore refers to their Product Rating as Average Rating among many products
# In our case, we are renaming it to Product Ratings to avoid confusion.
names(data_frame)[names(data_frame) == "AverageRating"] <- "ProductRating"

# Columns
names(data_frame)
# head(data_frame)

# Debugging
################
cat("The data has", nrow(data_frame), "rows and", ncol(data_frame), "columns.\n")

#####################################################################
# Preparing the Training Data for KNN
#####################################################################

# Calculate the mean and percentiles for ProductPrice, 
# Mean and 50th percentile represent same 
mean_price = mean(data_frame$ProductPrice, na.rm = TRUE)
price_50th = quantile(data_frame$ProductPrice, probs = 0.50, na.rm = TRUE)

# Calculating the Mean and 75th percentile for ProductRating
mean_rating = mean(data_frame$ProductRating, na.rm = TRUE)
rating_75th = quantile(data_frame$ProductRating, probs = 0.75, na.rm = TRUE)

# Calculating the Mean and 75th percentile for ReviewRating
mean_review = mean(data_frame$ReviewRating, na.rm = TRUE)
review_75th = quantile(data_frame$ReviewRating, probs = 0.75, na.rm = TRUE)

# Calculating the Mean and 75th percentile for SentimentScore
mean_sentiment = mean(data_frame$SentimentScore, na.rm = TRUE)
sentiment_75th = quantile(data_frame$SentimentScore, probs = 0.75, na.rm = TRUE)

# Adding the Target column
data_frame = data_frame %>%
  mutate(Target = ifelse(!is.na(ProductPrice) & ProductPrice <= price_50th &
                           !is.na(ProductRating) & ProductRating >= rating_75th &
                           !is.na(ReviewRating) & ReviewRating >= review_75th &
                           !is.na(SentimentScore) & SentimentScore >= sentiment_75th, 1, 0))

# Select relevant columns
data_selected = data_frame[, c("ProductPrice", "ProductRating", "ReviewRating", "SentimentScore", "Target")]

# Scale the data (excluding the Target column)
data_scaled = scale(data_selected[, -5])  # Target is the fifth column

# head(data_scaled)
# tail(data_scaled)
# head(data_selected)
# tail(data_selected)

# Count the number of 0s and 1s in the Target column
target_counts = table(data_selected$Target)

# Print the counts
print(target_counts)

# Debugging
################
cat("The data has", nrow(data_scaled), "rows and", ncol(data_scaled), "columns.\n")

#####################################################################
# Preparing the Training, Testing, Validation Datasets
#####################################################################
library(caret)
library(class)

# Check the first few rows of the dataframe
head(data_selected)

# Splitting data into 80% training and 10% validation and 10% testing
set.seed(123)  # Using a seed for reproducibility
training_indices = createDataPartition(data_selected$Target, p = 0.8, list = FALSE)
train_data = data_scaled[training_indices, ]
train_target = data_selected$Target[training_indices]

# For 10% validation (evaluation) and 10% testing
remaining_data = data_scaled[-training_indices, ]
remaining_target = data_selected$Target[-training_indices]

# Splitting the remaining 20% data into 50% validation and 50% testing 
# (10% of total each)
remaining_indices = createDataPartition(remaining_target, p = 0.5, list = FALSE)

# 10% validation
validation_data = remaining_data[remaining_indices, ]
validation_target = remaining_target[remaining_indices]

# 10% testing
test_data = remaining_data[-remaining_indices, ]
test_target = remaining_target[-remaining_indices]

# Filters the records no missing attributes fell through
# in the training, validation, and test datasets
# Filter records with no missing attributes in the training dataset
complete_train_indices = complete.cases(train_data)
filtered_train_data = train_data[complete_train_indices, ]

# number of dropped records due to missing attributes
original_train_count = nrow(train_data)
complete_train_count = sum(complete_train_indices)
dropped_train_records = original_train_count - complete_train_count

train_data = train_data[complete_train_indices, ]
train_target = train_target[complete_train_indices]

complete_validation_indices = complete.cases(validation_data)
validation_data = validation_data[complete_validation_indices, ]
validation_target = validation_target[complete_validation_indices]

complete_test_indices = complete.cases(test_data)
test_data = test_data[complete_test_indices, ]
test_target = test_target[complete_test_indices]

# Debugging
################
cat("The data has", nrow(data_selected), "rows and", ncol(data_selected), "columns.\n")
cat("The number of dropped records", dropped_train_records, "\n")
cat("The training data has", nrow(train_data), "rows and", ncol(train_data), "columns.\n")
cat("The validation data has", nrow(validation_data), "rows and", ncol(validation_data), "columns.\n")
cat("The testing data has", nrow(test_data), "rows and", ncol(test_data), "columns.\n")


#####################################################################
# Training Phase
#####################################################################

####################################################
# Finding the best K for K-Nearest Neighbor
# Experimental Approach as recommended in Lecture 6
####################################################

# To find the best K.
k_values = 1:10
error_rates = numeric(length(k_values))  # Storing error rates for each k

# Training 10 KNN models on different K values to identify the best value
# between 1 through 10
for (i in seq_along(k_values)) {
  k = k_values[i]
  
  # Train the KNN model
  knn_model = knn(train = train_data, test = validation_data, cl = train_target, k = k)
  
  # Calculating true positives, true negatives, false positives, and false negatives
  true_positives <- sum(knn_model == 0 & validation_target == 0)
  true_negatives <- sum(knn_model == 1 & validation_target == 1)
  false_positives <- sum(knn_model == 0 & validation_target == 1)
  false_negatives <- sum(knn_model == 1 & validation_target == 0)
  
  # Calculating Error Rate
  error_rate = (false_positives + false_negatives) / (sum(validation_target == 0) 
                                                      + sum(validation_target == 1))
  error_rates[i] = error_rate
  
  print(paste("Checking k =", k, "Error Rate:", error_rate))
}

# Identify the best k using the lowest error rate
best_k = k_values[which.min(error_rates)]
best_error_rate = min(error_rates)
print(paste("Best k: ", best_k, "with an Error Rate of: ", best_error_rate))


#####################################################################
# Evaluation 
#####################################################################

# Debugging
################
cat("The training data has", nrow(train_data), "rows and", ncol(train_data), "columns.\n")
cat("The validation data has", nrow(validation_data), "rows and", ncol(validation_data), "columns.\n")
cat("The testing data has", nrow(test_data), "rows and", ncol(test_data), "columns.\n")

# Train the KNN model using the training data
final_knn_model = knn(train = train_data, test = train_data, cl = train_target, k = best_k)

# Predict on the validation data using the trained model
# Note: Because KNN is a lazy learner algorithm the training dataset must be provided
predictions = knn(train = train_data, test = validation_data, cl = train_target, k = best_k)

eval_true_positives = 0
eval_true_negatives = 0
eval_false_positives = 0
eval_false_negatives = 0

# Iterate over each pair of elements in predictions and validation_target
for (i in seq_along(predictions)) {
  if (predictions[i] == 0 & validation_target[i] == 0) {
    eval_true_positives = eval_true_positives + 1
  } else if (predictions[i] == 1 & validation_target[i] == 1) {
    eval_true_negatives = eval_true_negatives + 1
  } else if (predictions[i] == 0 & validation_target[i] == 1) {
    eval_false_negatives = eval_false_negatives + 1
  } else if (predictions[i] == 1 & validation_target[i] == 0) {
    eval_false_positives = eval_false_positives + 1
  }
}

# Output the counts
print("Counts for True Positives, True Negatives, False Positives, and False Negatives:")
print(paste("True Positives:", eval_true_positives))
print(paste("True Negatives:", eval_true_negatives))
print(paste("False Positives:", eval_false_positives))
print(paste("False Negatives:", eval_false_negatives))

# Calculating Precision, Recall, F1 Score, Error Rate
precision = eval_true_positives / (eval_true_positives + eval_false_positives)
recall = eval_true_positives / (eval_true_positives + eval_false_negatives)
f1_score = 2 * (precision * recall) / (precision + recall)
error_rate = (eval_false_positives + eval_false_negatives) / (eval_true_negatives + eval_false_positives + eval_true_positives + eval_false_negatives)

# View results
print(paste("Best K for K-Nearest Neighbor: ", best_k))
print("Evaluation Metrics:")
print(sprintf("Precision: %.2f%%", precision * 100)) # Measure of exactness
print(sprintf("Recall: %.2f%%", recall * 100)) # Measure of completeness
print(sprintf("Error Rate: %.2f%%", error_rate * 100))
print(sprintf("F1 Score: %.2f%%", f1_score * 100)) # Harmonic mean of precision and recall, suitable for imbalanced dataset


#####################################################################
# Confusion Matrix
#####################################################################

# Load the ggplot2 library for visualization
library(ggplot2)

# Creating the confusion matrix
conf_matrix = matrix(0, nrow = 2, ncol = 2, dimnames = list(Actual = c("Actual Negative", "Actual Positive"), Predicted = c("Predicted Negative", "Predicted Positive")))

# Creating the confusion matrix
# conf_matrix = matrix(0, nrow = 2, ncol = 2, dimnames = list(Actual = c("Actual Positive", "Actual Negative"), Predicted = c("Predicted Negative", "Predicted Positive")))

# Update confusion matrix counts with your data
conf_matrix["Actual Negative", "Predicted Negative"] = eval_true_negatives
conf_matrix["Actual Positive", "Predicted Positive"] = eval_true_positives
conf_matrix["Actual Negative", "Predicted Positive"] = eval_false_positives
conf_matrix["Actual Positive", "Predicted Negative"] = eval_false_negatives

# Print the confusion matrix to the console
print("Confusion Matrix:")
print(conf_matrix)

# Confusion matrix to a dataframe for plotting
conf_matrix_df = as.data.frame(as.table(conf_matrix))

# print(names(conf_matrix_df))

# Plotting the confusion matrix using ggplot2
# ggplot(conf_matrix_df, aes(x = Predicted, y = Actual, fill = Freq)) + geom_tile()

ggplot(conf_matrix_df, aes(x = Predicted, y = Actual, fill = Freq)) +
  geom_tile() +  # Creates the tiles
  geom_text(aes(label = Freq), color = "black", size = 4, vjust = 0.5) +
  labs(title = "Confusion Matrix for KNN using Validation Dataset", x = "Predicted Label", y = "Actual Label") +
  theme_minimal() 


#####################################################################
# Testing Dataset Derived from Data Split (Uncomment to use dataset split)
#####################################################################

# # Debugging
# print(test_data)
# 
# names(test_data)
# print(paste("Best k: ", best_k))
# k = best_k
# 
# # Because KNN is a lazy learner algorithm the training dataset must be provided
# # When the KNN algorithm recommendation is done
# test_predictions = knn(train = train_data, test = test_data, cl = train_target, k = k)
# 
# # Target Label 1 corresponds to Best Value and Target Label 2 corresponds to Not Recommended
# labels = ifelse(test_predictions == 1, 'Best Value', 'Not Recommended')
# 
# # Convert matrix to dataframe for easier manipulation
# test_data_df <- as.data.frame(test_data)
# 
# # Add 'Target' and 'Recommendation' columns to test_data_df
# test_data_df$Target <- test_predictions
# test_data_df$Recommendation <- labels
# 
# # Print results to verify
# print(names(test_data_df))
# print(head(test_data_df))
# print(tail(test_data_df))
# 
# # Output the test dataset into .csv with predictions and recommendations
# write.csv(test_data_df, "test_dataset_with_recommendations_1.csv", row.names = FALSE)
# print("Recommendations are saved in 'test_dataset_with_recommendations_1.csv'.")
# 
# # Copy data from test_data_raw to final_test_data
# # To be used with the 2D and 3D visualization section
# final_test_data = test_data_df
# complete_indices = complete.cases(final_test_data)

#########################################################################
# Testing with a .csv test dataset file (Uncomment to use .csv test dataset)
#########################################################################

# This section is for importing a test data file, if needed
# Import a .csv file as the test data
# --------------------------------------
test_data_raw = read.csv("test_data.csv")
names(test_data_raw)[names(test_data_raw) == "AverageRating"] <- "ProductRating"
names(data_frame)

# Preprocess test data: select same columns, handle NAs
# --------------------------------------
test_features = test_data_raw[, c("ProductPrice", "ProductRating", "ReviewRating", "SentimentScore")]
complete_indices = complete.cases(test_features)

# Scale the feature data using the same parameters as the training data
# --------------------------------------
test_data_scaled = scale(test_features[complete_indices, ])  # Only scale rows without NA

# Test model with correctly processed and scaled test data
# --------------------------------------
test_predictions = knn(train = train_data, test = test_data_scaled, cl = train_target, k = k)

# Map predictions to labels
# Assuming '1' corresponds to 'Best Value' and '2' corresponds to 'Not Recommended'
# --------------------------------------
labels = ifelse(test_predictions == 1, 'Best Value', 'Not Recommended')

# Assign predictions to 'Target' and labels to 'Recommendation' in the cleaned test data
# --------------------------------------
test_data_raw$Target[complete_indices] = test_predictions
test_data_raw$Recommendation[complete_indices] = labels

# Output the dataset with predictions and recommendations
# --------------------------------------
write.csv(test_data_raw, "test_dataset_with_recommendations_2.csv", row.names = FALSE)
print("Recommendations are saved in 'test_dataset_with_recommendations_2.csv'.")
head(test_data_raw)
tail(test_data_raw)

# Copy data from test_data_raw to final_test_data
# To be used with the 2D and 3D visualization section
# --------------------------------------
final_test_data = test_data_raw

#####################################################################
# 2D Visualization 
#####################################################################

# Clears previous graph
graphics.off()

library(ggplot2)

# Filter the data to only include rows that were used in the KNN prediction
visual_data = final_test_data[complete_indices, ]

# Create a scatter plot with SentimentScore
ggplot(visual_data, aes(x = ProductPrice, y = SentimentScore, color = Recommendation)) +
  geom_point(alpha = 0.6, size = 2) +
  labs(title = "KNN Classification of Test Data Based on Sentiment Score",
       x = "Product Price",
       y = "Sentiment Score",
       color = "Recommendation") +
  theme_minimal()


#####################################################################
# 3D Visualization 1st
#####################################################################
# Filter the data to only include rows that were used in the KNN prediction
visual_data = final_test_data[complete_indices, ]

# Create a scatter plot
ggplot(visual_data, aes(x = ProductPrice, y = SentimentScore, color = Recommendation)) +
  geom_point(alpha = 0.6, size = 2) +
  labs(title = "KNN Classification of Test Data",
       x = "Product Price",
       y = "Sentiment Score",
       color = "Recommendation") +
  theme_minimal()

if (!require(plotly)) install.packages("plotly")
library(plotly)

# 'final_test_data' and 'complete_indices' are prepared in testing sections
visual_data = final_test_data[complete_indices, ]

# Creating a 3D scatter plot
plot_ly(visual_data, x = ~ProductPrice, y = ~SentimentScore, z = ~ReviewRating, color = ~Recommendation, colors = c('red', 'blue'), type = "scatter3d", mode = 'markers') %>%
  layout(title = "3D Scatter Plot of KNN Predictions",
         scene = list(xaxis = list(title = 'Product Price'),
                      yaxis = list(title = 'Sentiment Score'),
                      zaxis = list(title = 'Review Rating')))



summary(visual_data)
str(visual_data)

#####################################################################
# 3D Visualization 2nd
#####################################################################
# 
# # Filter the data to only include rows that were used in the KNN prediction
# visual_data = test_data_raw[complete_indices, ]
# 
# # Create a scatter plot
# ggplot(visual_data, aes(x = ProductPrice, y = ProductRating, color = Recommendation)) +
#   geom_point(alpha = 0.6, size = 2) +
#   labs(title = "KNN Classification of Test Data",
#        x = "Product Price",
#        y = "Product Rating",
#        color = "Recommendation") +
#   theme_minimal()
# 
# if (!require(plotly)) install.packages("plotly")
# library(plotly)
# 
# # Assuming 'test_data_raw' and 'complete_indices' are already prepared as mentioned before
# visual_data = test_data_raw[complete_indices, ]
# 
# # Creating a 3D scatter plot
# plot_ly(visual_data, x = ~ProductPrice, y = ~ProductRating, z = ~ReviewRating, color = ~Recommendation, colors = c('red', 'green'), type = "scatter3d", mode = 'markers') %>%
#   layout(title = "3D Scatter Plot of KNN Predictions",
#          scene = list(xaxis = list(title = 'Product Price'),
#                       yaxis = list(title = 'Average Rating'),
#                       zaxis = list(title = 'Review Rating')))
# 
# 
# 
# summary(visual_data)
# str(visual_data)

#####################################################################
#####################################################################

# Clearing the console and workspace
cat("\014")
rm(list = ls())
dev.off()
graphics.off()
cat("\014")