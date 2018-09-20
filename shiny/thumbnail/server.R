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
library(DT)
library(gdalUtils)

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
    
    # Send the resutls to the UI for rendering in the DataTable
    # Note the server-side processing here
    options(DT.options = list(pageLength = 5))
    output$table <- DT::renderDataTable(
      ag$files$list(path=input$filePath, filter="name,length,type,path", responseType='df'), 
      server = TRUE, 
      selection = 'single'
      )
    
    output$filePath <- input$table_rows_selected[1]
    output$caption <- renderText({
      cat(input$table_rows_selected[1],',')
      
      input_file_format <- tools::file_ext(basename(input$filePath))
      if (input_file_format != '') {
        tools::file_ext(basename(input_file_format))
      }
      else {
        print("No file selected")
      }
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
      else {
        
        output$fullImage <- renderImage({
          
          # Return a list containing the filename
          list(src = '',
               width = 0,
               height = 0,
               alt = "No original image selected")
        })
        
        # Return a list containing the filename
        list(src = '',
             width = 0,
             height = 0,
             alt = "No thumbnail image generated")
      }
      
      
    }, deleteFile = TRUE)
    
  }
)