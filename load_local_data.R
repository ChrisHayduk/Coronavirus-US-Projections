load_local_data <- function(){
  US_data <- read.csv("C:\\Users\\Chris\\Desktop\\Coronavirus-US-Projections\\US_data.csv")
  
  colnames(US_data)[1] <- "Location"
  
  US_data$Location <- as.character(US_data$Location)
  
  return(US_data)
}