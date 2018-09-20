# -----
# ui.R
#
# This is the UI component of a data transformation app implemented
# in R with the Shiny framework. The UI features a sidebar layout
# containing a text box to select a remote path and a select box
# to choose a target file format. The body contains a file listing
# with the contents of the remote folder specified in the sidebar,
# and a select button to choose select the file for conversion.
# Once the download button is clicked, the file is fetched, converted
# locally, and downloaded to the users' browser.
#
# -----

library(shiny)
library(markdown)

available_formats <- c(
    'Comma separated'   = 'csv',
    'Excel (>=2007)'    = 'xlsx',
    'JSON'              = 'json',
    'R'                 = 'rds',
    'SAS (sas7bdat)'    = 'sas7bdat',
    'SAS (.csv + .sas)' = 'sas_plus_csv',
    'SPSS'              = 'sav',
    'Stata'             = 'dta',
    'Tab separated'     = 'tsv'
)

shinyUI(fluidPage(sidebarLayout(

  # Application title
  sidebarPanel(
      textInput("filePath", "Path", value = Sys.getenv("AGAVE_USERNAME")), 
      selectInput('output_format',
                   label = h3('Output format'), 
                   choices = available_formats,
                   selectize = FALSE,
                   size = length(available_formats)),
     downloadButton('download_data', 'Download')
   ),
                 
    mainPanel(
      titlePanel("Yet another file browsing app"),
      
      dataTableOutput('table')
      
    )

)))
