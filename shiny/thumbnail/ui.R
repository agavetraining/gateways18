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
shinyUI(fluidPage(sidebarLayout(
  
  # Application title
  sidebarPanel(
    textInput("filePath", "Path", value = "dooley/microsites/web/assets/layouts/compute/img/tenants/agave.prod.png"),#Sys.getenv("AGAVE_USERNAME")), 
    
    # Input: Numeric entry for thumbnail width ----
    numericInput(inputId = "width",
                 label = "Thumbnail width:",
                 value = 72), 
    
    # Input: Numeric entry for thumbnail height ----
    numericInput(inputId = "height",
                 label = "Thumbnail height:",
                 value = 72)
  ),
  
  mainPanel(
    titlePanel("Yet another thumbnail service"),
    verbatimTextOutput("message"),
    imageOutput("thumbnailImage"),
    imageOutput("fullImage"),
    h4(textOutput("caption", container = span))
  )
  
)))