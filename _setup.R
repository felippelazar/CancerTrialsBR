# Funções usadas pelas páginas do tutorial para mostrar os dados de exemplo
invisible(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
suppressPackageStartupMessages({
  library(jsonlite)
  library(dplyr)
  library(knitr)
})

out <- function(file) fromJSON(file.path("..", "..", "R", "data", paste0(file, ".json")))

# Encurta textos longos para caber na página
clip <- function(x, n = 110) ifelse(!is.na(x) & nchar(x) > n, paste0(substr(x, 1, n), "..."), x)

show <- function(df, cols, n = 3, width = 110) {
  df %>%
    select(any_of(cols)) %>%
    head(n) %>%
    mutate(across(where(is.character), ~ clip(.x, width))) %>%
    kable()
}

gh <- function(file) paste0("https://github.com/felippelazar/CancerTrialsBR/blob/main/R/", file)
