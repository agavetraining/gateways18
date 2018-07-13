## --------
## server.R
## --------

library(rio)
library(shiny)
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
      ag<-Agave$new(logLevel=DEBUG)
      
      output$table <- renderDataTable(ag$files$list(path=input$filePath, responseType='df'))
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
