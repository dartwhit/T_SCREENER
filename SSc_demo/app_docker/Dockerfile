# Use the official Rocker Shiny image
FROM rocker/shiny:4.1.0

# Install system libraries required by some R packages
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libudunits2-dev \
    libgdal-dev \
    libproj-dev \
    libfontconfig1-dev \
    libcairo2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install additional R packages
RUN R -e "install.packages(c('shinythemes', 'shinyWidgets', 'leaflet', 'htmltools', 'dplyr', 'tigris'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Copy the Shiny application into the image
COPY app /srv/shiny-server/

# Make sure the permissions are set correctly
RUN chown -R shiny:shiny /srv/shiny-server

# Expose the port Shiny runs on
EXPOSE 3838

# Use the base image's command to run Shiny Server
CMD ["/usr/bin/shiny-server"]
