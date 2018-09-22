FROM rocker/r-base
MAINTAINER Rion Dooley<deardooley@gmail.com>

RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev \
  openssl \
  libpng-dev \
  libjpeg-dev \
  libtiff-dev \
  jq

## RUN R -e 'install.packages(c("devtools"))'
## RUN R -e 'devtools::install_github("trestletech/plumber")'
RUN  install2.r plumber rio tools foreign shiny rmarkdown png jpeg tiff OpenImageR DT clipr csvy feather fst readODS rmatio openssl plumber jose devtools

# install agave library
RUN R -e 'devtools::install_github("agaveplatform/r-sdk")' && \
    cd & \
    echo "library(httr)" >> /etc/R/Rprofile.site && \
    echo 'set_config( config( ssl_verifypeer = 0L ) )' >> /etc/R/Rprofile.site

COPY docker/plumber/AgaveBootstrap.r /AgaveBootstrap.r
COPY docker/plumber/entrypoint.sh /entrypoint.sh
COPY ./plumber /usr/local/agavetraining/examples

EXPOSE 9300
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/agavetraining/examples/authorization/plumber.R"]
