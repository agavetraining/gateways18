#
# This is Yet Another File Browser implemented as a Pluber REST API.
# The app uses the Agave Platform's R SDK to obtain directory listings
# based on the `filePath` passed in as an input parameter.
#

library(plumber)


# load the protected resource. In this case, the profiles
r <- plumb("plumber.R")

r$run(host='0.0.0.0', port=9300)
