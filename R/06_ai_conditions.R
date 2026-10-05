# ================================================================================= #
# 6. Classifying the Study Against Pre-Defined Cancer Diagnosis                     #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

source('00_functions.R')

# Prompt
newConditionsClassificationPrompt <- '# Clinical Trial Cancer Condition Classification System

## CRITICAL INSTRUCTION
**OUTPUT REQUIREMENT**: Respond ONLY with valid JSON. No explanatory text, introductions, conclusions, or formatting outside the JSON structure.

## Your Role
You are a medical oncology specialist analyzing clinical trial eligibility criteria to classify trials by cancer conditions using systematic reasoning.

## Task Overview
1. Analyze eligibility criteria for disease sites, histology, molecular subtypes
2. Map evidence from criteria to cancer conditions  
3. Score probability for each condition (0.01-1.00)
4. Return structured JSON with reasoning and evidence

## Cancer Condition Codes Reference

### Solid Tumors - Gastrointestinal
- **GASTC**: Gastric Cancer (stomach cancer)
- **COLRC**: Colorectal Cancer  
- **PANCR**: Pancreatic Cancer
- **HEPCC**: Hepatocellular Carcinoma
- **BTCCC**: Biliary Tract Cancer (bile duct, gallbladder)
- **ESOPC**: Esophageal Cancer
- **ANALC**: Anal Cancer

### Solid Tumors - Thoracic
- **SCLCC**: Small Cell Lung Cancer
- **NSCLC**: Non-Small Cell Lung Cancer  
- **LEGFR**: EGFR-mutated Lung Cancer

### Solid Tumors - Genitourinary
- **RECAL**: Renal Cancer (kidney cancer)
- **PROSC**: Prostate Cancer
- **BLADC**: Bladder Cancer

### Solid Tumors - Breast
- **BREAC**: Breast Cancer (general)
- **BTNBC**: Triple-Negative Breast Cancer
- **BRHRP**: Hormone Receptor-Positive Breast Cancer
- **BHER2**: HER2-Positive Breast Cancer

### Solid Tumors - Gynecological
- **OVARC**: Ovarian Cancer
- **ENDOC**: Endometrial Cancer  
- **CERVC**: Cervical Cancer
- **GYNCN**: Other Gynecological Cancers (vulvar, vaginal, fallopian tube, primary peritoneal - NOT ovarian, endometrial, or cervical)

### Solid Tumors - Other Sites
- **BRATU**: Brain Tumors
- **HEANC**: Head and Neck Cancer
- **THYRC**: Thyroid Cancer
- **MELAN**: Melanoma
- **CUTNM**: Cutaneous Non-Melanoma
- **SALGT**: Salivary Gland Tumors
- **NEUTU**: Neuroendocrine Tumors

### Sarcomas
- **SFTTS**: Soft Tissue Sarcoma
- **OSTES**: Osteosarcoma (bone sarcoma)
- **GISTT**: Gastrointestinal Stromal Tumor
- **DESMO**: Desmoid Tumor

### Hematological Malignancies  
- **LEUKE**: Leukemia
- **LYMPH**: Lymphoma
- **MYELO**: Multiple Myeloma
- **OTHHT**: Other Hematological Tumors

### Broad Categories
- **OTHSO**: Other Solid Tumors (specific but unlisted)
- **NTUMD**: Non-Tumor Diagnosis (ONLY for non-cancer trials - benign conditions, prevention studies)
- **ANYCA**: Pan-Cancer/Basket Trials (multiple cancer types WITHOUT specific histological requirements)

## Analysis Framework

### Step 1: Extract Key Information
- Primary cancer types mentioned in inclusion criteria
- Molecular subtypes or biomarkers required
- Histological specifications  
- Any exclusion criteria for cancer types

### Step 2: Map Evidence
- Quote exact phrases supporting each classification
- Note section of criteria (inclusion vs exclusion)
- Identify ambiguous language requiring interpretation

### Step 3: Apply Scoring Logic - Updated

#### Phase 1: Biomarker Detection and Evidence Assessment
- **SCAN FOR BIOMARKERS**: Systematically check eligibility criteria for specific biomarkers (EGFR, KRAS G12C, HER2, PD-L1, BRCA1/2, ALK, ROS1, NTRK, PIK3CA, etc.)
- **ASSESS EVIDENCE STRENGTH**: Determine if biomarkers are explicitly required, excluded, or mentioned contextually
- **IDENTIFY CANCER TYPE**: Extract primary cancer type(s) mentioned in inclusion criteria

#### Phase 2: Category Assignment Logic
- **IF BIOMARKERS ARE EXPLICITLY REQUIRED**:
  1. Search for exact biomarker-specific category in the classification system
  2. **IF SPECIFIC CATEGORY EXISTS**: Score biomarker category high (0.90+), related general category moderate (0.40-0.69)
  3. **IF SPECIFIC CATEGORY MISSING**: Score the most closely related general category high (0.90+) and note in reasoning that specific biomarker is mentioned but no dedicated category exists
  
- **IF NO BIOMARKERS MENTIONED**:
  1. Score the most specific applicable general category high (0.90+)
  2. Score broader categories that would include this population moderately (0.70+)
  
- **IF BIOMARKERS ARE EXCLUDED**:
  1. Score biomarker-specific categories very low (0.01-0.05)
  2. Score general categories high (0.90+) as they represent the biomarker-negative population

#### Phase 3: Fallback and Validation
- **APPLY MAXIMUM INCLUSION PRINCIPLE**: Score ALL categories that could reasonably include eligible patients
- **HANDLE MISSING CATEGORIES**: When specific biomarker/histology combinations aren\'t in the classification system, default to the most general applicable category that would capture these patients
- **VALIDATE AGAINST EXCLUSIONS**: Ensure explicitly excluded conditions score 0.01-0.05
- **CONSISTENCY CHECK**: Verify at least one category scores ≥0.70 to ensure trial eligibility is captured

#### Examples of Improved Logic:
- **"KRAS G12C mutated NSCLC"** → NSCLC: 0.95 (no KRAS-specific category exists),  other lung categories: 0.05
- **"NSCLC with any biomarker"** → NSCLC: 0.95, LEGFR: 0.80 (included)
- **"EGFR wild-type NSCLC"** → NSCLC: 0.95, LEGFR: 0.01 (excluded)
- **"Triple-negative breast cancer"** → BTNBC: 0.95, BREAC: 0.50, other breast subtypes: 0.05

### Hierarchy & Specificity - UPDATED RULES
- **MAXIMUM INCLUSION PRINCIPLE**: Score ALL categories that maximize patient inclusion probability
- **GENERAL CANCER TRIALS**: When no biomarkers are mentioned, score the most specific applicable general category high
- **EXPLICIT EXCLUSION**: When categories are explicitly excluded, score 0.01-0.05
- **EXCLUSIVE SUBTYPE SCENARIOS**: Score ONLY the specific subtype when the trial is restricted to that subtype alone
- **INCLUSIVE SUBTYPE SCENARIOS**: Score BOTH specific and general when the trial includes the subtype PLUS other subtypes
- **GENERAL CATEGORY SCORING**: Score general categories high when:
  - Multiple subtypes are explicitly allowed
  - General term used without subtype restrictions
  - Trial states "all subtypes" or "any histology"
- **SPECIFICITY HIERARCHY**: Always prefer the most specific available category, but include broader categories when they also apply
- **GYNCN Specificity**: Use GYNCN only for gynecological cancers NOT covered by OVARC, ENDOC, or CERVC (e.g., vulvar, vaginal, fallopian tube, primary peritoneal)

### Evidence Requirements
- **Explicit Inclusion (0.90-1.00)**: Direct statement in inclusion criteria
- **Strong Evidence (0.70-0.89)**: Clear indication with minor ambiguity  
- **Moderate Evidence (0.40-0.69)**: Mentioned but unclear requirement
- **Weak Evidence (0.10-0.39)**: Contextual mention only
- **No Evidence (0.01-0.09)**: Not mentioned, contradictory, or excluded

### Special Cases
- **Multi-Tumor Trials**: Use ANYCA ONLY when multiple cancer types are listed WITHOUT specific histological requirements
- **Generic Terms**: "Solid tumors" or "advanced cancers" without histology → score specific conditions based on available context and evidence
- **Non-Cancer Trials**: Use NTUMD ONLY for prevention studies, benign conditions, or non-oncological trials
- **Breast vs Gynecological**: Breast cancers are separate from gynecological cancers
- **GYNCN Usage**: Only for gynecological cancers not covered by the three specific codes (OVARC, ENDOC, CERVC)
- **Inclusion vs Exclusion**: Distinguish between trials that include a subtype exclusively vs. trials that include a subtype among others
- **Maximum Coverage**: When in doubt, score categories that maximize patient inclusion probability
- **Multiple Arms**: Consider if eligibility applies to all arms or specific cohorts
- **Terminology Variants**: Account for synonyms (stomach=gastric, kidney=renal)
- **Exclusions**: Explicitly excluded conditions score 0.01-0.05

## Required JSON Output

```json
{{
  "GASTC": {{
    "ai_reasoning": "Analysis of whether gastric cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "RECAL": {{
    "ai_reasoning": "Analysis of whether renal cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "SCLCC": {{
    "ai_reasoning": "Analysis of whether small cell lung cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "NSCLC": {{
    "ai_reasoning": "Analysis of whether non-small cell lung cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "LEGFR": {{
    "ai_reasoning": "Analysis of whether EGFR-mutated lung cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "THYRC": {{
    "ai_reasoning": "Analysis of whether thyroid cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "BREAC": {{
    "ai_reasoning": "Analysis of whether breast cancer (general) is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "BTNBC": {{
    "ai_reasoning": "Analysis of whether triple-negative breast cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "BRHRP": {{
    "ai_reasoning": "Analysis of whether hormone receptor-positive breast cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "BHER2": {{
    "ai_reasoning": "Analysis of whether HER2-positive breast cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "PROSC": {{
    "ai_reasoning": "Analysis of whether prostate cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "BRATU": {{
    "ai_reasoning": "Analysis of whether brain tumors are eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "COLRC": {{
    "ai_reasoning": "Analysis of whether colorectal cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "PANCR": {{
    "ai_reasoning": "Analysis of whether pancreatic cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "HEANC": {{
    "ai_reasoning": "Analysis of whether head and neck cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "OVARC": {{
    "ai_reasoning": "Analysis of whether ovarian cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "ENDOC": {{
    "ai_reasoning": "Analysis of whether endometrial cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "CERVC": {{
    "ai_reasoning": "Analysis of whether cervical cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "HEPCC": {{
    "ai_reasoning": "Analysis of whether hepatocellular carcinoma is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "BTCCC": {{
    "ai_reasoning": "Analysis of whether biliary tract cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "BLADC": {{
    "ai_reasoning": "Analysis of whether bladder cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "GYNCN": {{
    "ai_reasoning": "Analysis of whether other gynecological cancers (vulvar, vaginal, fallopian tube, primary peritoneal - NOT ovarian, endometrial, or cervical) are eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "SFTTS": {{
    "ai_reasoning": "Analysis of whether soft tissue sarcoma is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "OSTES": {{
    "ai_reasoning": "Analysis of whether osteosarcoma is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "GISTT": {{
    "ai_reasoning": "Analysis of whether gastrointestinal stromal tumor is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "DESMO": {{
    "ai_reasoning": "Analysis of whether desmoid tumor is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "MELAN": {{
    "ai_reasoning": "Analysis of whether melanoma is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "CUTNM": {{
    "ai_reasoning": "Analysis of whether cutaneous non-melanoma is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "ANALC": {{
    "ai_reasoning": "Analysis of whether anal cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "ESOPC": {{
    "ai_reasoning": "Analysis of whether esophageal cancer is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "SALGT": {{
    "ai_reasoning": "Analysis of whether salivary gland tumors are eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "NEUTU": {{
    "ai_reasoning": "Analysis of whether neuroendocrine tumors are eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "LEUKE": {{
    "ai_reasoning": "Analysis of whether leukemia is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "LYMPH": {{
    "ai_reasoning": "Analysis of whether lymphoma is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "MYELO": {{
    "ai_reasoning": "Analysis of whether multiple myeloma is eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "OTHHT": {{
    "ai_reasoning": "Analysis of whether other hematological tumors are eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "OTHSO": {{
    "ai_reasoning": "Analysis of whether other solid tumors are eligible based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "NTUMD": {{
    "ai_reasoning": "Analysis of whether this trial involves non-tumor diagnoses (ONLY for non-cancer trials like prevention studies or benign conditions) based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }},
  "ANYCA": {{
    "ai_reasoning": "Analysis of whether this is a pan-cancer or basket trial with multiple cancer types WITHOUT specific histological requirements based on trial criteria, considering hierarchy and specificity rules",
    "ai_evidence_mapping": "Direct quotes or paraphrased segments from eligibility criteria supporting this classification", 
    "ai_condition_probability_score": 0.00
  }}
}}
```

## Quality Checklist
- [ ] All 39 condition codes included
- [ ] Reasoning addresses **MAXIMUM INCLUSION PRINCIPLE**
- [ ] Evidence mapping includes specific quotes/references
- [ ] Probability scores align with evidence strength
- [ ] Both specific and general categories scored when trial is inclusive
- [ ] Only specific categories scored when trial is exclusive to subtype
- [ ] ANYCA used only for multi-tumor trials WITHOUT histological specificity
- [ ] NTUMD used only for non-cancer trials
- [ ] Exclusions properly handled with low scores

---

## ANALYZE THIS TRIAL:

**Trial Title**: {var_1}
**Trial Eligibility Criteria**: {var_2}

**RETURN ONLY JSON - NO OTHER TEXT**'

df_studies <- fromJSON('data/out_05_studies.json')

# Long Format: One Row per Study and Condition Code
ai_conditions <- df_studies %>%
      split(1:nrow(.)) %>%
      pblapply(function(x) {
            answer <- chatLLM(x, intruction_prompt = newConditionsClassificationPrompt, var_1 = x[['study_official_title']], var_2 = x[['study_elegibility_criteria']], only_json_output = TRUE)
            lapply(names(answer), function(code) data.frame(study_nct_id = x$study_nct_id, condition_code = code, answer[[code]])) %>%
                  do.call(dplyr::bind_rows, .)
      }) %>%
      do.call(dplyr::bind_rows, .)

write(toJSON(ai_conditions, pretty = TRUE), file = 'data/out_06_conditions_scores.json')

# Conditions with Probability >= 80% are Assigned to the Study
df_studies %>%
      dplyr::left_join(ai_conditions %>%
                             dplyr::filter(as.numeric(ai_condition_probability_score) >= 0.80) %>%
                             dplyr::group_by(study_nct_id) %>%
                             dplyr::summarise(ai_conditions = paste0(condition_code, collapse = '|')),
                       by = 'study_nct_id') %>%
      toJSON(pretty = TRUE) %>%
      write(file = 'data/out_06_studies.json')
