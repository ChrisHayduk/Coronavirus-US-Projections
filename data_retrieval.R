library(httr)

#Work in progress. Getting error message from text input in read.csv function

retrieve_data <- function(){
  confirmed <- read.csv(text=GET("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"),header=T)
}
