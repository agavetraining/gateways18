# --------
# server.R
#
# This is the server component of a data transformation app implemented
# in R with the Shiny framework. The app uses the Agave Platform's R SDK
# list and fetch remote data, then uses the `rio` library to convert the
# data into another format.
#
# --------

library(rio)
library(plumber)
library(tools)
library(foreign)
library(httr)
library(plyr)
library(rAgave)

make_sas_csv <- function(x, file, filesnames){
    csv_file <- paste0(filesnames, '.csv')
    sas_file <- paste0(filesnames, '.sas')
    foreign::write.foreign(df = x,
                           datafile = csv_file,
                           codefile = sas_file,
                           package = 'SAS')
    zip(zipfile = file, files = c(csv_file, sas_file))
}

shinyServer(
  function(input, output){

      # Requests are stateless, so we initialize the Agave object here.
      # Logging is enabled so we can feed this app's logs into our
      # gateway's logging solution.
      #
      # The SDK handles token refresh for us, so we can focus on what
      # we need to do for our application.
      ag<-Agave$new(logLevel=DEBUG)

      # List the remote path and send the resutls to the UI for
      # rendering in the DataTable
      output$table <- renderDataTable(ag$files$list(path=input$filePath, responseType='df'))

      # When the download button is clicked, fetch the file, convert,
      # and stream to the user.
      output$download_data <- downloadHandler(
            filename = function() {
                name <- basename(file_path_sans_ext(input$filePath))
                paste0(name, '.', {
                    ## handle sas double format
                    if ('sas_plus_csv' == input$output_format) 'zip'
                    else input$output_format
                })
            },
            content = function(file) {
                localPath = ag$files$download(path=input$filePath)
                input_file_format <- tools::file_ext(basename(input$filePath))
                if (is.null(localPath))
                    return(NULL)
                else {
                    db <- rio::import(file = localPath,
                                      format = input_file_format)
                    if ('sas_plus_csv' != input$output_format)
                        rio::export(x = db,
                                    file = file,
                                    format = input$output_format)
                    else make_sas_csv(x = db,
                                      file = file,
                                      filesnames = basename(file_path_sans_ext(input$filePath)))
                }
            }
        )
    }
)
