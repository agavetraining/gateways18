# Requests are stateless, so we initialize the Agave object here.
# Logging is enabled so we can feed this app's logs into our
# gateway's logging solution.
#
# The SDK handles token refresh for us, so we can focus on what
# we need to do for our application.
ag<-Agave$new(logLevel=DEBUG)


# Performs remote directory listing on the given file path
#* @get /plumber/data
#* @json
function(filePath="") {

   # Here we list the remote file path and return the result to the UI
   return(ag$files$list(path=filePath, filter="name,path,length,fileType,permissions", responseType='df'))

}

# Downloads a file from the given remote path and serves it in the response
#* @serializer contentType list(type="application/octet-stream")
#* @get /plumber/downloads
#* @json
function(filePath="", res) {

   result = tryCatch({
      # Here we list the remote file path and return the result to the UI
      tmp = ag$files$download(path=input$filePath)

   }, warning = function(war) {

      msg <- "Your request did not include a required parameter."
      res$status <- 400 # Bad request
      list(error=jsonlite::unbox(msg))

      return("")

   }, error = function(err) {

      # error handler picks up where error was generated
      msg <- paste0("Failed to download file at path: ", filePath)
      res$status <- 400 # Bad request
      list(error=jsonlite::unbox(msg), trace=jsonlite::unbox(err))

      return("")

   }, finally = {

     tmp

   }) # END tryCatch
   
   readBin(result, "raw", n=file.info(tmp)$size)

}