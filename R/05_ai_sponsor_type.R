# ================================================================================= #
# 5. Classifying the Study Lead Sponsor Type (English and Portuguese)               #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

# Prompt
newSponsorClassificationPrompt <- '# Clinical Trial Sponsor Type Classification

## CRITICAL INSTRUCTION
**OUTPUT REQUIREMENT**: Respond ONLY with valid JSON. No explanatory text, introductions, conclusions, or formatting outside the JSON structure.

## Your Role
You are a clinical trials operations specialist classifying the lead sponsor of a clinical trial into one of four standardized sponsor types, using the sponsor name, trial title, and NCT ID as context.

## Sponsor Type Categories

- **Cooperative Group**: Multi-institutional research networks/consortia that coordinate trials across many sites (e.g., NRG Oncology, SWOG, Alliance for Clinical Trials in Oncology, ECOG-ACRIN, Children\'s Oncology Group, EORTC).
- **Government**: National or governmental health/research bodies and their institutes (e.g., National Cancer Institute, NIH, VA, Department of Defense, national ministries of health, government-run public health agencies).
- **Pharmaceutical Industry/Biotech**: For-profit pharmaceutical, biotechnology, or medical device companies sponsoring the trial (e.g., Pfizer, Roche, Genentech, small/mid-size biotech companies).
- **Research Facility**: Individual academic medical centers, universities, hospitals, or cancer centers sponsoring their own investigator-initiated trial (e.g., MD Anderson Cancer Center, Mayo Clinic, a university hospital).

## Analysis Framework

### Step 1: Identify the Sponsor
- Extract the exact sponsor name provided (study_lead_sponsor_name)
- Use the trial title and NCT ID only as supporting context (e.g., to disambiguate similarly-named sponsors or confirm institutional affiliation); do not infer sponsor type from disease area alone

### Step 2: Classify
- Match the sponsor name against known organizational patterns:
  - Consortium/group/network names spanning multiple institutions → Cooperative Group
  - National institutes, agencies, ministries, military/veterans health bodies → Government
  - Company names (Inc., Ltd., Pharmaceuticals, Biotech, Therapeutics, GmbH, S.A., etc.) → Pharmaceutical Industry/Biotech
  - Named hospitals, universities, cancer centers, academic medical centers → Research Facility
- If the sponsor name is ambiguous or unfamiliar, choose the single most probable category based on naming conventions and any contextual clues in the trial title; never leave the classification blank

### Step 3: Translate
- Provide the exact same classification translated into Portuguese (Brazil), using the standard terms:
  - Cooperative Group → "Grupo Cooperativo"
  - Government → "Governo"
  - Pharmaceutical Industry/Biotech → "Indústria Farmacêutica/Biotecnologia"
  - Research Facility → "Instituição de Pesquisa/Hospital"

## Required JSON Output

```json
{{
  "study_ai_lead_sponsor_type": "Cooperative Group | Government | Pharmaceutical Industry/Biotech | Research Facility",
  "study_ai_lead_sponsor_type_portuguese": "Grupo Cooperativo | Governo | Indústria Farmacêutica/Biotecnologia | Instituição de Pesquisa/Hospital"
}}
```

## Quality Checklist
- [ ] Exactly one category selected (no multi-labeling)
- [ ] Classification based on sponsor organizational type, not disease/trial subject matter
- [ ] Portuguese term exactly matches the English classification via the mapping above
- [ ] No ambiguity left unresolved — a best-guess classification is always returned

---

## CLASSIFY THIS TRIAL SPONSOR:

**NCT ID**: {var_1}
**Trial Title**: {var_2}
**Lead Sponsor Name**: {var_3}

**RETURN ONLY JSON - NO OTHER TEXT**'

df_studies <- fromJSON('data/out_04_studies.json')

df_studies %>%
      split(1:nrow(.)) %>%
      pblapply(function(x) chatLLM(x, intruction_prompt = newSponsorClassificationPrompt, var_1 = x[['study_nct_id']], var_2 = x[['study_brief_title']], var_3 = x[['study_lead_sponsor_name']])) %>%
      do.call(dplyr::bind_rows, .) %>%
      toJSON(pretty = TRUE) %>%
      write(file = 'data/out_05_studies.json')
