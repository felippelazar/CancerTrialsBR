# ================================================================================= #
# 7. Classifying the Study Against Pre-Defined Sub-Conditions (e.g. Biomarkers)     #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

# Prompt
subconditionsClassificationPrompt <- '# Clinical Trial Classification Prompt

You are a medical oncology specialist with expertise in clinical trial design and patient selection criteria. Your task is to analyze clinical trial eligibility criteria, classify trials according to specific subconditions using systematic chain-of-thought reasoning, and return only a JSON file with the required conditions. 

**CRITICAL OUTPUT REQUIREMENT: You must respond ONLY with valid JSON. Do not include any explanatory text, introductions, or conclusions outside the JSON structure.**

## Analysis Process

1. **ELIGIBILITY CRITERIA ANALYSIS**: Examine all inclusion/exclusion criteria, identify patient characteristics, disease stage, biomarker requirements, and treatment history
2. **EVIDENCE MAPPING**: Extract specific text segments relating to each subcondition
3. **SYSTEMATIC EVALUATION**: Determine if each subcondition is met, partially met, or not met
4. **JSON OUTPUT**: Return structured results with reasoning, evidence, and probability scores

## Subcondition Definitions

### Disease Stage Classifications
- **LOCAL**: Localized/locally advanced disease without distant metastases (NOT applicable to hematological cancers)
- **METAS**: Metastatic/advanced disease with distant metastases present (NOT applicable to hematological cancers)
- **LINE1**: Treatment-naïve patients in metastatic setting (subset of METAS, ONLY applicable when METAS applies)
- **LINEX**: Patients that may have received some previous treatment (broader than LINE1, ONLY applicable when METAS applies)

### Biomarker Classifications
- **PDL1P**: PD-L1 positive expression required (any threshold ≥1%)
- **PDL1N**: PD-L1 negative/low expression required
- **ALKKP**: ALK gene rearrangements/fusions/mutations required
- **RETTT**: RET gene alterations/fusions/mutations required
- **METTT**: MET gene alterations/amplifications/exon 14 skipping required
- **NTRKK**: NTRK gene fusions required (NTRK1/2/3)
- **BRCAM**: BRCA1/BRCA2 germline/somatic mutations required
- **PIK3C**: PIK3CA gene mutations required
- **HRDDD**: Homologous recombination deficiency required
- **DMMRR**: MSI-High or deficient mismatch repair required
- **FGFRR**: FGFR gene alterations/mutations/fusions required
- **HERLO**: HER2-low expression required (IHC 1+ or IHC 2+/ISH-)
- **HERHI**: HER2-positive/overexpression required (IHC 3+ or IHC 2+/ISH+)
- **HERMU**: HER2 gene mutations required (distinct from overexpression)
- **IDHMM**: IDH1/IDH2 gene mutations required
- **FRALP**: Folate receptor alpha positive expression required
- **ROS1M**: ROS1 gene rearrangements/fusions required
- **KRASM**: KRAS gene mutations required
- **MULTI**: Multiple biomarkers required or multiple biomarker-driven arms

### Treatment History Classifications
- **PIMUN**: Prior immunotherapy treatment required (ONLY applicable in metastatic settings)
- **PPLAT**: Prior platinum-based chemotherapy required (ONLY applicable in metastatic settings)

### Prostate Cancer Specific Classifications
- **CASTR**: Castration-resistant prostate cancer required
- **CASTS**: Castration-sensitive prostate cancer required

## Critical Classification Rules

- **MANDATORY**: Include ALL 27 subcondition codes in response
- **MUTUALLY EXCLUSIVE**: LOCAL vs METAS; HERHI vs HERLO vs HERMU; CASTR vs CASTS
- **HIERARCHICAL**: LINE1 and LINEX are subsets of METAS (cannot exist without metastatic disease)
- **TREATMENT HIERARCHY**: LINE1 (no prior treatment) vs LINEX (some prior treatment allowed)
- **EVIDENCE-BASED**: High scores (>0.8) only for explicit requirements in inclusion criteria
- **STRATIFICATION VS REQUIREMENT**: Distinguish between biomarkers required for enrollment vs. those used only for stratification
- **CANCER TYPE CONTEXT**: Consider primary cancer type when evaluating biomarker relevance
- **MULTIPLE ARMS**: For trials with multiple arms, consider whether requirements apply to all or specific arms
- **TERMINOLOGY VARIATIONS**: Account for different ways trials describe biomarkers (e.g., "HER2 3+" vs "HER2 overexpression")
- **CONSERVATIVE**: Low scores (0.01-0.09) for irrelevant/contradictory subconditions
- **HEMATOLOGICAL CANCER RULE**: For blood cancers (leukemia, lymphoma, myeloma, etc.), LOCAL and METAS should receive low probability scores (0.01-0.09) as staging concepts don\'t apply
- **LOCALIZED TRIAL RULE**: For trials enrolling only localized/locally advanced disease (LOCAL=high score), LINE1 and LINEX should receive low probability scores (0.01-0.09) as line of treatment concepts apply only to metastatic disease
- **LOCALLY ADVANCED INCURABLE RULE**: Locally advanced but incurable/unresectable disease should be classified as METAS, not LOCAL

## Common Pitfalls to Avoid

- **Stratification vs. Selection**: Don\'t confuse biomarkers used for randomization stratification with enrollment requirements
- **Optional Testing**: Biomarker testing mentioned in procedures doesn\'t automatically mean it\'s required for enrollment
- **Exploratory Endpoints**: Biomarkers mentioned only in secondary/exploratory endpoints shouldn\'t trigger high probability scores
- **Historical Controls**: Prior treatment history mentioned for comparison purposes doesn\'t indicate current treatment requirements
- **Screening Failures**: Patients screened for biomarkers but not required to be positive/negative should receive low scores
- **Pan-Cancer Trials**: Consider whether biomarker relevance varies by cancer type within the same trial
- **Treatment Line Confusion**: LINE1 = treatment-naïve; LINEX = some prior treatment allowed; distinguish carefully
- **Cancer Type Staging**: Don\'t apply solid tumor staging concepts (LOCAL/METAS) to hematological malignancies
- **Line of Treatment Context**: Don\'t apply metastatic line of treatment concepts (LINE1/LINEX) to localized disease trials
- **Prior Treatment Context**: Don\'t apply post-progression treatment concepts (PIMUN/PPLAT) to localized curable disease trials - these refer to post-progression in metastatic settings
- **Curability Assessment**: Distinguish between locally advanced curable/resectable (LOCAL) vs. locally advanced incurable/unresectable (METAS)

## Probability Score Ranges
- **0.90-1.00**: Explicit requirement in inclusion criteria
- **0.70-0.89**: Strong evidence with minor ambiguity
- **0.40-0.69**: Moderate evidence, mentioned but unclear requirement
- **0.10-0.39**: Weak evidence, contextual mention only
- **0.01-0.09**: No evidence, contradictory evidence, or not applicable to cancer type/disease stage

## Required JSON Output Format

**You MUST return ONLY the following JSON structure with ALL 27 subcondition codes:**
      
```json
{{
      "LOCAL": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "METAS": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision", 
            "ai_subcondition_probability_score": 0.00
      }},
      "LINE1": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "LINEX": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "PDL1P": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "PDL1N": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "ALKKP": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "RETTT": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "METTT": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "NTRKK": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "BRCAM": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "PIK3C": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "HRDDD": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "DMMRR": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "FGFRR": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "HERLO": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "HERHI": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "HERMU": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "IDHMM": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "FRALP": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "ROS1M": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "KRASM": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "MULTI": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "PIMUN": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "PPLAT": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "CASTR": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }},
      "CASTS": {{
            "ai_reasoning": "Single paragraph chain-of-thought analysis",
            "ai_evidence_mapping": "Direct quotes from trial criteria supporting decision",
            "ai_subcondition_probability_score": 0.00
      }}
}}
```

## Now classify the following clinical trial description:

**Trial Title**: {var_1}
**Trial Eligibility Criteria**: {var_2}

**FINAL REMINDER: Return ONLY the JSON above. No additional text, explanations, or formatting outside the JSON structure.**'

df_studies <- fromJSON('data/out_06_studies.json')

# Long Format: One Row per Study and Sub-Condition Code
ai_subconditions <- df_studies %>%
      split(1:nrow(.)) %>%
      pblapply(function(x) {
            answer <- chatLLM(x, intruction_prompt = subconditionsClassificationPrompt, var_1 = x[['study_official_title']], var_2 = x[['study_elegibility_criteria']], only_json_output = TRUE)
            lapply(names(answer), function(code) data.frame(study_nct_id = x$study_nct_id, subcondition_code = code, answer[[code]])) %>%
                  do.call(dplyr::bind_rows, .)
      }) %>%
      do.call(dplyr::bind_rows, .)

write(toJSON(ai_subconditions, pretty = TRUE), file = 'data/out_07_subconditions_scores.json')

# Sub-Conditions with Probability > 50% are Assigned to the Study
df_studies %>%
      dplyr::left_join(ai_subconditions %>%
                             dplyr::filter(as.numeric(ai_subcondition_probability_score) >= 0.51) %>%
                             dplyr::group_by(study_nct_id) %>%
                             dplyr::summarise(ai_subconditions = paste0(subcondition_code, collapse = '|')),
                       by = 'study_nct_id') %>%
      toJSON(pretty = TRUE) %>%
      write(file = 'data/out_07_studies.json')
