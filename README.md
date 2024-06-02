# Amazon Product Recommendation Project
Using Data Mining to Compare Amazon Ratings to Customer Sentiment

## Overview
This project involves web crawling, data cleaning, and machine learning analysis using KNN.

# INTRODUCTION
Online shopping has radically changed the way people shop today. Although Amazon is the market leader, one main disadvantage of using the site is the inability to interact with products before buying them. With such a large variety of similar items it can be difficult for someone who simply wants to purchase an item to find what they need. With this in mind our project aims to improve the usability of the Amazon store page by scraping the data found on Amazon to filter out all of the extra information and try to find the products with the best value based on existing user reviews and price.

We proposed to use R to create a product recommendation system. This system will use a web crawler to collect data from Amazon's webstore. Our crawler will crawl every product page in a product category to gather data including product names, categories, prices, user reviews and ratings. The data collected will be cleaned and the reviews will be processed using sentiment analysis to give the product a sentiment score. A recommendation will be made to identify the best product in that product category. Using this strategy we can identify and recommend the best product for a customer, making shopping easier.

## Problem To Solve
To gain insights into consumer preferences, find the best value based on user reviews and save the customers time and effort researching similar brands. We propose to analyze and make recommendations on three product types, (1) books (including audiobooks and ebooks), (2) office chairs and (3) printers.

## Proposed Method
This project aims to fix the problem of quantity over quality on the Amazon webstore by using data to find a good middle ground between product quality and price. By using Amazon’s own data our project will be able to have up to date pricing information and allow the user to make selections faster and with less annoyance.

# RELATED WORKS
The paper, WEB USAGE MINING-A Study of Web data pattern detecting methodologies and its applications in Data Mining, served as inspiration for our project. The paper introduces the concept of web mining and the different methods and techniques available to using the world wide web as a source of data collecting.

# METHODS
## Part 1
### Data Collection
For data collection, our goal was to gather product data from the Amazon Webstore. To achieve this, we used two key R libraries: Rcrawler and Rvest. Rcrawler helped us explore different parts of the Amazon website and collect HTML data in an organized way. Meanwhile, Rvest was necessary for pulling out specific product information from web pages.

To collect data from each detailed product page, cleaning and validating the URLs was necessary to ensure that each URL contained the ‘dp’ (detailed product) keyword along with the product ID. Additionally, the URLs were trimmed to retain only essential information by removing any text appearing after the product ID within the URL. Preprocessing was employed to clean the collected URLs, URLs marked as 'NA' were removed, and the URL strings were decoded to eliminate hexadecimal notations. A dataframe was created to store the values extracted from each valid URL. The read_html() function was used to access the URL to verify accessibility, and then it proceeded to retrieve the data. html_nodes() was used to identify the tags within the HTML to find the desired data. Finally, the data collected was exported into a .csv file.

Challenges encountered included difficulties in obtaining the specific data required for making a recommendation and facing security timeouts from Amazon.com. A workaround solution involved using the Polite R library.  Unfortunately, this library is not perfect, as Amazon has additional security deterrents for web scraping. Additionally, the revised code now collected additional reviews after gathering data from the detailed product page. If a detailed product page retrieval is successful, the URL is copied and trimmed and then used to attempt to access the product’s review pages. Hence, this addition involves navigating through the one star, two star, three star, four star, and five star reviews,to collect the first five reviews of each. However, the downside of this is that it makes web scraping slower in comparison to scraping reviews from the detailed product pages.

### Data Preprocessing
For processing the raw data Tidyverse and ‘dplyr’ were used for manipulating the data sets. The scraped data for our project was saved as a .csv file, with each entry in the file holding the information for five reviews in each scrape (one for each level of rating.) To begin cleaning, each row is split into five sub-entries and each sub-entry is checked for completeness. If the required fields (such as item name, price, review author and rating) are present for that entry it is saved in a dataframe. If the entry is missing fields that can be replaced, such as the review author and user ratings they are set aside in a different dataframe. The incomplete reviews are then filled in with the averages calculated for that product category and missing authors are changed to "None." By using the average reviews for a product’s category for missing user reviews we are able to get usable data points without significantly affecting our outcomes. 

Both datasets are processed in parallel, with each entry checked for relevance to the desired categories (books, office chairs and printers.) All entries have their values changed to allow for working with the data easier, such as the price and review fields being changed from strings like “4.8 out of 5” and “$5.99” to numeric values such as “9.8” and “5.99”. Sub-categories such as "digital-text" and "audible" are kept and renamed to be more human readable, with "digital-text" becoming  "Ebooks'' and "audible" becoming "Audiobooks.” The remaining entries in both data sets are then processed using the user review message and the SentimentAnalysis library to find a sentiment analysis score and a label that marks that review as "positive", "neutral" or "negative." Finally both data sets are merged into a single large data set and checked for duplicate entries, with the final data set saved as a .csv file for later use.

### Data Visualization
The visualizations for the project were created using three separate .csv files, one for each of the product categories. A scatter plot was used to give an overview of how the amazon reviews and price compare to the user submitted reviews. The plots also use the updated product categories to make the graph a little more understandable for the reader. A correlation matrix was also created, which compares the amazon reviews, user submitted reviews and product price to each other. Examining the correlation between Amazon reviews and user reviews revealed a weak positive correlation, showing that Amazon reviews for books are consistent with the user reviews. It also showed that for office chairs the rating and price of an item have a strong negative correlation, showing that customers tend to not like the more expensive items in that category as much when compared to the cheaper alternatives. These graphs give insight into how to train our model in the next steps. For the sentiment analysis scores we also used a word cloud for the different sentiments. An example of a correlation matrix can be found below, showing how Amazon’s reviews, the customer reviews and product price all interact with each other.

## Part 2
### Classification - K-Nearest Neighbor (KNN)
K Nearest Neighbor (KNN) is a supervised learning classification algorithm that operates on the idea of similarity. Each data point is determined by the class that is most common among its k nearest neighbors. For example, if k is set to 11, the algorithm examines the 11 nearest points to determine the classification of a new data point. These points are checked to see which class they fall under. The algorithm tallies up the occurrence of each class for those 11 points, and the class with the highest number of points results in the new data point being placed into it. Additionally, K Nearest Neighbor is a lazy learner algorithm because of its lack of training during the model building phase. Unlike eager learners, which construct a generalized model based on the entire training dataset beforehand, it waits to learn until a new data point needs to be classified.

This classification algorithm was selected due to its appropriateness for the task at hand. The objective is to categorize each product as either “Best Value” or “Not Recommended,” making a classification algorithm the most effective choice. The proposed goal of this project is to train the algorithm to identify the best value products by detecting prices below the mean (indicating low price) for products. And the algorithm aims to recognize products that are above the mean in terms of product rating and sentiment scores, indicating higher quality. By focusing on these criteria, the algorithm is equipped to categorize products into “Best Value” or “Not Recommended” classes, which is the overarching goal of our project.

### Classification - Support Vector Machines (SVM)
Support Vector Machines (also known as SVMs) are a classification algorithm useful for classifying data into different categories. By finding the best plane between data points (known as support vectors) we can easily categorize data based on which side of the plane they end up on. For our data we initially split our dataset into two sets, 80% of the data being used for training and the remaining 20% used for the testing dataset. Each item in the dataset is given a “value” score, which is the ratio between the product’s rating and the product's price. If this value score is better than the average value score for that item’s category, this item is considered to be potentially a good deal. If it does not meet this criteria the item is rejected. 

A model is trained using the found value and the item’s sentiment score to identify what a good deal is. By using sentiment scores along with the value we can compare each item and rank them from best value to worst value while also avoiding items that are extremely cheap but poorly rated. The “best deal” item is ranked and chosen from and has its information displayed to the user, with the first pick being the recommended product for that category. The model is trained on separate datasets for each category to prevent the model from using predictions based on categories that tend to be more expensive on categories whose prices are cheap, such as office chairs compared to relatively inexpensive books.

Once all of the“good deal” items are ranked and the best deal is chosen some visualizations are made, including a SVM graph showing the distribution of different items and how they were labeled (“good” or “bad” deal) and a confusion matrix which shows the correct and incorrect number of predictions the model made. 


## Project Structure
- `data/`: Contains raw and test data files.
  - `raw/`: Raw data files.
  - `processed/`: processed data files.
  - `test_dataset_csv_import/`: Test data file.
- `scripts/`: Contains R scripts.
  - `web_scraper_and_crawler/`: Scripts for web crawling.
  - `data_processing_for_preparing_knn_dataset/`: Script for cleaning data.
  - `data_processing_for_preparing_svm_dataset/`: Script for cleaning data.
- `analysis/`: Contains R scripts for data analysis.
  - `knn_algorithm/`: Script for KNN machine learning model.
  - `svm_algorithm/`: Script for SVM machine learning model.
