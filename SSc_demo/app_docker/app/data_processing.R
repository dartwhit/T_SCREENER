library(stringr)
library(dplyr)
library(tigris)
library(zipcodeR)
# Read in zip code areas shape
char_zips <- readRDS("~/23 Winter/QBS 192/Project/interative_map/zcta.RDS") # 33791 records
new_df <- read.delim("~/23 Winter/QBS 192/Project/interative_map/Data/Gong_Medicare_Dummy_Data.txt")[,c(1,2)]

# This function pads the zipcodes to 5-digit-long with 0s
pad_zip_codes <- function(new_df, col_ind){
  padded_df <- new_df %>%
    mutate(Zip.Code = str_pad(as.character(new_df[,col_ind]),5,"left","0")) # pad zipcode to 5-digit long 
  padded_df
}


# Merge with the zip code areas df
concat_with_shape_df <- function(padded_df){
  incdc_df <- char_zips %>% 
    filter(GEOID20 %in% padded_df$Zip.Code) %>%
    left_join(padded_df,
              by = c("GEOID20" = "Zip.Code")) %>%
    rename("Rate.in.Zip.Code" = 10) %>%
    left_join(reverse_zipcode(padded_df$Zip.Code)[,c(1,3,7)], by =c("GEOID20" = "zipcode"))
  
  custimized_state_list <- unique(incdc_df$state)
  return(list(incdc_df, custimized_state_list))
}

padded_df <- pad_zip_codes(new_df, 2)
res <- concat_with_shape_df(padded_df)
incdc_df <- res[[1]]
state_list <- res[[2]]
