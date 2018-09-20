#
# This is Yet Another File Browser implemented as a Shiny web application.
# The app uses the Agave Platform's R SDK to obtain directory listings
# and a DataTable to display the result.
#

library(shiny)
library(httr)
library(plyr)
library(rAgave)

# Define UI for application that generates a DataTable with remote file
# listing data.
ui <- fluidPage(
   
   # Application title
   titlePanel("Yet another file browsing app"),
   
   # Sidebar with a text box allowing users to provide a path
   # on the app's default storage system to list.
   sidebarLayout(
      sidebarPanel(
         textInput("filePath", "Path",value = Sys.getenv("AGAVE_USERNAME"))
      ),
      
      # Display the file listing returned from the server in a
      # data table.
      mainPanel(
         dataTableOutput('table')
      )
   )
)

# Define server logic required to authenticate and fetch a
# remote directory listing for display in the UI.
server <- function(input, output) {
   # Requests are stateless, so we initialize the Agave object here.
   # Logging is enabled so we can feed this app's logs into our
   # gateway's logging solution.
   #
   # The SDK handles token refresh for us, so we can focus on what
   # we need to do for our application.
   ag<-Agave$new(logLevel=DEBUG)

   # Here we list the remote file path and return the result to the UI
   output$table <- renderDataTable(ag$files$list(path=input$filePath, responseType='df'))
   
}

# Run the application 
shinyApp(ui = ui, server = server)

