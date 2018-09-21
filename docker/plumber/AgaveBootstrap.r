library("plyr")
library("rAgave")
library("httr")

# disable ssl peer verification if requested
set_config( config( ssl_verifypeer = 0L ) )

Sys.getenv()

# For security, we'll pull our variables from the environment rather than enter them directly.
myCreds <- Sys.getenv( c("AGAVE_USERNAME", "AGAVE_PASSWORD", "AGAVE_TENANT", "AGAVE_BASE_URL", "AGAVE_CACHE_DIR"), names = TRUE )

api <-Agave$new( baseUrl = myCreds[["AGAVE_BASE_URL"]], username = myCreds[["AGAVE_USERNAME"]], password = myCreds[["AGAVE_PASSWORD"]], logLevel=DEBUG)

if (!assertthat::not_empty(api)) {
    apiCache <- AgaveCache$new(cacheDir=myCreds[["AGAVE_CACHE_DIR"]])
    ac$setClient(Client$new())
    ac$setToken(Token$new())
    ac$setTenant(Tenant$new())
    ac$write()
}

api <-Agave$new( baseUrl = myCreds[["AGAVE_BASE_URL"]], username = myCreds[["AGAVE_USERNAME"]], password = myCreds[["AGAVE_PASSWORD"]], logLevel=DEBUG)

api$cache

api$clientInfo

api$tokenInfo

!assertthat::not_empty(api$clientInfo$secret)

!assertthat::not_empty(api$tokenInfo$refresh_token)

if ( !assertthat::not_empty(api$clientInfo$key) || !assertthat::not_empty(api$tokenInfo$refresh_token) ) {

  clientName <- paste0(myCreds[["AGAVE_USERNAME"]],"_trn_plumber")

  # we will delete the client by name just in case it exists, but was not saved on the file system
  # behind this notebook.
  api$clients$delete(clientName=clientName)

  # Now we fetch a new set of client keys from Agave. These will save in our local
  # cache by default, so there's nothing you have to explicitly remember
  client <- api$clients$create(body=list("clientName" = clientName))

  # Once we have a valid client, we can tell Agave to startup a new session for us
  # by pulling a fresh auth token, updating our local session cache, and
  # initializing all our service endpoints.
  api$initialize()
}
