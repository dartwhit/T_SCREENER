#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinyWidgets)
library(leaflet)

# Define UI for application that draws a histogram
fluidPage(theme = shinytheme("journal"),
  
  # Application title
  titlePanel("SCREENER - Ssc and oCtd in or around aReas with EnvironmEnt coNcERns"),
  
  # Sidebar 
  
  sidebarLayout(
    sidebarPanel(
      # Let the user select the disease to visualize
      selectInput("disease", "Disease to visualize",
                  choices = c("SSc","OCTD","Customized"), selected = "SSc"),
      conditionalPanel(
        "input.disease == 'Customized'",
        fileInput(inputId = "customized_df", 
                  label = "Upload a file")
      ),
      # Let the user define the range of incidence rate
      sliderInput(inputId = "IR_range",
                  label = "Range of Incidence Rate",
                  min = 0.09,
                  max = 1.9,
                  value = c(0.1,0.3)),
      # Enable viewing by state
      switchInput("by_state", "View by state"),
      # Choose a state
      conditionalPanel(
        "input.by_state",
        uiOutput("select_state")
      ),
      
      # Let the user filter results by Moran's I test
      numericInput(inputId = "Moran_I_p",
                   label = "P-value cutoff for Moran's I test results",
                   value = 0.05,
                   min = 0,
                   max = 1),
      # Show the map
      actionButton("show","Show map")
      
    ),

  
    
    # Show the map when the button is clicked
    mainPanel(
      # textOutput(
      #   "test"
      # ),
      conditionalPanel(
        "input.show == TRUE",
        leafletOutput("ssc_map")
      )
      # DT::dataTableOutput("uploaded_df"),
      # leafletOutput("ssc_map")

      
    )
)
)
