# ================================================================================= #
# 2. Generating the Single-Sentence Study Title (English and Portuguese)            #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

# Prompt
studySentencePrompt <- 'You will receive a studys title and description, and your task is to re-write the official title as a very concise, flowing sentence describing the study. The single sentence title must:

- Resembles a title and do not begin with "This study". 
- Be written in both English and Portuguese.
- Contain 1 sentence of 200 characters maximum and cover the essence of the study methodology and targeted-population so the reader can understand the study at a glance.
- Include names of intervetions drugs and cancer conditions if applicable.
- If an acronym name of the study is present, include it in the beggining of the sentence. If not available, skip the acronym.
- Return the result in JSON format with two variables: "study_ai_sentence_english" and "study_ai_sentence_portuguese". 

Use your summary skills to capture the essence of the study in a single sentence which will be used as a title.

Output Examples: "(STUDY-ACRONYM) Observational study that evaluates the efficacy of a new drug in treating lung cancer patients". 
AND "(STUDY-ACRONYM) Estudo observacional que avalia a eficácia de um novo medicamento no tratamento de pacientes com câncer de pulmão."

Return the study details as a valid JSON object. Ensure all keys and string values use double quotes, and no extra text is included. The output JSON should look like this:

{{
"study_ai_sentence_english" : "string"
"study_ai_sentence_portuguese" : "string"
}}

The study title is: {var_1}
The study description is: {var_2}'

df_studies <- fromJSON('data/out_01_studies.json')

df_studies %>%
      split(1:nrow(.)) %>%
      pblapply(function(x) chatLLM(x, intruction_prompt = studySentencePrompt, var_1 = trimws(paste(ifelse(is.na(x[['study_acronym']]), '', x[['study_acronym']]), x[['study_official_title']])), var_2 = x[['study_brief_summary']])) %>%
      do.call(dplyr::bind_rows, .) %>%
      toJSON(pretty = TRUE) %>%
      write(file = 'data/out_02_studies.json')
