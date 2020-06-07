create_visualization <- function(projections, date_string){
  country_deaths <- colSums(projections[[1]])
  country_infections <- colSums(projections[[2]])
  country_recovered <- colSums(projections[[3]])
  
  data <- data.frame(days = seq(from = 0, to = 100, by = 1), 
                     deaths = country_deaths, 
                     infections = country_infections, 
                     recovered = country_recovered)
  
  plot <- ggplot(data=data) +geom_line(aes(x=days, y= deaths, color = "Deaths"), size = 2) + 
    geom_line(aes(x=days, y=infections, color = "Infections"), size = 2) + 
    geom_line(aes(x=days, y = recovered, color = "Recovered"), size = 2) + 
    scale_colour_manual("", breaks = c("Deaths", "Infections", "Recovered"), values = c("red", "black", "blue")) +
    scale_y_continuous(name="Deaths", labels = scales::comma) + ylab("Deaths") + xlab("Days from Now") + 
    ggtitle(paste0("US COVID-19 Projection (Start Date ", date_string, ")")) + theme(plot.title = element_text(size=16, hjust=0.5),
                                                                                                                                                                          axis.title = element_text(size=14),
                                                                                                                                                                          axis.text = element_text(size=14))
  return(plot)
}