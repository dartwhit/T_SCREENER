#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(htmltools)
library(dplyr)
library(shiny)
library(tigris)

OCTD_df <- readRDS("OCTD_df.RDS")
OCTD_state_list <- readRDS("OCTD_state_list.RDS")

SSc_df <- readRDS("SSc_df.RDS")
SSc_state_list <- readRDS("SSc_state_list.RDS")

superfund_df <- readRDS("superfund_df.RDS")

# Define server logic required to draw a histogram
function(input, output, session) {
  
  state_list <- reactive({
    if(input$disease == "SSc"){
      sort(SSc_state_list)}
    else{
      sort(OCTD_state_list)}
  })
  
  # Input state selection 
  output$select_state <- renderUI({
    req(input$by_state == TRUE)
    req(input$disease)
    
    selectInput("state", "Choose a state",
                choices = state_list())
  })
  
  
  my_df <- eventReactive(input$customized_df,{
    inFile <- input$customized_df
    read.delim(inFile$datapath,header = TRUE, sep = "\t")
  })

  # DataFrame containing SSc or OCTD incidence rate
  incdc_df <- reactive({
    # Choose SSc data
    if(as.character(input$disease) == "SSc"){
      df<- SSc_df %>% 
        dplyr::filter(Rate.in.Zip.Code >= input$IR_range[1] & Rate.in.Zip.Code <= input$IR_range[2])
    }
    # Choose OCTD data
    if (as.character(input$disease) == "OCTD"){
      df <-OCTD_df %>% 
         dplyr::filter(Rate.in.Zip.Code >= input$IR_range[1] & Rate.in.Zip.Code <= input$IR_range[2])
    }
    # Choose to upload customized data
    if (as.character(input$disease) == "Customized"){
      df <- my_df()
    }
    
    
    
    
    # Filter by state if needed
    if(input$by_state ==TRUE){
      df %>% filter(state == input$state)
    }else{
      df
    }
  })
  
  output$uploaded_df <- DT::renderDataTable(incdc_df())
  
  
  incdc_df_MoranI <- reactive({
    incdc_df() %>%
      dplyr::filter(Pr.z....E.Ii.. <= input$Moran_I_p)
  })
  
  # Superfund sites
  sites_df <- reactive({
    if(input$by_state ==TRUE){
      superfund_df %>% filter(STATE == input$state)
    }else{
      superfund_df
    }
    })

  
  
  # Incidence rate labels for zip code areas
  labels <- reactive({
    labels <- 
      paste0(
        "Zip code: ",
        incdc_df()$GEOID20, "<br/>",
        as.character(input$disease),
        " incidence rate: ",
        round(as.numeric(incdc_df()$Rate.in.Zip.Code),3), "<br/>",
        "I statistic: ", round(incdc_df()$Ii,3), "<br/>",
        "p value: ", round(incdc_df()$Pr.z....E.Ii..,4)
      ) %>%
      lapply(htmltools::HTML)
  })
  
  # Color Palette
  pal <- reactive({
    colorNumeric(
      palette = "Reds",
      domain = incdc_df()$Rate.in.Zip.Code
    )
  })
  
  
  my_map <- reactive({
    # Initialize leaflet object
    m <- incdc_df() %>%
      leaflet() %>%
      addProviderTiles("CartoDB") 

    p <- pal()
    # Add polygons
    m <- m %>% 
      addPolygons(fillColor = ~p(Rate.in.Zip.Code),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(weight = 2,
                                               color = "black",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = labels()) %>%
      addCircles(lng = as.numeric(incdc_df_MoranI()$INTPTLON20),
                 lat = as.numeric(incdc_df_MoranI()$INTPTLAT20),
                       group = "Moran_I") %>% 
      addMarkers(lng=sites_df()$LONGITUDE,
                 lat = sites_df()$LATITUDE,
                 label = ~htmlEscape(sites_df()$SITE_NAME),
                     group = "superfund") %>%
      addLayersControl(overlayGroups = c("superfund","Moran_I"))
    
  })
  
  # Show incidence on map
  observeEvent(
    eventExpr = input$show,{
      output$ssc_map <- renderLeaflet({
        my_map()
      })
      
    }
  )
  

  

    
  }
