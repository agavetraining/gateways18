FROM opencpu/base:latest

# install common dependencies for trainings
RUN apt update && \
    apt install -y git && \
    R -e 'install.packages(c("devtools", "xml2","plyr", "roxygen2", "rio", "tools", "foreign", "shiny", "clipr", "csvy", "feather", "fst", "readODS", "rmatio"))'

# install agave library
RUN R -e 'install.packages("testthis")' \ 
      -e 'devtools::install_github("agaveplatform/r-sdk")' 

RUN mkdir -p /home/opencpu/work/.agave && \
    echo "AGAVE_CACHE_DIR=/home/opencpu/work/.agave" && \
    chown -R opencpu:www-data /home/opencpu/work/.agave && \
    echo "library('plyr')" >> /etc/opencpu/Rprofile && \
    echo "library('rAgave')" >> /etc/opencpu/Rprofile && \
    echo "library('httr')" >> /etc/opencpu/Rprofile

COPY docker/opencpu/server.conf /etc/opencpu/server.conf
COPY docker/opencpu/AgaveBootstrap.r /AgaveBootstrap.r
COPY docker/opencpu/entrypoint.sh /entrypoint.sh
COPY opencpu/tutorial /home/opencpu/tutorial
RUN chown -R opencpu:www-data /home/opencpu/tutorial

ENTRYPOINT ["/entrypoint.sh"]

CMD "service cron start && apachectl -DFOREGROUND"
