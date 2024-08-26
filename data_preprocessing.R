# library(shiny)
library(leaflet)
library(stringr)
library(dplyr)
# library(maps)
library(tigris)
library(zipcodeR)

# Read in SSc incidence rate data
incdc_df_SSc <- read.csv("Data/20230206_SSC_ZIP_CODE_RATES_NNK.csv") # 723 records

# Read in OCTD incidence rate data
incdc_df_OCTD <- read.csv("Data/20230205_OCTD_ZIP_CODE_RATES.csv") # 6543 records

# Read in zip code areas shape
char_zips <- readRDS("~/23 Winter/QBS 192/Project/interative_map/zcta.RDS") # 33791 records
# Read in superfund site info
superfund_df <- read.csv("Data/epa-national-priorities-list-ciesin-mod-v2-2014.csv") # 1747 records





# --------------------------------------- Layer 1 -----------------------------------

# Fixed zip codes in the Medicare SSc data
incdc_df_SSc <- incdc_df_SSc %>%
  mutate(Zip.Code = str_pad(as.character(Zip.Code),5,"left","0")) # pad zipcode to 5-digit long 


# Fixed zip codes in the Medicare OCTD data
incdc_df_OCTD <- incdc_df_OCTD %>%
  mutate(Zip.Code = str_pad(as.character(Zip.Code),5,"left","0")) # pad zipcode to 5-digit long 


# Add zipcode area shape info to SSc df
incdc_df_SSc <- char_zips %>% 
  filter(GEOID20 %in% incdc_df_SSc$Zip.Code) %>%
  left_join(incdc_df_SSc,
            by = c("GEOID20" = "Zip.Code")) %>%
  rename("Rate.in.Zip.Code" = "SSc.Rate.in.Zip.Code") %>%
  left_join(reverse_zipcode(incdc_df_SSc$Zip.Code)[,c(1,3,7)], by =c("GEOID20" = "zipcode"))


# Add zipcode area shape info to OCTD df
incdc_df_OCTD <- char_zips %>% 
  filter(GEOID20 %in% incdc_df_OCTD$Zip.Code) %>%
  left_join(incdc_df_OCTD,
            by = c("GEOID20" = "Zip.Code"))%>%
  rename("Rate.in.Zip.Code" = "OCTD.Rate.in.Zip.Code")%>%
  left_join(reverse_zipcode(incdc_df_OCTD$Zip.Code)[,c(1,3,7)], by =c("GEOID20" = "zipcode"))



# --------------------------------------- Layer 2 -----------------------------------
# Fixed zip codes in EPA data
superfund_df <- superfund_df %>%
  mutate(ZIP_CODE = str_pad(as.character(ZIP_CODE),5,"left","0")) # pad zipcode to 5-digit long 


SSc_state_list <- unique(incdc_df_SSc$state)
OCTD_state_list <-unique(incdc_df_OCTD$state)

rm(char_zips)
save.image("SSc_demo/SSc_map/map_data.RData")

