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

library(e1071)

# Load your data set
data <- read.csv("Readable_Results.csv")
data <- read.csv("Chair_Results.csv")

average_value <- mean(data$AverageRating)

# Print the result
print(average_value)

# Create a label vector
#data$label <- ifelse((data$AverageRating / data$ProductPrice >= .3) & (data$SentimentScore >= 0), "good_deal", "bad_deal")
data$label <- ifelse((data$AverageRating / data$ProductPrice >= average_value / data$ProductPrice) & (data$SentimentScore >= 0), "good_deal", "bad_deal")

# Convert label to a factor
data$label <- as.factor(data$label)

data$Value <- data$AverageRating / data$ProductPrice

# Split the data into training and test sets
sample <- sample(c(TRUE, FALSE), nrow(data), replace = TRUE, prob = c(0.7, 0.3))
train_data <- data[sample, ]
test_data <- data[!sample, ]

# Train the SVM model
#model <- svm(label ~ AverageRating + ProductPrice + SentimentScore, data = train_data)

model <- svm(label ~ AverageRating + ProductPrice + SentimentScore, data = train_data,type = 'C-classification', kernel = 'linear') 

# Make predictions on the test set
predictions <- predict(model, newdata = test_data[, c("AverageRating", "ProductPrice", "SentimentScore")])

# Convert predictions to numerical values
test_data$prediction <- as.numeric(predictions) - 1  # good_deal = 1, bad_deal = 0

# Sort the test data by the predictions (good_deal first) and SentimentScore in descending order
sorted_test_data <- test_data[order(-test_data$prediction, -test_data$SentimentScore), ]

# Display the top 5 best deals based on the predictions
cat("The top 5 best deals from the test set based on SVM predictions are:\n")
print(sorted_test_data[1:5, c("ProductName", "AverageRating", "ProductPrice", "SentimentScore", "prediction")])



---------------
# SVM Plot
plot(model, data = train_data, AverageRating ~ ProductPrice, svSymbol = 16, dataSymbol = 4, frame = FALSE)

-------
# Plot the data points colored by actual and predicted labels
plot(test_data$AverageRating, test_data$ProductPrice, col = as.numeric(test_data$label) + 2, pch = 19, xlab = "Average Rating", ylab = "Product Price", main = "SVM Classification")
points(test_data$AverageRating, test_data$ProductPrice, col = test_data$prediction + 4, pch = 3)
legend("topright", legend = c("Good Deal (Actual)", "Bad Deal (Actual)", "Good Deal (Predicted)", "Bad Deal (Predicted)"), pch = c(19, 19, 3, 3), col = c(3, 2, 5, 4))
--------------------------------
library(gplots)  # for the heatmap.2 function
library(RColorBrewer)

x  <- as.matrix(confusion_matrix)

heatmap.2(x,
          col = brewer.pal(7, "Blues"),
          scale = "none",
          margins = c(5, 5),
          main = "Confusion Matrix",
          xlab = "Predictions",
          ylab = "Actual",
          cexRow = 0.8, # Smaller row labels
          cexCol = 0.8, # Smaller column labels
          trace = "none", # Remove trace
          cellnote = confusion_matrix, # Add cell values
          notecex = 1, # Adjust size of cell values
          key = FALSE,
          dendrogram = "none"
          ) # Remove color key and histogram


--------------------
# Plot the decision boundary
library(ggplot2)

ggplot(data, aes(x = Value, y = SentimentScore, color = label)) +
geom_point() +
geom_abline(slope = coef(train_data)[[1]], intercept = coef(train_data)[[2]]) +
labs(title = "SVM Decision Boundary",
    x = "Value",
    y = "SentimentScore",
    color = "Deal") +
scale_color_manual(values = c("good_deal" = "green", "bad_deal" = "red"))

------------------------
x1 <- seq(min(train_data$AverageRating), max(train_data$AverageRating), length.out = 100)
x2 <- seq(min(train_data$ProductPrice), max(train_data$ProductPrice), length.out = 100)
grid <- expand.grid(AverageRating = x1, ProductPrice = x2)

# Add SentimentScore column to the grid
grid$SentimentScore <- median(train_data$SentimentScore)

# Make predictions on the grid
grid_predictions <- predict(model, newdata = grid)

# Plot the data points
plot(train_data$AverageRating, train_data$ProductPrice, col = as.numeric(train_data$label) + 1, pch = 20, xlab = "AverageRating", ylab = "ProductPrice")

# Extract the decision boundary coordinates
boundary_coords <- grid[grid_predictions == 0.5, c("AverageRating", "ProductPrice")]

# Add the decision boundary
lines(boundary_coords$AverageRating, boundary_coords$ProductPrice, col = "blue", lwd = 2)

# Add a legend
legend("topright", legend = c("Good Deal", "Bad Deal"), col = c(2, 1), pch = 20)