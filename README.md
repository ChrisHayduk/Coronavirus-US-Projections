# Coronavirus US Projections

This project was built to project coronavirus infections and deaths in the United States. The projections were built using the modified SEIR model found in *Prediction of New Coronavirus Infection Based on a
Modified SEIR Model* by Zhou Tang, Xianbin Li, and Houqiang Li.

The projections operate on a state-by-state basis, with no travel between states included in the model. This simplifies the model but makes the projections a bit more inaccurate. Travel between states will likely need to be included at a future point in time.

## Getting Started

The file generate_projections.R utilizes the other supporting files in order to generate the projections for the United States. The starting data for the model is contained in the file US_data.csv, which contains data for each state on the number of confirmed cases, deaths, recovered patients, and the total population.

### Prerequisites

You will need to install R Studio as well as the R libraries "deSolve" and "rlist" in order to run generate_projections.R 

## Author

* **Chris Hayduk** 
