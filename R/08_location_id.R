# ================================================================================= #
# 8. Creating the Research Facility Unique Identifier (location_id)                 #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

df_locations <- fromJSON('data/out_01_locations.json')

# Combining All Location Variables into a Single Search String and Identifier
df_locations <- df_locations %>%
      dplyr::mutate(search_address = glue('{study_locations.facility}, {study_locations.city}, {study_locations.state}, {study_locations.zip}, {study_locations.country}')) %>%
      dplyr::mutate(search_address = gsub(' NA$', '', search_address)) %>%
      dplyr::mutate(search_address = gsub('NA[, ]', '', search_address)) %>%
      dplyr::mutate(search_address = trimws(gsub('[,] +', ', ', search_address))) %>%
      dplyr::mutate(location_id = toupper(gsub('\\W', '', stringi::stri_trans_general(search_address, 'Latin-ASCII')))) %>%
      dplyr::relocate(location_id, .after = study_nct_id)

write(toJSON(df_locations, pretty = TRUE), file = 'data/out_08_locations.json')
