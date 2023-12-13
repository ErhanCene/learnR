FROM openanalytics/r-base

LABEL maintainer "Erhan Cene <ecene@yildiz.edu.tr>"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# system library dependency for the learnR app
RUN apt-get update && apt-get install -y \
    libmpfr-dev

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown','learnr', 'reticulate'), repos='https://cloud.r-project.org/')"

# install dependencies of the learnR app
RUN R -e "install.packages('Rmpfr', repos='https://cloud.r-project.org/')"

RUN R -e "remotes::install_github("rstudio-education/gradethis")"

# copy the app to the image
RUN mkdir /root/learnR
COPY euler /root/learnR

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 8100

CMD ["R", "-e", "shiny::runApp('/root/learnR')"]