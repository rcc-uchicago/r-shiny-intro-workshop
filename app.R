# Demo of k-means clustering app
# Created by Nicholas Marchio
# Modified from RStudio script here https://www.dropbox.com/s/rjt6g3ctdqvihat/shiny-quickstart-1.zip
# Code here: https://github.com/rcc-uchicago/r-shiny-intro-workshop
# Slides here: https://docs.google.com/presentation/d/1fuUIlfagMGkDzUlRQxjIImjY7mxgqqmS335MYzTqNbc/edit

# Global environment ------------------------------------------------------
# Put all code that runs on startup in the Global i.e. libraries, functions, pre-loaded data, etc.

library(shiny) # Load packages
library(tidyr)
library(ggplot2)
library(dplyr)

color_list <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3","#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999") # Color hexes

data(iris) # Load dataframe
pca <- as.data.frame(prcomp(log(iris[, 1:4]),center = TRUE,scale. = TRUE)[["x"]]) %>% select(PC1, PC2) # Run PCA
iris <- merge(iris, pca, by=0, all=TRUE) %>% select(-one_of(c('Row.names'))) # Merge iris with 2 components

# User Interface ----------------------------------------------------------

# Construct the user interface object
ui <- fluidPage(
  headerPanel('Iris k-means Clustering Tool'), 
  sidebarPanel(
    selectInput(inputId = 'xcol', label = 'X Variable', choices = names(iris)[names(iris) != "Species"]), # Input widget for X-axis column from dataframe columns
    selectInput(inputId = 'ycol', label = 'Y Variable', choices = names(iris)[names(iris) != "Species"], selected = names(iris)[[2]]),  # Input widget for Y-axis column from dataframe columns
    sliderInput(inputId = 'clusters', label = 'Cluster count', value = 3, min = 1, max = 9),  # Input widget for number of clusters based on 1 to 9 integer range
    radioButtons(inputId = "labels", label = "Cluster labels", choices = c("k-means" = "kmeans_label","Actual" = "actual_label")) # Radio button toggle widget
  ),
  mainPanel(
    plotOutput(outputId = 'xyplot') 
  )
)

# Server ------------------------------------------------------------------

# Construct the server object
server <- function(input, output, session) {

  # Reactives that subsets down to data selected from the input widget
  selectedData <- reactive({
    iris[, c(input$xcol, input$ycol)] # Dataframe of selected data in input widget
  })
  selectedX <- reactive({
    iris[, c(input$xcol)] # Dataframe of selected data in input widget
  })
  selectedY <- reactive({
    iris[, c(input$ycol)] # Dataframe of selected data in input widget
  })

  # Reactive that runs k-means clustering function on SelectedData() reactive
  clusters <- reactive({
    kmeans(x = selectedData(), # Reactive object representing selected columns based on user input
           centers = input$clusters) # Number of clusters k in input widget
  })
  
  # Reactive value that contains the legend's cluster groupings
  grouping <- reactiveValues()

  # Observe event to adjust the number of clusters and update the radio button
  observeEvent(input$clusters, {
    if(input$labels=="kmeans_label" | (input$labels=="actual_label" & input$clusters != 3)) { 
      grouping$data <- as.factor(clusters()$cluster) # Assign k-means clusters to data
    }
    updateRadioButtons(session, inputId = 'labels', selected = if(length(unique(grouping$data)) == 3 & input$labels=="actual_label") {"actual_label"} else {"kmeans_label"} ) # Update radio button
  })
  
  # Observe event to change between 'k-means' and 'Actual' and update the slider
  observeEvent(input$labels, {
    if(input$labels=="actual_label") {grouping$data <- iris$Species} # Assign actual species clusters to data
    else { grouping$data <- as.factor(clusters()$cluster) } # Assign k-means clusters to data
    updateSliderInput(session, inputId = 'clusters', value = length(unique(grouping$data)) ) # Update value to correspond to the number of clusters in the legend
  })
  
  # Render a plot of the input reactive data as an output
  output$xyplot <- renderPlot({
    par(mar = c(5.1, 4.1, 0, 1)) # Graph position
    
    # Create X-Y scatter plot
    ggplot(data=iris) + # Raw iris dataset
      geom_point(aes_string(x=selectedX(), # Reactive for x input widget
                            y=selectedY(), # Reactive for y input widget
                            color=grouping$data), # Reactive for legend's cluster groupings
                 size = 4, alpha = .8) + 
      scale_color_manual(values = color_list, name = NULL, guide = guide_legend(nrow = 1)) + # Assign color palette from global
      xlab(input$xcol) + ylab(input$ycol) +
      theme_minimal() +
      theme(text = element_text(size=20),
            legend.position = 'bottom')
  })
}

# Shiny Object ------------------------------------------------------------

# Create Shiny app objects based on ui and server objects
shinyApp(ui = ui, server = server)
