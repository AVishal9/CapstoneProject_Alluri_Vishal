library(httr)
library(jsonlite)
library(dplyr)

api_token <- "CYSeowIHCwzUgoD4M0K9vr6KKQtjBTYv6XbC5cPZ"

fetch_and_store_articles <- function(search_term = "healthcare", 
                                     num_requests = 20, 
                                     num_articles_per_request = 10, 
                                     start_date = "2023-07-01", 
                                     end_date = "2023-10-21") {
  
  url <- "https://api.thenewsapi.com/v1/news/all"
  
  # Swiss domains list (example)
  swiss_domains <- "swissinfo.ch"
  
  articles_df <- data.frame()
  
  for (page_num in 1:num_requests) {
    params <- list(
      api_token = api_token,
      search = search_term,
      language = "en",
      domains = swiss_domains,
      published_after = start_date,
      published_before = end_date,
      limit = num_articles_per_request,
      page = page_num
    )
    
    response <- GET(url, query = params)
    
    if (status_code(response) == 200) {
      # Read the response body as text
      response_text <- content(response, as = "text")
      data <- fromJSON(response_text)
      
      if (length(data$data) > 0) {
        articles_df <- bind_rows(articles_df, data$data)
      } else {
        break
      }
    } else {
      print(paste("Error:", status_code(response)))
      return(NULL)
    }
  }
  
  return(articles_df) 
}

# Fetch and store articles
news_articles <- fetch_and_store_articles()

if (!is.null(news_articles)) {
  print(news_articles)
}



