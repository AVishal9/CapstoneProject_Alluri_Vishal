library(httr)
library(jsonlite)
library(dplyr)

api_token <- Sys.getenv("NEWS_API_KEY")

fetch_and_store_articles <- function(search_term, worry_label, 
                                     num_requests = 10, 
                                     num_articles_per_request = 25, #max no. the api allows
                                     start_date = "2023-07-20", 
                                     end_date = "2023-10-21") {
  
  url <- "https://api.thenewsapi.com/v1/news/all"
  
  # Swiss domains list 
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
      #categories = "politics",
      limit = num_articles_per_request,
      page = page_num
    )
    
    response <- GET(url, query = params)
    
    if (status_code(response) == 200) {
      # Read the response body as text
      response_text <- content(response, as = "text")
      data <- fromJSON(response_text)
      
      if (length(data$data) > 0) {
        df <- data.frame(data$data)
        df$worries <- worry_label
        articles_df <- bind_rows(articles_df, df)
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

search_terms <- list(
  health = '"healthcare" | "health insurance"',
  environment = '"environment" + "protection" | "climate change"',
  retirement = '"AHV" | "retirement" + "provision"',
  eu_relations = 'EU',
  energy = '"Energy" + "issues"',
  immigration = '"Foreigners" | "Immigration"',
  inflation = '"Inflation"',
  housing = '"housing + costs" | "rent"',
  refugees = '"Refugees"',
  social_security = '"Social" + "security"'
)


# Fetch and store articles
all_articles <- data.frame()

for (worry_label in names(search_terms)) {
  search_term <- search_terms[[worry_label]]
  articles <- fetch_and_store_articles(search_term, worry_label)
  if (!is.null(articles)) {
    all_articles <- bind_rows(all_articles, articles)
  }
}


if (nrow(all_articles) > 0) {
  print(all_articles)
} else {
  print("No articles found")
}



