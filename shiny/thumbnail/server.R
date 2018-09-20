#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(png)
library(jpeg)
library(tiff)
library(tools)
library(foreign)
library(httr)
library(plyr)
library(rAgave)
library(OpenImageR)

set_config( config( ssl_verifypeer = 0L ) )

shinyServer(
  function(input, output, session) {
  
    # Requests are stateless, so we initialize the Agave object here.
    # Logging is enabled so we can feed this app's logs into our
    # gateway's logging solution.
    #
    # The SDK handles token refresh for us, so we can focus on what
    # we need to do for our application.
    ag<-Agave$new(logLevel=DEBUG)
    
    # List the remote path and send the resutls to the UI for
    # rendering in the DataTable
    #output$table <- renderDataTable(ag$files$list(path=input$filePath, responseType='df'))
    
    output$caption <- renderText({
      tools::file_ext(basename(input$filePath))
    })
    
    # A dynamically generated thumbnail
    output$thumbnailImage <- renderImage({
      remoteFileExtension <- tools::file_ext(basename(input$filePath))
      if (remoteFileExtension != '') {
        
        # download the remote file
        localPath <- ag$files$download(path=input$filePath, overwrite=TRUE)
        
        # get image extension to determine how to generate the thumbnail
        input_file_format <- tools::file_ext(basename(localPath))
        
        # create a temp file for the thumbnail. This will be deleted by
        # renderImage after serving
        outfile <- tempfile(fileext = paste0('.',input_file_format))
        output$message <- renderText({
            str(outfile)
        })
        
        output$fullImage <- renderImage({
          
          # Return a list containing the filename
          list(src = localPath,
               alt = "This is alternate text")
        })
        
        image = readImage(localPath, native=TRUE)
        
        resiz = resizeImage(image, input$width, input$height, method = 'nearest')
        
        writeImage(resiz, outfile);
        
        # Return a list containing the filename
        list(src = outfile,
             width = input$width,
             height = input$height,
             alt = "This is thumbnail alt text")
      }
      
      
    }, deleteFile = TRUE)
    
  }
)