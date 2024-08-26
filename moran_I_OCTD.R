library(spdep)
library(pipeR)
library(rlist)
library(dplyr)
library(stringr)

char_zips <- readRDS("~/23 Winter/QBS 192/Project/interative_map/zcta.RDS") # 33791 records

# Read in OCTD incidence rate data
incdc_df_OCTD <- read.csv("Data/20230205_OCTD_ZIP_CODE_RATES.csv")[,c(1,3)] # 723 records

# Preprocess data
incdc_df_OCTD <- pad_zip_codes(incdc_df_OCTD,1)
res <- concat_with_shape_df(incdc_df_OCTD)
incdc_df <- res[[1]]
OCTD_state_list <- res[[2]]

# Get neighbors for all areas in the incidence df
nb <- poly2nb(incdc_df$geometry)

# Filter out areas without neighbors
is_empty <- function(x){
  length(x) == 1 && x == 0
}

empty_idx <- which(unlist(lapply(nb, is_empty))) # Indices of areas with no neighbors

# Filter incidence df using this list and rebuild neighbors
incdc_df_nb <- incdc_df[-empty_idx,]
nb <- poly2nb(incdc_df_nb$geometry)


# Local Moran's I
resI_OCTD <- localmoran(incdc_df_nb$Rate.in.Zip.Code, nb2listw(nb))
resI_OCTD <- data.frame(resI_OCTD, Zip.code=incdc_df_nb$GEOID20)
head(resI_OCTD)

hist(p.adjust(resI_OCTD$Pr.z....E.Ii.., method = "bonferroni"))


# Merge Moran's I test results with the incidence rate df
incdc_df_OCTD <- incdc_df %>% 
  left_join(resI_OCTD, by = c("GEOID20"= "Zip.code"))

saveRDS(incdc_df_OCTD,"SSc_demo/SSc_map/OCTD_df.RDS")
saveRDS(OCTD_state_list,"SSc_demo/SSc_map/OCTD_state_list.RDS")
