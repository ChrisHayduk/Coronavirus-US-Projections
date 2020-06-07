#Computes the derivative of each component of the SEIR model
#Defining inputs:
# Functions of time (ie. state variables):
#   S - susceptible cases
#   P - insusceptible cases
#   E - exposed cases (infected but not yet infectious)
#   I - infectious cases (not yet quarantined)
#   Q - quarantined cases (confirmed and infected)
#   R - recovered cases
#   D - deaths
#
# Constants (ie. parameters):
#   N - population
#   alpha - protection rate
#   beta - infection rate
#   gamma - inverse of average latent time
#   delta - inverse of average quarantine time
#   lambda - cure rate 
#   kappa - mortality rate
#
#NOTE: N = S+P+E+I+Q+R+D at all times

SEIR_deriv <- function(t, state, parameters){
  with(as.list(c(state, parameters)),{
    # rate of change
    dS <- beta * (S * I)/N - alpha*S
    dP <- alpha*S
    dE <- beta * (S*I)/N - gamma*E
    dI <- gamma*E - delta*I
    dQ <- delta*I - lambda*Q - kappa*Q
    dR <- lambda*Q
    dD <- kappa*Q
      
    # return the rate of change
    list(c(dS, dP, dE, dI, dQ, dR, dD))
  })
}


#EXAMPLE USE (Need deSolve package to solve ODE. Numbers below are for NY dat as of 3/11/2020):
#
# parameters <- c(N = 19540000, alpha = 0.085, beta = 1.0, gamma = 2^-1, delta = 7.4^-1, lambda = 0.02, kappa = 0.03)
# state <- c(S = 19539182, P = 818, E = 300, I = 300, Q = 218, R = 0, D = 0)
# time <- seq(0, 200, by = 1)
# out <- ode(y = state, times = time, func = SEIR_deriv, parms = parameters)
