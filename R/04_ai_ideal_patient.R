# ================================================================================= #
# 4. Generating the Study Ideal Patient (English and Portuguese)                    #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

# Prompt
idealPatientPrompt <- "# Study Patient Profile Generator
## Task
You will receive a clinical studys eligibility criteria and generate a concise, flowing paragraph describing the ideal patient profile for this study in both English and Portuguese.

## Chain-of-Thought Process (Do Not Display in Output)
Before generating the final paragraphs, follow these analytical steps:

1. First, organize all eligibility criteria into categorical groups:
   - Primary diagnosis (disease type, stage, classification)
   - Demographics (age, gender, etc.)
   - Prior treatments (medications, procedures, therapies)
   - Disease characteristics (biomarkers, metrics, etc.)
   - Performance status requirements
   - Exclusion criteria
   - Procedural requirements

2. Identify and reconcile any complementary or contradictory criteria:
   - Cross-reference inclusion with exclusion criteria on the same topics
   - Note where exclusion criteria refine inclusion criteria (e.g., \"includes non-clear cell carcinoma\" but \"excludes papillary sub-types\")
   - Resolve any apparent contradictions based on medical context
   - Combine related criteria that qualify or limit each other

3. Prioritize the most clinically relevant aspects:
   - Which criteria define the core patient population?
   - Which criteria would most commonly exclude otherwise eligible patients?
   - Which aspects would be most important for a clinician to know first?

4. Draft and refine 5 comprehensive sentences that capture the essence of the eligible patient

This analytical process should remain invisible in your final output.

## Requirements for the Patient Profile

1. Create a natural-sounding paragraph that describes who would be an ideal candidate for the study
2. Write exactly 5 sentences covering the most clinically relevant aspects of the eligibility criteria
3. Begin directly with patient characteristics (e.g., \"Adult patient with stage IV melanoma...\" rather than \"The ideal patient is...\")
4. Maintain specific medical terminology - do not simplify or summarize:
   - Keep cancer conditions with their exact staging/classification
   - Preserve medication names exactly as provided
   - Maintain specific disease terminology
   - Retain exact numeric values for age ranges, timeframes, and dosages
5. Pay careful attention to complementary inclusion/exclusion criteria:
   - When inclusion and exclusion criteria refer to the same characteristic, integrate both to create a precise description
   - Note specific subtypes that are included or excluded (e.g., \"non-clear cell carcinoma excluding papillary subtypes\")
   - Ensure the final description accurately reflects the interplay between inclusion and exclusion criteria
6. Omit laboratory test requirements (blood work, biomarkers) unless they define a primary characteristic of the patient. Omit pregnancy, lactation or contraceoption requirements unless they are critical to the study.
7. Prioritize inclusion/exclusion criteria in this order:
   - Primary diagnosis and disease state
   - Prior treatment history/requirements
   - Performance status or functional requirements
   - Key exclusion criteria that would disqualify otherwise eligible patients
8. If multiple patient profiles are eligible (e.g., different cancer types), include all distinct profiles while clearly differentiating between them
9. Create a flowing narrative rather than a list of translated criteria
10. Use appropriate medical terminology in both languages, ensuring Portuguese translations maintain clinical accuracy
11. **IMPORTANT**: When complementary inclusion/exclusion criteria exists, include them in the same sentence (e.g., \"Adult with histologically confirmed non-clear cell renal cell carcinoma (nccRCC), chromophobe, renal medullary carcinoma, or pure collecting duct histologic subtypes..\").

## Format Requirements

Return a valid JSON object with these exact properties:
```json
{{
  \"ideal_patient_english\": \"Your 5-sentence English paragraph here\",
  \"ideal_patient_portuguese\": \"Your 5-sentence Portuguese paragraph here\"
}}

The JSON must:
- Use double quotes for all keys and string values
- Contain no trailing commas or additional whitespace
- Include no additional text before or after the JSON object
- Be properly escaped where necessary
- Be validated before submission to ensure it can be parsed

Note: Do not format the JSON with single quotes as shown in the original template. Always use double quotes as shown above.

Do not include your chain-of-thought reasoning or analysis in the output. Return only the JSON object with the two patient profiles.

The study eligibility criteria are: {var_1}."

df_studies <- fromJSON('data/out_03_studies.json')

df_studies %>%
      split(1:nrow(.)) %>%
      pblapply(function(x) chatLLM(x, intruction_prompt = idealPatientPrompt, var_1 = x[['study_elegibility_criteria']])) %>%
      do.call(dplyr::bind_rows, .) %>%
      toJSON(pretty = TRUE) %>%
      write(file = 'data/out_04_studies.json')
