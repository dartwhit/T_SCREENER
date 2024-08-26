library(shiny)
library(leaflet)
library(stringr)
library(dplyr)
# library(maps)
library(tigris)

# Read in SSc incidence rate data
incdc_df <- read.csv("Data/20230206_SSC_ZIP_CODE_RATES_NNK.csv")
# Read in zip code areas shape
char_zips <- readRDS("~/23 Winter/QBS 192/Project/interative_map/zcta.RDS")
# Read in superfund site info
superfund_df <- read.csv("Data/epa-national-priorities-list-ciesin-mod-v2-2014.csv")





# --------------------------------------- Layer 1 -----------------------------------

# Fixed zip codes in the Medicare data
incdc_df <- incdc_df %>%
  mutate(Zip.Code = str_pad(as.character(Zip.Code),5,"left","0")) # pad zipcode to 5-digit long 

# Filter shape data using zipcode in Medicare data and merge 
incdc_df <- char_zips %>% 
  filter(GEOID20 %in% incdc_df$Zip.Code) %>%
  left_join(incdc_df,
           by = c("GEOID20" = "Zip.Code"))


# Create color palette
pal <- colorNumeric(
  palette = "Reds",
  domain = incdc_df$ssc.rate.in.zip.code
)


# Create labels for zipcodes
labels <- 
  paste0(
    "Zip code: ",
    incdc_df$GEOID20, "<br/>",
    "SSc incidence rate: ",
    round(as.numeric(incdc_df$SSc.Rate.in.Zip.Code),3)
  ) %>%
  lapply(htmltools::HTML)

# --------------------------------------- Layer 2 -----------------------------------
# Fixed zip codes in EPA data
superfund_df <- superfund_df %>%
  mutate(ZIP_CODE = str_pad(as.character(ZIP_CODE),5,"left","0")) # pad zipcode to 5-digit long 

# # Merge shape df with superfund_Df
# incdc_df <- incdc_df %>%
#   left_join(superfund_df,
#             by = c("GEOID20"="ZIP_CODE"),
#             multiple = "all")

# colnames(incdc_df) <- tolower(colnames(incdc_df))
# -------------------------------------- Visualization -----------------------
# Initialize leaflet object
m <- incdc_df %>%
  leaflet() %>%
  addProviderTiles("CartoDB")


# Add polygons 
m <- m %>% addPolygons(fillColor = ~pal(SSc.Rate.in.Zip.Code),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(weight = 2,
                                               color = "#666",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = labels)

# Add pins
m %>% addMarkers(lng=superfund_df$LONGITUDE,
                 lat = superfund_df$LATITUDE)

