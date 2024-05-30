library(httr)
library(jsonlite)

api_token <- "CYSeowIHCwzUgoD4M0K9vr6KKQtjBTYv6XbC5cPZ"

target_sources <- c("nzz.ch", "tagesanzeiger.ch", "20min.ch")

sources_url <- "https://api.thenewsapi.com/v1/news/sources"

# list to store results for each source
availability_results <- list()

for (source in target_sources) {
  params <- list(
    api_token = api_token,
    domains = source  # Filter by domain
  )
  
  response <- GET(sources_url, query = params)
  
  if (status_code(response) == 200) {
    sources_data <- fromJSON(content(response, as = "text"))$data
    is_available <- length(sources_data) > 0
    availability_results[[source]] <- is_available
    message <- ifelse(is_available, "is available", "is NOT available")
    print(paste(source, message, "in the NewsAPI."))
  } else {
    print(paste("Error checking availability of", source, ":", status_code(response)))
    availability_results[[source]] <- NA
  }
}


