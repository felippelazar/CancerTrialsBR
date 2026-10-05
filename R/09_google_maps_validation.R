# ================================================================================= #
# 9. Querying Google Maps API and Validating Candidates with LLM                    #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

# Prompt
compareAddressPrompt <- 'Your task is to evaluate the two provided addresses and return in JSON format the probability that they refer to the same place. 
Be very strict in your evaluation and account for any uncertainties or ambiguities in the address details.
In addition, this address comes from ClinicalTrials.Gov, and therefore it should correspond to a hospital or clinic or anything that resembles a research facility that recruit patients.
Here are the guidelines:
Compare all address components, including landmarks, street names, numbers, city, and state.
Consider possible typographical errors, minor differences, or variations in naming conventions that could still refer to the same location.
Take into account that places may have different names but refer to the same place/institution.
Use your Google knowledge about locations in Brazil to provide inferences.
Provide a probability score indicating the likelihood of them being the same location. Reflect any uncertainties in this score.
If the Google Maps API result is not a research facility or hospital, return a low probability irrespective of the address.

Address 1: {var_1} (ClinicalTrials.Gov)
Address 2: {var_2} (Google Places API)

The "address_compatibility" value MUST be a floating-point number between 0 and 1, inclusive (e.g., 0, 0.15, 0.5, 0.87, 1).
- Do NOT return a percentage (e.g., 85 or "85%").
- Do NOT return a string, boolean, null, or any non-numeric value.
- Do NOT return a value below 0 or above 1.
- Use at least two decimal places of precision (e.g., 0.73 rather than 0.7) to reflect genuine uncertainty.

The JSON should look like this:
{{
  "address_compatibility": {{float}}
}}

Return ONLY the JSON object above, with no additional text, explanation, markdown formatting, or code fences before or after it.'

# Querying Google Places API (Find Place from Text)
getPlacesAPI <- function(search_address, api_key = Sys.getenv('GOOGLE_MAPS_API_KEY')){
      
      resultPlacesAPI <- GET(
            url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json',
            query = list(
                  fields = 'name,formatted_address,geometry',
                  input = gsub('\\(.*?\\)', '', search_address),
                  inputtype = 'textquery',
                  language = 'pt',
                  key = api_key
            )
      )
      
      Sys.sleep(0.1)
      return(content(resultPlacesAPI, 'parsed'))
      
}

df_locations <- fromJSON('data/out_08_locations.json')

# Querying Each Unique location_id and Selecting the First Candidate
google_candidates <- df_locations %>%
      dplyr::distinct(location_id, search_address) %>%
      split(1:nrow(.)) %>%
      pblapply(function(x) {
            candidates <- getPlacesAPI(x$search_address)$candidates
            if(length(candidates) == 0) return(data.frame(location_id = x$location_id, search_address = x$search_address))
            candidate <- candidates[[1]]
            data.frame(location_id = x$location_id,
                       search_address = x$search_address,
                       candidates.name = candidate$name,
                       candidates.formatted_address = candidate$formatted_address,
                       candidates.geometry.location.lat = candidate$geometry$location$lat,
                       candidates.geometry.location.lng = candidate$geometry$location$lng)
      }) %>%
      do.call(dplyr::bind_rows, .)

# Reviewing Google Maps Candidates with LLM (Probability of Correct Identification)
locations_matched <- google_candidates %>%
      split(1:nrow(.)) %>%
      pblapply(function(x) {
            if(is.null(x$candidates.name) || is.na(x$candidates.name)) return(x)
            chatLLM(x, intruction_prompt = compareAddressPrompt, var_1 = x[['search_address']], var_2 = glue('{x[["candidates.name"]]}, {x[["candidates.formatted_address"]]}'))
      }) %>%
      do.call(dplyr::bind_rows, .) %>%
      dplyr::mutate(address_compatibility = ifelse(is.na(address_compatibility), 0, as.numeric(address_compatibility))) %>%
      dplyr::mutate(manual_check = ifelse(address_compatibility >= 0.8, 'Y', 'N'))

write(toJSON(locations_matched, pretty = TRUE), file = 'data/out_09_locations_matched.json')

# Final Locations Table: Non-Identified Facilities (manual_check = 'N') go to Human Review
df_locations %>%
      dplyr::left_join(locations_matched %>% dplyr::select(-search_address), by = 'location_id') %>%
      dplyr::mutate(location_name = ifelse(manual_check == 'Y', candidates.name, '(Centro Não-Identificado)')) %>%
      toJSON(pretty = TRUE) %>%
      write(file = 'data/out_09_locations.json')
