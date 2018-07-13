FROM agaveplatform/rstudio:3.4.3


RUN R -e 'install.packages(c("rio", "tools", "foreign", "shiny","rmarkdown"))' \
      -e 'install.packages(c("clipr", "csvy", "feather", "fst", "readODS", "rmatio"))'

ADD docker/ssh-keygen/keygen.sh /usr/local/bin/keygen.sh

RUN chmod 755 /usr/local/bin/keygen.sh

RUN apt-get install -y ssh openssl