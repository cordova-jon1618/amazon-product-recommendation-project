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

###################################################################################################################
# Installations
###################################################################################################################
# install.packages("Rcrawler")
# install.packages("rvest")
# install.packages("stringr")
# install.packages("polite")

###################################################################################################################
# Part 1
###################################################################################################################

library(Rcrawler)

# Rcrawler(Website = "https://www.amazon.com/", no_cores = 2, no_conn = 2)
# Rcrawler(Website = "https://www.amazon.com/gp/browse.html?node=172282&ref_=nav_em__elec_hub_0_2_15_12", no_cores = 2, no_conn = 2)
# Rcrawler(Website = "https://www.amazon.com/Compatible-Accessories-Adjustable-Replacement-Immersion/dp/B0CHMMQSK3/", no_cores = 2, no_conn = 2)
# Rcrawler(Website = "https://www.amazon.com/s?k=office+printers&i=office-products&rh=n%3A1064954%2Cn%3A172574&dc&ds=v1%3A7i56VyLiwUmtzsM1UGoY24YMFmMWqWdwl4R0jJPfxS8&crid=2XOF7M1Z71DAN&qid=1712082865&rnid=1064954&sprefix=office+printers%2Coffice-products%2C122&ref=sr_nr_n_2", no_cores = 2, no_conn = 2)

# Office Chairs
# Rcrawler(Website = "https://www.amazon.com/AmazonBasics-Puresoft-PU-Padded-Mid-Back-Computer/dp/B081H3Y5NW/", no_cores = 2, no_conn = 2)
# Rcrawler(Website = "https://www.amazon.com/NEO-CHAIR-Ergonomic-Executive-Adjustable/dp/B0C6NGFYV6/", no_cores = 2, no_conn = 2)
# Rcrawler(Website = "https://www.amazon.com/GTPLAYER-Computer-Footrest-Adjustable-360%C2%B0-Swivel/dp/B0BBPRZHRX/ref=sr_1_6?crid=1LAOBK4YX7LWZ&dib=eyJ2IjoiMSJ9.N_zO8fM7pfFFq9F0NIQVODHD8Ip-jdj_ZVIaWw6dt_rF0rd-2tPLIG6P3JqwQQpixNLJ87yF5A4lIcIuKdAA3XXalnSTYbSXSNfeh6dslIt-krSFQr8gRa7PvqcyhFCOEDh-WcZ0VRT1Pxsfq3Mwyqw4e8c5NZhsNfiMrgIpSPw3UK41Un04BcsxI5yUqNtoHXjkaLeFNnAkFcPnnmPqM-hYClKHbJiznI_lKoUJMbx5XRaIV4Mj_LCQY9o-Zx0YR_j_wlr2gtoNCakhJM9sbwT1kRj1VXoVz0fehX8cCcc.k1YROJQuD9mY9vB_GDxu5i4kUPwr9_WUQkefRMIrqMo&dib_tag=se&keywords=gamer+office+chair&qid=1714246191&sprefix=gamer+office%2Caps%2C118&sr=8-6", no_cores = 2, no_conn = 2)
Rcrawler(Website = "https://www.amazon.com/b?node=1069128&ref=sr_nr_n_3", no_cores = 2, no_conn = 2)

###################################################################################################################
# Part 2
###################################################################################################################

library(Rcrawler)
library(rvest)
library(stringr)
library(polite)

# list the folders that collected HTML records from Amazon's website 
# (if the original folder created from Rcrawler function has not been renamed)
ListProjects()

# load the HTML files in the data folder that were collected by using the Rcrawler's LoadHTMLFiles function
# data = LoadHTMLFiles("amazon.com-031435", type = "list") # Technology 
# data = LoadHTMLFiles("amazon.com-031214", type = "list") # Electronic
# data = LoadHTMLFiles("amazon.com-251505", type = "list") # Books
# data = LoadHTMLFiles("amazon.com-011854", type = "list") # Office Chairs 1
# data = LoadHTMLFiles("amazon.com-021136", type = "list")# Office Printer
# data = LoadHTMLFiles("amazon.com-271230", type = "list") # Office Chairs 2
 data = LoadHTMLFiles("amazon.com-271441", type = "list") # Office Chairs 3

# Print the first URL's HTML record collected
# cat(data[[1]], "\n")

# This function searches each HTML record collected 
# and finds the urls that match the format for the detailed product 'dp'
# function 'str_extract_all' extracts all matches from each string
collected_URLS_from_HTML = function(html) {
  urls = str_extract_all(html, "https://www.amazon.com/.+/dp/.+")[[1]]
  return(urls)
}

# lapply aka "list apply" applies the function to each item in list.
extracted_urls = lapply(data, collected_URLS_from_HTML)


# This function takes a url, and checks for the requested url pattern
# removes part of the url that are not useful.
# ^ symbol means that match must start at the beginning of the string
# The second ^ symbol prevents blank spaces after '.com' and before 'dp'
# the [A-Za-z0-9]+ represents the product ID number in the URL
preprocess_the_urls = function(actual_url) {
  
  url_pattern = "^https://www.amazon.com/[^ ]+/dp/[A-Za-z0-9]+"

  # The 'regexpr' function included in the base R library, checks the actual URL
  # with the pattern stated above. index into each string where the match begins 
  # and the length of the match for that string, if not found, returns -1
  url_match = regexpr(url_pattern, actual_url)

  # check if url_match if a valid match was found
  if (url_match[1] != -1) {
    # extract the valid URL
    # excludes other URL components that aren not relevant to your validation criteria.
    valid_url = regmatches(actual_url, url_match)
    return(valid_url)
  } else {
    # Else NA
    return(NA)
  }
}

# flattens the list of lists into a single vector of URLs
# transforming a 2D structure (a list of lists) into a 1D structure (a single vector)
extracted_urls = unlist(extracted_urls)

# Applying the preprocess_the_urls function to clean and validate each URL
filtered_urls = sapply(extracted_urls, preprocess_the_urls, USE.NAMES = FALSE)

# function to filter only those that are not NA added when URL was invalid
is_not_na <- function(check_url) {
  !is.na(check_url)
}
filtered_urls = Filter(is_not_na, filtered_urls)

# URLs in the internet are often encoded, using decode is an additional step 
# in the cleaning process for example, hexadecimal that start with % 
# so decode changes them back to normal
filtered_urls = sapply(filtered_urls, URLdecode, USE.NAMES = FALSE)

# Initialize a data frame for the tuples
# character() are the data types for strings in R
data_frame = data.frame(
  ProductID = character(),
  URL = character(),
  ProductName = character(),
  ProductPrice = character(),
  AverageRating = character(),
  NumberOfRatings = character(),
  ProductCategory = character(),
  ProductSummary = character(),
  OurBrandsRanking = character(),
  CategoryRanking = character(),
  Manufacturer = character(),
  ASIN = character(),
  DateFirstAvailable = character(),
  ReviewBody1 = character(),
  ReviewRating1 = character(),
  ReviewAuthor1 = character(),
  ReviewDate1 = character(),
  ReviewBody2 = character(),
  ReviewRating2 = character(),
  ReviewAuthor2 = character(),
  ReviewDate2 = character(),
  ReviewBody3 = character(),
  ReviewRating3 = character(),
  ReviewAuthor3 = character(),
  ReviewDate3 = character(),
  ReviewBody4 = character(),
  ReviewRating4 = character(),
  ReviewAuthor4 = character(),
  ReviewDate4 = character(),
  ReviewBody5 = character(),
  ReviewRating5 = character(),
  ReviewAuthor5 = character(),
  ReviewDate5 = character(),
  stringsAsFactors = FALSE
)


review_data_frame = data.frame(
  
  ProductID = character(),
  
  OneStarReviewBody1 = character(),
  OneStarReviewRating1 = character(),
  OneStarReviewAuthor1 = character(),
  OneStarReviewDate1 = character(),
  OneStarReviewBody2 = character(),
  OneStarReviewRating2 = character(),
  OneStarReviewAuthor2 = character(),
  OneStarReviewDate2 = character(),
  OneStarReviewBody3 = character(),
  OneStarReviewRating3 = character(),
  OneStarReviewAuthor3 = character(),
  OneStarReviewDate3 = character(),
  OneStarReviewBody4 = character(),
  OneStarReviewRating4 = character(),
  OneStarReviewAuthor4 = character(),
  OneStarReviewDate4 = character(),
  OneStarReviewBody5 = character(),
  OneStarReviewRating5 = character(),
  OneStarReviewAuthor5 = character(),
  OneStarReviewDate5 = character(),
  
  TwoStarReviewBody1 = character(),
  TwoStarReviewRating1 = character(),
  TwoStarReviewAuthor1 = character(),
  TwoStarReviewDate1 = character(),
  TwoStarReviewBody2 = character(),
  TwoStarReviewRating2 = character(),
  TwoStarReviewAuthor2 = character(),
  TwoStarReviewDate2 = character(),
  TwoStarReviewBody3 = character(),
  TwoStarReviewRating3 = character(),
  TwoStarReviewAuthor3 = character(),
  TwoStarReviewDate3 = character(),
  TwoStarReviewBody4 = character(),
  TwoStarReviewRating4 = character(),
  TwoStarReviewAuthor4 = character(),
  TwoStarReviewDate4 = character(),
  TwoStarReviewBody5 = character(),
  TwoStarReviewRating5 = character(),
  TwoStarReviewAuthor5 = character(),
  TwoStarReviewDate5 = character(),
  
  ThreeStarReviewBody1 = character(),
  ThreeStarReviewRating1 = character(),
  ThreeStarReviewAuthor1 = character(),
  ThreeStarReviewDate1 = character(),
  ThreeStarReviewBody2 = character(),
  ThreeStarReviewRating2 = character(),
  ThreeStarReviewAuthor2 = character(),
  ThreeStarReviewDate2 = character(),
  ThreeStarReviewBody3 = character(),
  ThreeStarReviewRating3 = character(),
  ThreeStarReviewAuthor3 = character(),
  ThreeStarReviewDate3 = character(),
  ThreeStarReviewBody4 = character(),
  ThreeStarReviewRating4 = character(),
  ThreeStarReviewAuthor4 = character(),
  ThreeStarReviewDate4 = character(),
  ThreeStarReviewBody5 = character(),
  ThreeStarReviewRating5 = character(),
  ThreeStarReviewAuthor5 = character(),
  ThreeStarReviewDate5 = character(),
  
  FourStarReviewBody1 = character(),
  FourStarReviewRating1 = character(),
  FourStarReviewAuthor1 = character(),
  FourStarReviewDate1 = character(),
  FourStarReviewBody2 = character(),
  FourStarReviewRating2 = character(),
  FourStarReviewAuthor2 = character(),
  FourStarReviewDate2 = character(),
  FourStarReviewBody3 = character(),
  FourStarReviewRating3 = character(),
  FourStarReviewAuthor3 = character(),
  FourStarReviewDate3 = character(),
  FourStarReviewBody4 = character(),
  FourStarReviewRating4 = character(),
  FourStarReviewAuthor4 = character(),
  FourStarReviewDate4 = character(),
  FourStarReviewBody5 = character(),
  FourStarReviewRating5 = character(),
  FourStarReviewAuthor5 = character(),
  FourStarReviewDate5 = character(),
  
  FiveStarReviewBody1 = character(),
  FiveStarReviewRating1 = character(),
  FiveStarReviewAuthor1 = character(),
  FiveStarReviewDate1 = character(),
  FiveStarReviewBody2 = character(),
  FiveStarReviewRating2 = character(),
  FiveStarReviewAuthor2 = character(),
  FiveStarReviewDate2 = character(),
  FiveStarReviewBody3 = character(),
  FiveStarReviewRating3 = character(),
  FiveStarReviewAuthor3 = character(),
  FiveStarReviewDate3 = character(),
  FiveStarReviewBody4 = character(),
  FiveStarReviewRating4 = character(),
  FiveStarReviewAuthor4 = character(),
  FiveStarReviewDate4 = character(),
  FiveStarReviewBody5 = character(),
  FiveStarReviewRating5 = character(),
  FiveStarReviewAuthor5 = character(),
  FiveStarReviewDate5 = character(),
  
  stringsAsFactors = FALSE
)

# Tracking the number of records
record_count = 0

scraping_for_product_info = function(url) {
  
  cat("Record counter is currently: ", record_count, "\n")
  cat("Processing URL:", url, "\n")
  
  # using polite's functions to create a session for scraping
  session <- tryCatch({
    bow(url, force = TRUE) #  using force = TRUE bypasses the cached session
  }, error = function(e) {
    cat("Error creating session for URL:", url, "\nError message:", e$message, "\nSkipping to next URL.\n\n")
    return(NULL)
  })
  
  if (is.null(session)) {
    return()
  }
  
  cat("Session created successfully. Attempting to scrape...\n")
  
  page = tryCatch({
    # read_html(url)
    scrape(session)
  }, error = function(e) {
    cat("Error loading URL:", url, "\nError message:", e$message, "\nSkipping to next URL.\n\n")
    return(NULL)
  })
  
  if (is.null(page)) {
    return()
  }
  
    if (!is.null(page)) {
      
      # Extract the Product ID from the URL
      product_id <- regmatches(url, regexpr("(dp/[^/?]+)", url))[[1]]
      product_id <- gsub("dp/", "", product_id)
      
      # safe extraction method that assigns a blank string if the content is not found
      # the '%>%' is the pipe operator
      # ifelse(test, yes, no) . is a placeholder fo input passed
      product_name = page %>% 
        html_nodes("#productTitle") %>% 
        html_text(trim = TRUE) %>% 
        ifelse(length(.) > 0, ., "")
      
      # Extract price
      product_price = page %>%
        html_nodes(".a-price.a-text-normal .a-offscreen") %>% # Target the .a-offscreen span for the complete price
        html_text(trim = TRUE) %>%
        str_extract("\\$\\d+\\.\\d+") %>% # This regex is fine for matching the price format
        .[1]
      
      # # If no price was found, set to NA
      # if (is.null(product_price) || length(product_price) == 0) {
      #   product_price <- NA
      # }
      
      average_rating_full_text = page %>% 
        html_nodes("#acrPopover") %>% 
        html_attr("title") %>% 
        trimws() %>% 
        ifelse(length(.) > 0, ., "")
      
      average_rating_value = page %>% 
        html_nodes(".a-size-base.a-color-base") %>% 
        html_text(trim = TRUE) %>% 
        ifelse(length(.) > 0, ., "")
      
      number_of_ratings = page %>% 
        html_nodes("#acrCustomerReviewText") %>% 
        html_text(trim = TRUE) %>% 
        ifelse(length(.) > 0, ., "")
      
      product_category = page %>% 
        html_nodes("#nav-subnav") %>% 
        html_attr("data-category") %>% 
        trimws() %>% ifelse(length(.) > 0, ., "")
      
      product_summary = page %>% 
        html_nodes("#product-summary p") %>% 
        html_text(trim = TRUE) %>% 
        ifelse(length(.) > 0, ., "")
      
      asin = page %>% 
        html_nodes(xpath="//th[contains(text(), 'ASIN')]/following-sibling::td") %>% 
        html_text(trim = TRUE) %>% 
        ifelse(length(.) > 0, ., "")
      
      date_first_available = page %>% 
        html_nodes(xpath="//th[contains(text(), 'Date First Available')]/following-sibling::td") %>% 
        html_text(trim = TRUE) %>% 
        ifelse(length(.) > 0, ., "")
      
      our_brands_ranking = str_extract(page %>% html_nodes("#productDetails_detailBullets_sections1") %>% html_text(), "#\\d+ in Our Brands \\(See Top 100 in Our Brands\\)") %>% 
        ifelse(length(.) > 0, ., "")
      
      category_ranking = str_extract(page %>% html_nodes("#productDetails_detailBullets_sections1") %>% html_text(), "#\\d+ in [^(]+") %>% 
        ifelse(length(.) > 0, ., "")
      
      manufacturer_info = page %>% 
        html_nodes("#productDescription") %>% 
        html_nodes("h3 + p span") %>% .[2] %>% 
        html_text(trim = TRUE) %>% 
        ifelse(length(.) > 0, ., "")
      
      # # Extract price
      # product_price = page %>% 
      #   html_nodes("#corePriceDisplay_desktop_feature_div .a-price") %>% 
      #   html_text(trim = TRUE) %>% str_extract("\\$\\d+\\.\\d+") %>% .[1]
      # 
      # # If no price was found, set to NA
      # if (is.null(product_price) || length(product_price) == 0) {
      #   product_price = NA
      # }
      # 
      reviews = page %>% html_nodes('[data-hook="review"]')
      
      # Print the content of the reviews array
      print(reviews)
      
      # Initialize variables for up to 5 reviews
      max_reviews <- 5  # Maximum number of reviews you want to process
      
      # Initialize review_details with NA values for all review slots
      review_details <- lapply(1:max_reviews, function(x) list(
        ReviewBody = NA,
        ReviewRating = NA,
        ReviewAuthor = NA,
        ReviewDate = NA
      ))
      
      # Check if there is at least one review
      if (length(reviews) > 0) {
        num_reviews <- min(length(reviews), max_reviews)
        
        for (i in 1:num_reviews) {
          review <- reviews[i]
          
          review_body = review %>% 
            html_nodes('[data-hook="review-body"]') %>% 
            html_text(trim = TRUE) %>% 
            ifelse(length(.) > 0, ., NA)
          
          review_rating = review %>% 
            html_nodes('[data-hook="review-star-rating"]') %>% 
            html_text() %>% str_extract("\\d\\.\\d|\\d") %>% 
            ifelse(length(.) > 0, ., NA)
          
          review_author = review %>% 
            html_nodes('.a-profile-name') %>% 
            html_text(trim = TRUE) %>% 
            ifelse(length(.) > 0, ., NA)
          
          review_date = review %>% 
            html_nodes('[data-hook="review-date"]') %>% 
            html_text(trim = TRUE) %>% 
            ifelse(length(.) > 0, ., NA)
          
          review_details[[i]] <- list(
            ReviewBody = review_body,
            ReviewRating = review_rating,
            ReviewAuthor = review_author,
            ReviewDate = review_date
          )
        }
      }
      else {
        cat("No reviews found.\n")
      }
      
      # store the variables in dataframe variable called new_row
      new_row = data.frame(
        ProductID = product_id,
        URL = url,
        ProductName = product_name,
        ProductPrice = product_price,
        AverageRating = average_rating_full_text,
        NumberOfRatings = number_of_ratings,
        ProductCategory = product_category,
        ProductSummary = product_summary,
        OurBrandsRanking = our_brands_ranking,
        CategoryRanking = category_ranking,
        Manufacturer = manufacturer_info,
        ASIN = asin,
        DateFirstAvailable = date_first_available,
        stringsAsFactors = FALSE
      )
      
      for (i in 1:max_reviews) {
        if (!is.null(review_details[[i]])) {
          new_row[[paste0("ReviewBody", i)]] = review_details[[i]]$ReviewBody
          new_row[[paste0("ReviewRating", i)]] = review_details[[i]]$ReviewRating
          new_row[[paste0("ReviewAuthor", i)]] = review_details[[i]]$ReviewAuthor
          new_row[[paste0("ReviewDate", i)]] = review_details[[i]]$ReviewDate
        }
      }
      
      # Append the new row to the data frame
      # '<<-' is for assigning to global variables
      data_frame <<- rbind(data_frame, new_row)
      record_count <<- record_count + 1
      
      # Print the extracted information
      cat("---------------------------------------------------------------------------------", "\n\n")
      cat("Record:", record_count, "\n")
      cat("Product ID: ", product_id, "\n")
      cat("URL:", url, "\n")
      cat("Product Name:", product_name, "\n")
      cat("Product Price:", product_price, "\n")
      cat("Average Rating (full text):", average_rating_full_text, "\n")
      cat("Number of Ratings:", number_of_ratings, "\n")
      cat("Product Category:", product_category, "\n")
      cat("Product Summary:", product_summary, "\n")
      cat("Our Brands Ranking:", our_brands_ranking, "\n")
      cat("Category Ranking:", category_ranking, "\n")
      cat("Manufacturer:", manufacturer_info, "\n")
      cat("ASIN:", asin, "\n")
      cat("Date First Available:", date_first_available, "\n")
      
      
      # Print review details for up to 5 reviews
      for (i in 1:5) {
        reviewRatingCol = paste0("ReviewRating", i)
        reviewAuthorCol = paste0("ReviewAuthor", i)
        reviewBodyCol = paste0("ReviewBody", i)
        
        # Check if the columns actually exist in new_row
        if (all(c(reviewRatingCol, reviewAuthorCol, reviewBodyCol) %in% names(new_row)) && 
            nrow(new_row) > 0 && 
            !is.na(new_row[[reviewRatingCol]][1])) {
          cat(sprintf("Review %d Rating: %s\n", i, new_row[[reviewRatingCol]][1]))
          cat(sprintf("Review %d Author: %s\n", i, new_row[[reviewAuthorCol]][1]))
          
          # Optionally print review body with some character limit to avoid overly long printouts
          reviewBodyExcerpt = substr(new_row[[reviewBodyCol]][1], 1, 100)
          cat(sprintf("Review %d Body (excerpt): %s%s\n\n", i, reviewBodyExcerpt, ifelse(nchar(new_row[[reviewBodyCol]][1]) > 100, "...", "")))
        }
      }
      
      cat("---------------------------------------------------------------------------------", "\n\n")
      
      
      # This should return a dataframe with mocked data for each star rating
      temp_reviews_df = create_url_for_reviews(url)
      
      # Print temp_reviews_df for debugging
      print("temp_reviews_df content:")
      print(temp_reviews_df)
      
      # Assuming review_data_frame is defined globally and you're appending within a function
      
      # Append temp_reviews_df to the existing global review_data_frame
      # Use <<- for global assignment if you're modifying review_data_frame from within a function
      review_data_frame <<- rbind(review_data_frame, temp_reviews_df)
      
      # Print review_data_frame for debugging after appending
      print("review_data_frame content after appending:")
      print(review_data_frame)
      
    }
    
}

###################################################################################################################
#   Get Additional Reviews section
###################################################################################################################





library(polite)
library(rvest)
library(stringr)


scraping_for_reviews = function(url, star_rating) {

  # Processing delay to avoid timeout from web scraping
  Sys.sleep(1)

  cat("Processing URL for ", star_rating, " reviews: ", url, "\n")


  # Attempt to create a polite session for the URL
  session = tryCatch({
    bow(url, force = TRUE)
  }, error = function(e) {
    cat("Error creating session for URL:", url, "\nError message:", e$message, "\nSkipping to next URL.\n\n")
    return(NULL)
  })

  if (is.null(session)) {
    return(NULL) # Exit function if session failed to create
  }

  cat("Session created successfully. Attempting to scrape...\n")

  page = tryCatch({
    scrape(session) # Placeholder for your scraping logic
  }, error = function(e) {
    cat("Error loading URL:", url, "\nError message:", e$message, "\nSkipping to next URL.\n\n")
    return(NULL)
  })

  if (is.null(page)) {
    return(NULL) # Exit function if page failed to load
  }

  # Your scraping logic for reviews
  reviews = page %>% html_nodes('[data-hook="review"]')
  print(reviews)

  # Initialize variables for up to 5 reviews
  max_reviews = 5

  # Initialize an empty list to store review details
  review_details_list = vector("list", max_reviews)  # max_reviews = 5

  if (length(reviews) > 0) {
    for (i in 1:min(length(reviews), max_reviews)) {
      review = reviews[i]

      # Safely extract review details, ensuring only the first item is used if multiple are found
      review_body = review %>% html_nodes('[data-hook="review-body"]') %>% html_text(trim = TRUE)
      review_rating = review %>% html_nodes('[data-hook="review-star-rating"]') %>% html_text() %>% str_extract("\\d\\.\\d|\\d")
      review_author = review %>% html_nodes('.a-profile-name') %>% html_text(trim = TRUE)
      review_date = review %>% html_nodes('[data-hook="review-date"]') %>% html_text(trim = TRUE)

      review_details_list[[i]] <- list(
        ReviewBody = ifelse(length(review_body) > 0, review_body[1], NA),
        ReviewRating = ifelse(length(review_rating) > 0, review_rating[1], NA),
        ReviewAuthor = ifelse(length(review_author) > 0, review_author[1], NA),
        ReviewDate = ifelse(length(review_date) > 0, review_date[1], NA)
      )
    }
  } else {
    cat("No reviews found for URL:", url, "\n")
  }

  # Fill in missing reviews if less than max_reviews were found
  for (i in (length(reviews) + 1):max_reviews) {
    review_details_list[[i]] = list(ReviewBody = NA, ReviewRating = NA, ReviewAuthor = NA, ReviewDate = NA)
  }

  # Prepare an empty row with NAs
  review_df_row = matrix(NA, nrow = 1, ncol = 20)
  # Set the column names based on the star rating, interleaving the attributes
  colnames(review_df_row) = unlist(lapply(1:max_reviews, function(i) {
    c(paste0(star_rating, "ReviewBody", i),
      paste0(star_rating, "ReviewRating", i),
      paste0(star_rating, "ReviewAuthor", i),
      paste0(star_rating, "ReviewDate", i))
  }))

  # Populate the row with available review details
  for (i in 1:max_reviews) {
    review_details = review_details_list[[i]]
    # Directly assigning each detail to the correct position in the matrix
    review_df_row[1, (i-1)*4 + 1] = if (!is.null(review_details$ReviewBody)) review_details$ReviewBody else NA
    review_df_row[1, (i-1)*4 + 2] = if (!is.null(review_details$ReviewRating)) review_details$ReviewRating else NA
    review_df_row[1, (i-1)*4 + 3] = if (!is.null(review_details$ReviewAuthor)) review_details$ReviewAuthor else NA
    review_df_row[1, (i-1)*4 + 4] = if (!is.null(review_details$ReviewDate)) review_details$ReviewDate else NA
    # Note: If any review detail is missing, the corresponding slot in review_df_row remains NA due to the earlier filling step
  }

  print(review_df_row)

  # Convert the populated matrix to a dataframe
  review_df = as.data.frame(review_df_row, stringsAsFactors = FALSE)


  return(review_df)

}

###################################################################################################################

create_url_for_reviews = function(url) {
  
  # Define the Amazon domain
  amazon_domain = "https://www.amazon.com"
  
  # Checking if the URL already contains the Amazon domain and /dp/
  if(grepl("www.amazon.com", url) && grepl("/dp/", url)) {
    # Extract the part of the URL after the domain up to /dp/ including the product ID
    base_url = sub(".*(www.amazon.com/dp/[^/?]+).*", "\\1", url)
    edited_url = sub("^(http:|https:)//", "https://", base_url)
  } else {
    # URL does not fit pattern, return an error or handle as needed
    stop("URL does not contain the expected Amazon product pattern.")
  }
  
  # Extract the Product ID from the URL
  product_id = regmatches(url, regexpr("(dp/[^/?]+)", url))[[1]]
  product_id = gsub("dp/", "", product_id)
  
  # Star rating suffixes
  star_suffixes = list(
    OneStar = "/ref=acr_dpx_hist_1?ie=UTF8&filterByStar=one_star&reviewerType=all_reviews#reviews-filter-bar/",
    TwoStar = "/ref=acr_dpx_hist_2?ie=UTF8&filterByStar=two_star&reviewerType=all_reviews#reviews-filter-bar/",
    ThreeStar = "/ref=acr_dpx_hist_3?ie=UTF8&filterByStar=three_star&reviewerType=all_reviews#reviews-filter-bar/",
    FourStar = "/ref=acr_dpx_hist_4?ie=UTF8&filterByStar=four_star&reviewerType=all_reviews#reviews-filter-bar/",
    FiveStar = "/ref=acr_dpx_hist_5?ie=UTF8&filterByStar=five_star&reviewerType=all_reviews#reviews-filter-bar/"
  )
  
  # Initialize an empty dataframe with the correct structure
  column_names = vector("character", length = 0)
  
  for (star in names(star_suffixes)) {
    for (i in 1:5) {
      column_names = c(column_names,
                        paste0(star, "ReviewBody", i),
                        paste0(star, "ReviewRating", i),
                        paste0(star, "ReviewAuthor", i),
                        paste0(star, "ReviewDate", i))
    }
  }
  all_reviews_df = data.frame(matrix(ncol = length(column_names), nrow = 0))
  names(all_reviews_df) = column_names
  
  reviews_list = list()
  
  # Process each star rating
  for (star_rating in names(star_suffixes)) {
    final_url = paste0(edited_url, star_suffixes[[star_rating]])
    cat(sprintf("Processing reviews for %s rating at URL: %s\n", star_rating, final_url))
    
    # Assume scraping_for_reviews now just takes the URL and star rating,
    # and it knows internally how to structure its output.
    reviews_df = scraping_for_reviews(final_url, star_rating)
    
    if (!is.null(reviews_df) && nrow(reviews_df) > 0) {
      reviews_list[[star_rating]] = reviews_df
    }
  }

  if (length(reviews_list) > 0) {
    all_reviews_df = do.call(cbind, reviews_list)
  }
  
  # Cleaning up column names
  # Assuming you've already combined all reviews_df into all_reviews_df as before
  if (!is.null(all_reviews_df) && length(reviews_list) > 0) {
    all_reviews_df = do.call(cbind, reviews_list)
    
    # Renaming columns to remove the prefix
    # This simple pattern assumes your original column names do not contain dots.
    new_col_names = gsub("^[^.]+\\.", "", names(all_reviews_df))
    names(all_reviews_df) = new_col_names
  }
  
  # Adding ProductID column
  if (!is.null(all_reviews_df) && nrow(all_reviews_df) > 0) {
    # Create a vector with ProductID repeated for each row in all_reviews_df
    product_id_vector = rep(product_id, nrow(all_reviews_df))
    
    # Add this vector as a new column to all_reviews_df
    # This operation inherently places ProductID as the last column
    all_reviews_df$ProductID = product_id_vector
    
    # Rearrange columns to move ProductID to the first position
    all_reviews_df = all_reviews_df[, c("ProductID", setdiff(names(all_reviews_df), "ProductID"))]
  }
  
  
  return(all_reviews_df)
}

###################################################################################################################

# Assuming create_url_for_reviews is defined as per your setup
# Let's run a test
# test_url = "https://www.amazon.com/Ailun-Protector-Compatible-Tempered-Friendly/dp/B09CSSP9C1"
# 
# # This should return a dataframe with mocked data for each star rating
# test_reviews_df <- create_url_for_reviews(test_url)
# 
# # Add to existing dataframe
# review_data_frame <- test_reviews_df
# 
# # Print the test results
# print(review_data_frame)
# 
# # Saving the final data_frame to a CSV file
# write.csv(review_data_frame, "amazon_review_scraping_demo2.csv", row.names = FALSE)


###################################################################################################################

final_data_frame = data.frame(
    URL = character(),
    ProductName = character(),
    ProductPrice = character(),
    AverageRating = character(),
    NumberOfRatings = character(),
    ProductCategory = character(),
    ProductSummary = character(),
    OurBrandsRanking = character(),
    CategoryRanking = character(),
    Manufacturer = character(),
    ASIN = character(),
    DateFirstAvailable = character(),
    ReviewBody1 = character(),
    ReviewRating1 = character(),
    ReviewAuthor1 = character(),
    ReviewDate1 = character(),
    ReviewBody2 = character(),
    ReviewRating2 = character(),
    ReviewAuthor2 = character(),
    ReviewDate2 = character(),
    ReviewBody3 = character(),
    ReviewRating3 = character(),
    ReviewAuthor3 = character(),
    ReviewDate3 = character(),
    ReviewBody4 = character(),
    ReviewRating4 = character(),
    ReviewAuthor4 = character(),
    ReviewDate4 = character(),
    ReviewBody5 = character(),
    ReviewRating5 = character(),
    ReviewAuthor5 = character(),
    ReviewDate5 = character(),
    
    ProductID = character(),
    
    OneStarReviewBody1 = character(),
    OneStarReviewRating1 = character(),
    OneStarReviewAuthor1 = character(),
    OneStarReviewDate1 = character(),
    OneStarReviewBody2 = character(),
    OneStarReviewRating2 = character(),
    OneStarReviewAuthor2 = character(),
    OneStarReviewDate2 = character(),
    OneStarReviewBody3 = character(),
    OneStarReviewRating3 = character(),
    OneStarReviewAuthor3 = character(),
    OneStarReviewDate3 = character(),
    OneStarReviewBody4 = character(),
    OneStarReviewRating4 = character(),
    OneStarReviewAuthor4 = character(),
    OneStarReviewDate4 = character(),
    OneStarReviewBody5 = character(),
    OneStarReviewRating5 = character(),
    OneStarReviewAuthor5 = character(),
    OneStarReviewDate5 = character(),
    
    TwoStarReviewBody1 = character(),
    TwoStarReviewRating1 = character(),
    TwoStarReviewAuthor1 = character(),
    TwoStarReviewDate1 = character(),
    TwoStarReviewBody2 = character(),
    TwoStarReviewRating2 = character(),
    TwoStarReviewAuthor2 = character(),
    TwoStarReviewDate2 = character(),
    TwoStarReviewBody3 = character(),
    TwoStarReviewRating3 = character(),
    TwoStarReviewAuthor3 = character(),
    TwoStarReviewDate3 = character(),
    TwoStarReviewBody4 = character(),
    TwoStarReviewRating4 = character(),
    TwoStarReviewAuthor4 = character(),
    TwoStarReviewDate4 = character(),
    TwoStarReviewBody5 = character(),
    TwoStarReviewRating5 = character(),
    TwoStarReviewAuthor5 = character(),
    TwoStarReviewDate5 = character(),
    
    ThreeStarReviewBody1 = character(),
    ThreeStarReviewRating1 = character(),
    ThreeStarReviewAuthor1 = character(),
    ThreeStarReviewDate1 = character(),
    ThreeStarReviewBody2 = character(),
    ThreeStarReviewRating2 = character(),
    ThreeStarReviewAuthor2 = character(),
    ThreeStarReviewDate2 = character(),
    ThreeStarReviewBody3 = character(),
    ThreeStarReviewRating3 = character(),
    ThreeStarReviewAuthor3 = character(),
    ThreeStarReviewDate3 = character(),
    ThreeStarReviewBody4 = character(),
    ThreeStarReviewRating4 = character(),
    ThreeStarReviewAuthor4 = character(),
    ThreeStarReviewDate4 = character(),
    ThreeStarReviewBody5 = character(),
    ThreeStarReviewRating5 = character(),
    ThreeStarReviewAuthor5 = character(),
    ThreeStarReviewDate5 = character(),
    
    FourStarReviewBody1 = character(),
    FourStarReviewRating1 = character(),
    FourStarReviewAuthor1 = character(),
    FourStarReviewDate1 = character(),
    FourStarReviewBody2 = character(),
    FourStarReviewRating2 = character(),
    FourStarReviewAuthor2 = character(),
    FourStarReviewDate2 = character(),
    FourStarReviewBody3 = character(),
    FourStarReviewRating3 = character(),
    FourStarReviewAuthor3 = character(),
    FourStarReviewDate3 = character(),
    FourStarReviewBody4 = character(),
    FourStarReviewRating4 = character(),
    FourStarReviewAuthor4 = character(),
    FourStarReviewDate4 = character(),
    FourStarReviewBody5 = character(),
    FourStarReviewRating5 = character(),
    FourStarReviewAuthor5 = character(),
    FourStarReviewDate5 = character(),
    
    FiveStarReviewBody1 = character(),
    FiveStarReviewRating1 = character(),
    FiveStarReviewAuthor1 = character(),
    FiveStarReviewDate1 = character(),
    FiveStarReviewBody2 = character(),
    FiveStarReviewRating2 = character(),
    FiveStarReviewAuthor2 = character(),
    FiveStarReviewDate2 = character(),
    FiveStarReviewBody3 = character(),
    FiveStarReviewRating3 = character(),
    FiveStarReviewAuthor3 = character(),
    FiveStarReviewDate3 = character(),
    FiveStarReviewBody4 = character(),
    FiveStarReviewRating4 = character(),
    FiveStarReviewAuthor4 = character(),
    FiveStarReviewDate4 = character(),
    FiveStarReviewBody5 = character(),
    FiveStarReviewRating5 = character(),
    FiveStarReviewAuthor5 = character(),
    FiveStarReviewDate5 = character(),
    
    stringsAsFactors = FALSE
  )
  

# library(dplyr)
# 
# # Read CSV files into data frames
# testing_data_frame <- read.csv("amazon_demo.csv")
# testing_review_data_frame <- read.csv("amazon_review_scraping_demo2.csv")
# 
# # Combine the two data frames
# final_data_frame <- bind_rows(testing_data_frame, testing_review_data_frame)
# 
# # View the combined data frame
# print(final_data_frame)
# 
# # Write the combined data frame to a new CSV file
# write.csv(final_data_frame, "final_data_frame.csv", row.names = FALSE)


###################################################################################################################
# library(dplyr)

# Applying the scraping function to each URL in our list
lapply(filtered_urls, scraping_for_product_info )
# Applying the scraping function to the first 5 URLs in the list
# lapply(filtered_urls[1:20], scraping_for_product_info)


# Saving the data_frame to a CSV file
write.csv(data_frame, "amazon_officechairs_product_1.csv", row.names = FALSE)

# Saving the review_data_frame to a CSV file
write.csv(review_data_frame, "amazon_officechairs_review_1.csv", row.names = FALSE)

# Merging based on a common column 'KeyColumn'
final_data_frame <- merge(data_frame, review_data_frame, by = "ProductID")

# Saving the final_data_frame to a CSV file
write.csv(final_data_frame, "amazon_officechairs_data_1.csv", row.names = FALSE)

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
