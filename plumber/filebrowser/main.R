#
# This is Yet Another File Browser implemented as a Pluber REST API.
# The app uses the Agave Platform's R SDK to obtain directory listings
# based on the `filePath` passed in as an input parameter.
#

library(plumber)
library(httr)
library(plyr)
library(rAgave)

r <- plumb("plumber.R")  # Where 'plumber.R' is the location of the file shown above
r$run(port=9200)