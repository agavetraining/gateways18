#
# This is Yet Another File Browser implemented as a Pluber REST API.
# The app uses the Agave Platform's R SDK to obtain directory listings
# based on the `filePath` passed in as an input parameter.
#

library(plumber)
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

r <- plumb("plumber.R")  # Where 'plumber.R' is the location of the file shown above
r$run(port=9202)