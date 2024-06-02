# Amazon Product Recommendation Project
Using Data Mining to Compare Amazon Ratings to Customer Sentiment

## Overview
This project involves web crawling, data cleaning, and machine learning analysis using KNN.

# INTRODUCTION
	Online shopping has radically changed the way people shop today. Although Amazon is the market leader, one main disadvantage of using the site is the inability to interact with products before buying them. With such a large variety of similar items it can be difficult for someone who simply wants to purchase an item to find what they need. With this in mind our project aims to improve the usability of the Amazon store page by scraping the data found on Amazon to filter out all of the extra information and try to find the products with the best value based on existing user reviews and price.
We proposed to use R to create a product recommendation system. This system will use a web crawler to collect data from Amazon's webstore. Our crawler will crawl every product page in a product category to gather data including product names, categories, prices, user reviews and ratings. The data collected will be cleaned and the reviews will be processed using sentiment analysis to give the product a sentiment score. A recommendation will be made to identify the best product in that product category. Using this strategy we can identify and recommend the best product for a customer, making shopping easier.

# Problem To Solve
To gain insights into consumer preferences, find the best value based on user reviews and save the customers time and effort researching similar brands. We propose to analyze and make recommendations on three product types, (1) books (including audiobooks and ebooks), (2) office chairs and (3) printers.

# Proposed Method
This project aims to fix the problem of quantity over quality on the Amazon webstore by using data to find a good middle ground between product quality and price. By using Amazon’s own data our project will be able to have up to date pricing information and allow the user to make selections faster and with less annoyance.

# RELATED WORKS
The paper, WEB USAGE MINING-A Study of Web data pattern detecting methodologies and its applications in Data Mining, served as inspiration for our project. The paper introduces the concept of web mining and the different methods and techniques available to using the world wide web as a source of data collecting.



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
