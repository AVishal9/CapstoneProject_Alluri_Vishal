library(httr)
library(jsonlite)
library(dplyr)

api_token <- "CYSeowIHCwzUgoD4M0K9vr6KKQtjBTYv6XbC5cPZ"

fetch_and_store_articles <- function(search_term = "healthcare+politics", 
                                     num_articles = 10, 
                                     start_date = "2023-09-01", 
                                     end_date = "2023-10-21") {
  
  url <- "https://api.thenewsapi.com/v1/news/all"
  
  articles_df <- data.frame()
  
  for (page_num in 1:ceiling(num_articles/100)) {
    params <- list(
      api_token = api_token,
      search = search_term,
      language = "en",
      locale = "ch",
      published_after = start_date,
      published_before = end_date,
      limit = min(100, num_articles - (page_num - 1) * 100),
      page = page_num
    )
    
    response <- GET(url, query = params)
    
    if (status_code(response) == 200) {
      # Read the response body as raw text
      response_text <- rawToChar(response$content)
      data <- fromJSON(response_text)
      
      if (length(data$data) > 0) {
        articles_df <- rbind(articles_df, data$data)
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