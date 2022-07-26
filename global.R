
options(
  shiny.sanitize.errors = TRUE,
  shiny.minified = T,
  shiny.usecairo = F,
  shiny.useragg = T,
  shiny.sanitize.errors = T,
  Ncpus = 4
)

library(shiny)
library(bs4Dash)
library(ragg)
library(tidygeocoder)
library(shinyjs)
library(googlesheets4)
library(dplyr)
library(leaflet)
library(ggplot2)
library(htmltools)
library(firebase)
library(cachem)


shinyOptions(
  cache = cachem::cache_disk("./cache")
)

googlesheets4::gs4_deauth()

ss <- "1Xq1EHxq_v92RxKXFDfyZ1-_UTcsrxlPg1VQUyWeUGXo"

country_list <- readRDS("country_list.rds")
