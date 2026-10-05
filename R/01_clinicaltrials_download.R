# ================================================================================= #
# 1. Downloading Cancer Clinical Trials in Brazil from ClinicalTrials.Gov API       #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

# Number of Studies to Download (NULL for All Recruiting Studies)
n_studies <- 5

# Tidying a Single Study from ClinicalTrials.Gov API v2
tidyClinTrialsStudy <- function(study){

      protocol <- study$protocolSection
      collapseField <- function(x) if(length(x) == 0) NA_character_ else paste0(unlist(x), collapse = '|')

      studyInfo <- data.frame(
            study_nct_id = protocol$identificationModule$nctId,
            study_acronym = collapseField(protocol$identificationModule$acronym),
            study_brief_title = collapseField(protocol$identificationModule$briefTitle),
            study_official_title = collapseField(protocol$identificationModule$officialTitle),
            study_brief_summary = collapseField(protocol$descriptionModule$briefSummary),
            study_detailed_description = collapseField(protocol$descriptionModule$detailedDescription),
            study_elegibility_criteria = collapseField(protocol$eligibilityModule$eligibilityCriteria),
            study_conditions = collapseField(protocol$conditionsModule$conditions),
            study_status = collapseField(protocol$statusModule$overallStatus),
            study_design_type = collapseField(protocol$designModule$studyType),
            study_design_phase = collapseField(protocol$designModule$phases),
            study_design_primary_purpose = collapseField(protocol$designModule$designInfo$primaryPurpose),
            study_lead_sponsor_name = collapseField(protocol$sponsorCollaboratorsModule$leadSponsor$name),
            study_lead_sponsor_type = collapseField(protocol$sponsorCollaboratorsModule$leadSponsor$class)
      )

      studyLocations <- protocol$contactsLocationsModule$locations %>%
            lapply(function(x) data.frame(
                  study_nct_id = studyInfo$study_nct_id,
                  study_locations.facility = collapseField(x$facility),
                  study_locations.city = collapseField(x$city),
                  study_locations.state = collapseField(x$state),
                  study_locations.zip = collapseField(x$zip),
                  study_locations.country = collapseField(x$country),
                  study_locations.status = collapseField(x$status)
            )) %>%
            dplyr::bind_rows()

      if(nrow(studyLocations) > 0) studyLocations <- studyLocations %>% dplyr::filter(study_locations.country == 'Brazil')

      return(list(study = studyInfo, locations = studyLocations))

}

# Downloading from ClinicalTrials.Gov API v2 (Paginated)
getClinicalTrialsStudies <- function(query_condition = 'cancer', location = 'Brazil', status = 'RECRUITING', n_studies = NULL){

      query_search <- list(
            format = 'json',
            query.cond = query_condition,
            query.locn = location,
            filter.overallStatus = status,
            pageSize = ifelse(is.null(n_studies), 100, n_studies)
      )

      search_list <- list()
      has_next_page <- TRUE

      while(has_next_page){

            response <- GET(url = 'https://clinicaltrials.gov/api/v2/studies', query = query_search)
            stop_for_status(response)
            data <- fromJSON(content(response, 'text', encoding = 'UTF-8'), simplifyVector = FALSE)

            search_list <- c(search_list, lapply(data$studies, tidyClinTrialsStudy))
            message(glue('Downloaded Studies: {length(search_list)}'))

            has_next_page <- !is.null(data$nextPageToken) && is.null(n_studies)
            query_search$pageToken <- data$nextPageToken

      }

      return(search_list)

}

# Downloading All Recruiting Cancer Trials in Brazil
search_list <- getClinicalTrialsStudies(query_condition = 'cancer', location = 'Brazil', status = 'RECRUITING', n_studies = n_studies)

df_studies <- lapply(search_list, function(x) x$study) %>% do.call(dplyr::bind_rows, .)
df_locations <- lapply(search_list, function(x) x$locations) %>% do.call(dplyr::bind_rows, .)

# Saving Outputs
write(toJSON(df_studies, pretty = TRUE), file = 'data/out_01_studies.json')
write(toJSON(df_locations, pretty = TRUE), file = 'data/out_01_locations.json')
