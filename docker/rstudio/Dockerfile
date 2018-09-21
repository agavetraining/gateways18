FROM agaveplatform/rstudio:3.4.3

# Install dependent R packages for this tutorial and disable host verification
# in the http package for interacting with the sandbox.
RUN R -e 'install.packages(c("rio", "tools", "foreign", "shiny","rmarkdown","png","jpeg","tiff","OpenImageR","DT"))' \
      -e 'install.packages(c("clipr", "csvy", "feather", "fst", "readODS", "rmatio", "openssl", "plumber", "jose"))' && \
    echo 'set_config( config( ssl_verifypeer = 0L ) )' >> /usr/local/lib/R/etc/Rprofile.site

ADD docker/ssh-keygen/keygen.sh /usr/local/bin/keygen.sh

RUN chmod 755 /usr/local/bin/keygen.sh

RUN apt-get update && apt-get install -y ssh openssl libpng-dev libjpeg-dev libtiff-dev