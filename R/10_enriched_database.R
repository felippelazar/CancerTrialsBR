# ================================================================================= #
# 10. Aggregating the Enriched Database (Studies and Research Facilities)           #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

df_studies <- fromJSON('data/out_07_studies.json')
df_locations <- fromJSON('data/out_09_locations.json')

# One Row per Study and Research Facility
df_database <- df_studies %>%
      dplyr::left_join(df_locations %>%
                             dplyr::select(study_nct_id, location_id, search_address, study_locations.status,
                                           location_name, candidates.formatted_address,
                                           candidates.geometry.location.lat, candidates.geometry.location.lng,
                                           address_compatibility, manual_check),
                       by = 'study_nct_id', relationship = 'one-to-many') %>%
      dplyr::relocate(location_id, location_name, .after = study_nct_id)

write(toJSON(df_database, pretty = TRUE), file = 'data/out_10_database.json')
