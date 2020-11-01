FROM rocker/tidyverse:3.6.2

RUN sudo apt-get -y install xclip
RUN sudo apt-get -y install libsodium-dev

RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_cran("fst")'
RUN R -e 'remotes::install_cran("ggiraph")'
RUN R -e 'remotes::install_cran("cowplot")'
RUN R -e 'remotes::install_cran("patchwork")'
#RUN R -e 'remotes::install_github("r-lib/remotes", ref = "97bbf81")'
RUN R -e 'remotes::install_cran("shiny")'
RUN R -e 'remotes::install_cran("golem")'
RUN R -e 'remotes::install_cran("processx")'
RUN R -e 'remotes::install_cran("attempt")'
RUN R -e 'remotes::install_cran("DT")'
RUN R -e 'remotes::install_cran("glue")'
RUN R -e 'remotes::install_cran("htmltools")'
RUN R -e 'remotes::install_cran("data.table")'
RUN R -e 'remotes::install_cran("ggthemes")'
RUN R -e 'remotes::install_cran("tidyverse")'
RUN R -e 'remotes::install_cran("dplyr")'
RUN R -e 'remotes::install_cran("shinycssloaders")'
RUN R -e 'remotes::install_cran("ggplot2")'
RUN R -e 'remotes::install_cran("plotly")'
RUN R -e 'remotes::install_cran("writexl")'
RUN R -e 'remotes::install_cran("shinyBS")'
RUN R -e 'remotes::install_cran("shinyalert")'
RUN R -e 'remotes::install_cran("shinydashboard")'
RUN R -e 'remotes::install_cran("shinyjs")'
RUN R -e 'remotes::install_cran("rclipboard")'
RUN R -e 'remotes::install_cran("RMySQL")'
RUN R -e 'remotes::install_cran("tictoc")'
RUN R -e 'remotes::install_cran("shinyWidgets")'
RUN R -e 'remotes::install_cran("DBI")'
RUN R -e 'remotes::install_cran("future")'
RUN R -e 'remotes::install_cran("promises")'
RUN R -e 'remotes::install_cran("tidytext")'
RUN R -e 'remotes::install_cran("stringi")'
RUN R -e 'remotes::install_cran("mime")'
RUN R -e 'remotes::install_cran("jsonlite")'
RUN R -e 'remotes::install_cran("digest")'
RUN R -e 'remotes::install_cran("callr")'
RUN R -e 'remotes::install_cran("knitr")'
RUN R -e 'remotes::install_cran("ps")'
RUN R -e 'remotes::install_cran("rstudioapi")'
RUN R -e 'remotes::install_cran("yaml")'
RUN R -e 'remotes::install_cran("config")'
RUN R -e 'remotes::install_cran("sodium")'
RUN R -e 'remotes::install_cran("janitor")'
RUN R -e 'remotes::install_cran("randomNames")'
RUN R -e 'remotes::install_cran("downloadthis")'
RUN R -e 'remotes::install_cran("testthat")'
RUN pwd
RUN R -e 'remotes::install_github("paulc91/shinyauthr")'
RUN R -e 'remotes::install_github("dreamRs/esquisse")'
RUN R -e 'remotes::install_github("nikkrichko/report.preprocessing")'

RUN R -e 'remotes::install_github("nikkrichko/perf.jmeter.reporter")'



RUN mkdir /app
EXPOSE 80 443



CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');perf.jmeter.reporter::run_app()"
