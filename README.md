# Introduction to R Shiny
Materials for the introduction to R Shiny Workshop

To follow along open the [slides here.](https://docs.google.com/presentation/d/1fuUIlfagMGkDzUlRQxjIImjY7mxgqqmS335MYzTqNbc/edit?usp=sharing)

## How to run the Shiny app in 5 steps:
1. Install R [here](https://cran.r-project.org/).
2. Install R Studio [here](https://www.rstudio.com/products/rstudio/download/).
3. Open R Studio and install necessary packages:
```
install.packages('shiny')
install.packages('tidyr')
install.packages('ggplot2')
install.packages('dplyr')
```
4. Copy [app.R]('https://raw.githubusercontent.com/rcc-uchicago/r-shiny-intro-workshop/master/app.R') code into new R Script.
5. Click `Run App`.

And to deploy the app, run the following:
```
# install.packages('rsconnect')
library(rsconnect)

# Set up account with shinyapps.io and run the following:
# rsconnect::setAccountInfo(name='nmarchio',
#                           token='user_token',
#                           secret='user_secret')

# Deloy app (make sure to put the app.R file in a R Project directory)
rsconnect::deployApp('/Users/nmarchio/Desktop/Projects/Workshops/r-shiny-workshop/intro-to-shiny-project')

# The link to the app automatically launches, for example: https://nmarchio.shinyapps.io/intro-to-shiny-project/
```

## Author
Nicholas Marchio (contact: nmarchio at uchicago.edu)

## Credits
The presentation and portions of code were based on RStudio tutorial [materials](https://shiny.rstudio.com/tutorial/) developed by Garrett Grolemund.
