#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    h1("How R you feeling today?"),
    sidebarPanel(pickerInput("name","Person", choices=unique(fakedata$Name),
                             selected = unique(fakedata$Name),
                             options = list(`actions-box` = TRUE),multiple = T)),
    mainPanel(plotOutput("distPlot"))
))
