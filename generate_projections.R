generate_projections <- function(max_time = 100){
  library(deSolve)
  library(rlist)
  source("load_local_data.R")
  source("SEIR_model.R")
  
  data <- load_local_data()
  
  death_data <- matrix(nrow = 51, ncol = 101)
  colnames(death_data) <- seq(from = 0, to = 100, by = 1)
  death_data <- as.data.frame(death_data)
  rownames(death_data) <- data$Location
  
  infections_data <- matrix(nrow = 51, ncol = 101)
  colnames(infections_data) <- seq(from = 0, to = 100, by = 1)
  infections_data <- as.data.frame(infections_data)
  rownames(infections_data) <- data$Location
  
  recovered_data <- matrix(nrow = 51, ncol = 101)
  colnames(recovered_data) <- seq(from = 0, to = 100, by = 1)
  recovered_data <- as.data.frame(recovered_data)
  rownames(recovered_data) <- data$Location
  
  quarantined_data <- matrix(nrow = 51, ncol = 101)
  colnames(quarantined_data) <- seq(from = 0, to = 100, by = 1)
  qurantined_data <- as.data.frame(quarantined_data)
  rownames(quarantined_data) <- data$Location 
  
  for(state in data$Location){
    state_data <- data[data$Location == state, ]

    confirmed <- as.numeric(state_data[2])
    deaths <- as.numeric(state_data[3])
    recovered <- as.numeric(state_data[4])
    population <- as.numeric(state_data[5])
    
    currently_infected <- (confirmed - deaths - recovered)*3
    
    quarantined <- confirmed
    
    exposed <- currently_infected*3
    
    insusceptible <- exposed + quarantined
    
    susceptible <- population - (insusceptible + exposed + currently_infected + quarantined + recovered + deaths)
    
    parameters <- c(N = population, alpha = 0.085, beta = 1.0, gamma = 2^-1, delta = 7.4^-1, lambda = 0.04, kappa = 0.025)
    ode_state <- c(S = susceptible, P = insusceptible, E = exposed, I = currently_infected, Q = quarantined, R = recovered, D = deaths)
    
    time <- seq(0, max_time, by = 1)
    
    out <- ode(y = ode_state, times = time, func = SEIR_deriv, parms = parameters)
    
    death_data[state,] <- t(out[,"D"])
    infections_data[state,] <- t(out[,"I"])
    recovered_data[state,] <- t(out[,"R"])
    quarantined_data[state,] <- t(out[,"Q"])
    
    rm(out)
  }
  
  projections <- list(death_data, infections_data, recovered_data, as.data.frame(quarantined_data))
  
  return(projections)
}