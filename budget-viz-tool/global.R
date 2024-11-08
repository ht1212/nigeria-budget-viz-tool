#-------------------------------------------------------------------------------
# Global code for the Viz Tool  
#   Loads pacakges and data for use in the UI
#-------------------------------------------------------------------------------


# load packages-----------------------------------------------------------------
library(shiny)
library(leaflet)
library(DT)
library(plotly)
library(tidyverse)
library(leaflet.extras2)
library(shinythemes)
library(shinydashboard)
library(sf)
library(viridisLite)
library(glue)
library(billboarder)
library(treemap)
library(RColorBrewer)
#-read in usable data from national costing consultant spreadsheet--------------

# total data 
national_data_total_cost <- read.csv("working-data/national_data_total_cost.csv")
state_data_total_cost <- read.csv("working-data/state_data_total_cost.csv")
lga_data_total_cost <- read.csv("working-data/lga_data_total_cost.csv")

# intervention mix data 
intervention_mix <- read.csv("working-data/intervention_mix.csv")

# prevalence data 
prevalence_data <- read.csv("working-data/prevalence_data.csv")

# ribbon data 
national_ribbon_data <- read.csv("working-data/national_ribbon_data.csv")
state_ribbon_data <- read.csv("working-data/state_ribbon_data.csv")
lga_ribbon_data <- read.csv("working-data/lga_ribbon_data.csv")

# cost summary data (total cost)
national_total_cost_summary <- read.csv("working-data/national_total_cost_summary.csv")
state_total_cost_summary <- read.csv("working-data/state_total_cost_summary.csv")
lga_total_cost_summary <- read.csv("working-data/lga_total_cost_summary.csv")

# cost summary data (elemental)
national_intervention_chart_data <- read.csv("working-data/national_intervention_chart_data.csv")
state_intervention_chart_data <- read.csv("working-data/state_intervention_chart_data.csv")
lga_intervention_chart_data <- read.csv("working-data/lga_intervention_chart_data.csv")

# add in plan comparison data 
plan_comparison_mixes <- read.csv("plan-comparisons/viz-data/plan-comparison-mixes.csv")
plan_comparison_costs <- read.csv("plan-comparisons/viz-data/plan-comparison-costs.csv")

plan_comparison_mixes$plan <- str_to_title(plan_comparison_mixes$plan)
plan_comparison_costs$plan <- str_to_title(plan_comparison_costs$plan)

# Extract unique plans and their descriptions, excluding 'baseline'
unique_plans <- unique(plan_comparison_mixes$plan[plan_comparison_mixes$plan != "Baseline"])
plan_descriptions <- unique(plan_comparison_mixes$plan_description[plan_comparison_mixes$plan != "Baseline"])

# Combine plan and plan_description for checkbox labels
plan_labels <- paste(unique_plans, "-", plan_descriptions)

total_cost_comparisons <- 
  plan_comparison_costs |> 
  group_by(plan, plan_description, 
           currency) |> 
  summarise(full_cost = sum(total_cost, na.rm=TRUE))


#-read in other data sources----------------------------------------------------
# Shape files
country_outline <- sf::st_read("working-data/shapefiles/country_shapefile.shp")
state_outline   <- sf::st_read("working-data/shapefiles/state_shapefile.shp")
lga_outline     <- sf::st_read("working-data/shapefiles/lga_shapefile.shp")

# rmapshaper - ms_simplify() - to help shapefiles render on leaflet 

state_outline$state[which(state_outline$state == "Akwa-Ibom")] <- "Akwa Ibom"




