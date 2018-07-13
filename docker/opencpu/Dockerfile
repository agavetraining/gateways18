FROM opencpu/base:latest

# install common dependencies for trainings
RUN apt update && \
    apt install -y git && \
    R -e 'install.packages(c("devtools", "xml2","plyr", "roxygen2", "rio", "tools", "foreign", "shiny", "clipr", "csvy", "feather", "fst", "readODS", "rmatio"))'

# install agave library
RUN git clone --depth=1 https://github.com/agaveplatform/r-sdk.git /usr/local/rAgave && \
    R -e 'devtools::install("/usr/local/rAgave")' \
      -e 'devtools::document("/usr/local/rAgave")' \
      -e 'devtools::install("/usr/local/rAgave")' && \
    rm -rf /usr/local/rAgave

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