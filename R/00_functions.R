# ================================================================================= #
# 0. Shared Functions for the Supplementary Code Snippets                           #
# Author: Felippe Lazar, Universidade de Sao Paulo, 2026                            #
# ================================================================================= #

# Loading Required Packages
library(httr)
library(jsonlite)
library(dplyr)
library(glue)
library(pbapply)
library(ellmer)

# Loading API Keys and LLM Model from .Renviron (see .Renviron in this folder)
if(file.exists('.Renviron')) readRenviron('.Renviron')

if(!dir.exists('data')) dir.create('data')

# Creating the Function to Iterate From any LLM Provider (via ellmer, see LLM_MODEL)
# Prompts use {var_1}, {var_2}, {var_3} as placeholders and {{ }} for literal braces
chatLLM <- function(data_info, intruction_prompt, var_1 = NULL, var_2 = NULL, var_3 = NULL,
                    llm_model = Sys.getenv("LLM_MODEL", "openai/gpt-4.1-2025-04-14"), json_output = TRUE, only_json_output = FALSE, max_calls = 5,
                    print_output = FALSE){

      # Creating Failure Counter
      aiFailed <- TRUE
      count_fail <- 0

      # Setting Prompt Instruction
      instructionLLM <- glue(intruction_prompt)

      while(aiFailed){

            answerLLM <- tryCatch({
                  chat(llm_model, params = params(temperature = 0))$chat(instructionLLM, echo = 'none')
            }, error = function(cond) NULL)

            if(print_output) print(answerLLM)
            if (json_output && !is.null(answerLLM)) {
                  clean_json <- gsub("(^```json|```$)", "", trimws(answerLLM))
                  answerLLM <- tryCatch(jsonlite::fromJSON(clean_json, simplifyVector = TRUE),
                                        error = function(e) {
                                              message("JSON parsing failed: ", e$message)
                                              return(NULL)
                                        })
            }

            if(!is.null(answerLLM) | count_fail == max_calls) {

                  aiFailed <- FALSE

            } else {

                  print(glue('Error While Chatting/Parsing with LLM'))
                  Sys.sleep(1)
                  count_fail <- count_fail + 1
            }

      }

      if (!is.null(answerLLM)) {
            if (only_json_output == TRUE) {
                  return(answerLLM)
            } else {
                  return(cbind(data_info, answerLLM))
            }
      } else {
            return(data_info)
      }

}
