library(spdep)
library(pipeR)
library(rlist)
library(dplyr)
library(stringr)

char_zips <- readRDS("~/23 Winter/QBS 192/Project/interative_map/zcta.RDS") # 33791 records

# Read in SSc incidence rate data
incdc_df_SSc <- read.csv("Data/20230206_SSC_ZIP_CODE_RATES_NNK.csv")[,c(1,3)] # 723 records

# Preprocess data
incdc_df_SSc <- pad_zip_codes(incdc_df_SSc,1)
res <- concat_with_shape_df(incdc_df_SSc)
incdc_df <- res[[1]]
SSc_state_list <- res[[2]]

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
resI_SSc <- localmoran(incdc_df_nb$Rate.in.Zip.Code, nb2listw(nb))
resI_SSc <- data.frame(resI_SSc, Zip.code=incdc_df_nb$GEOID20)
head(resI_SSc)

hist(p.adjust(resI_SSc$Pr.z....E.Ii.., method = "bonferroni"))


# Merge Moran's I test results with the incidence rate df
incdc_df_SSc <- incdc_df %>% 
  left_join(resI_SSc, by = c("GEOID20"= "Zip.code"))

saveRDS(incdc_df_SSc,"SSc_demo/SSc_map/SSc_df.RDS")
saveRDS(SSc_state_list,"SSc_demo/SSc_map/SSc_state_list.RDS")
