
library(openssl)
library(jose)
library(plyr)
library(httr)
library(jsonlite)

trustedUsers <- c(Sys.getenv("AGAVE_USERNAME"))

pubKey <- ''

# Fetches public key used to sign the jwt passed in by Agave's auth server
# @return char[] containing the downloaded public key
fetchPublicKey <- function() {

    if (pubKey == '') {
        agaveBaseUrl <- Sys.getenv("AGAVE_BASE_URL", "https://sandbox.agaveplatform.org")
        agaveBaseUrl = paste0(agaveBaseUrl, "/apim/v2/publickey")
        publicKeyResponse <- httr::GET(agaveBaseUrl);
        publicKeyText <- httr::content(publicKeyResponse, as = "text")
    }
    else {
      publicKeyText <- pubKey
    }

    publicKeyText
}

# Verifies the signature on a jwt is valid
# @param req the request object
# @return JSON object containing the claims from the JWT body
validateJwt <- function(req) {
    agaveJwt <- req$HTTP_HTTP_X_JWT_ASSERTION_SANDBOX

    # we can validate the jwt here using the public key to check the signature
    #jwt_decode_sig(agaveJwt, pubkey = publicKeyText)

    # no error, so parse the jwt body
    (jwtStrings <- strsplit(agaveJwt, ".", fixed = TRUE)[[1]])

    # convert to an object
    jwtClaims <- jsonlite::fromJSON(cat(rawToChar(base64url_decode(jwtStrings[2]))))

    # TODO: Parse the timestamp, fields in the body, etc to further check the jwt for validity.

    jwtClaims
}

#' Authorization filter that parses the jwt from a header and injects the
#' user info into the request object. If the global trustedUsers variable
#' is not empty, it ensures the user in the jwt is present in the white
#' list or rejects the request.
#'
#' @filter jwt
function(req) {

    # fetch the public key for Agave's OAuth server so we can validate the
    # signature on the JWT we pull from the header
    pubKey <<- fetchPublicKey()

    if (!('HTTP_HTTP_X_JWT_ASSERTION_SANDBOX' %in% attributes(req))) {
        # error handler picks up where error was generated
        res$status <- 401 # Unauthorized
        return(list(error="Authentication required", headers=attributes(req)))
    }
    else {

        # validate the jwt and get the assertions from the body
        jwtClaims <- validateJwt(req)

        # extract the user from the assertions
        authenticatedUser <- jwtClaims["http://wso2.com/claims/enduser"]

        # extract the bearer token from the request
        authToken <- strsplit(req$Authorization, " ", fixed=TRUE)[[2]]

        # ensure the user is in the white list, if a white list exists
        if (is.empty(trustedUsers) || authenticatedUser %in% trustedUsers) {
            req$authenticatedUser <- authenticatedUser
            req$token <- authToken
            req$claims <- jwtClaims
            plumber::forward()
        }
        else {
            # error handler picks up where error was generated
            res$status <- 403 # Forbidden
            return(list(error="Permission denied"))
        }
    }
}

#' Add cors support to all reqeusts
#' @filter cors
function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}


#' Log some information about the incoming request
#' @filter logger
function(req){
  cat(as.character(Sys.time()), "-",
    req$REQUEST_METHOD, req$PATH_INFO, "-",
    req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  plumber::forward()
}

#' Mirrors the request auth information back to the console
#' @get /plumber/auth/mirror
#' @post /plumber/auth/mirror
#' @put /plumber/auth/mirror
function(req,resp) {
    #return(list(req$authenticatedUser, req$token))
    return(list(request=jsonlite::toJSON(req)))
}
