# Veterinary Facility Analysis in R

# Load libraries
library(readxl)
library(dplyr)
library(tidyr)
library(plotly)
library(htmlwidgets)

# Load dataset
df <- read_excel("data/Veterinary Health Facilities.xlsx")
colnames(df) <- c("District", "Hospitals", "Dispensaries", "Centres", "Total")

# Transform data to long format
df_long <- df %>%
  pivot_longer(cols = c("Hospitals", "Dispensaries", "Centres"),
               names_to = "Facility Type",
               values_to = "Count")

# 1. Stacked Bar Chart
fig1 <- df_long %>%
  plot_ly(x = ~District, y = ~Count, color = ~`Facility Type`, type = "bar") %>%
  layout(title = "Veterinary Facility Types per District", barmode = "stack")

saveWidget(fig1, "plots/stacked_facilities_per_district.html")

# 2. Horizontal Total Bar Chart
fig2 <- df %>%
  arrange(Total) %>%
  plot_ly(x = ~Total, y = ~reorder(District, Total), type = 'bar', orientation = 'h') %>%
  layout(title = "Total Veterinary Facilities by District",
         xaxis = list(title = "Total Facilities"),
         yaxis = list(title = "District"))

saveWidget(fig2, "plots/total_facilities_by_district.html")

# 3. Pie Chart for Overall Distribution
total_types <- df_long %>%
  group_by(`Facility Type`) %>%
  summarise(Total = sum(Count))

fig3 <- plot_ly(total_types, labels = ~`Facility Type`, values = ~Total, type = "pie") %>%
  layout(title = "Overall Distribution of Facility Types")

saveWidget(fig3, "plots/overall_facility_distribution.html")
