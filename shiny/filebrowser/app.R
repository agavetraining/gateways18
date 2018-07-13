#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(plyr)
library(rAgave)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Yet another file browsing app"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         textInput("filePath", "Path",value = Sys.getenv("AGAVE_USERNAME"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         dataTableOutput('table')
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   ag<-Agave$new(logLevel=DEBUG)
   
   output$table <- renderDataTable(ag$files$list(path=input$filePath, responseType='df'))
   
}

# Run the application 
shinyApp(ui = ui, server = server)

