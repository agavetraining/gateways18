
# Mirrors the request auth information back to the console
#* @get /plumber/auth/mirror
function(req,resp) {
    return(list(req$authenticatedUser, req$token))
}