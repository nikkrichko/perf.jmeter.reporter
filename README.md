
<!-- README.md is generated from README.Rmd. Please edit that file -->

> For commercial use contact with me: <nik.krichko@gmail.com>

# perf.jmeter.reporter

Package provide simple process analyze jemter perforamance results

<!-- badges: start -->

<!-- badges: end -->

The goal of perf.jmeter.reporter is to …

## Installation

You can install the released version of perf.jmeter.reporter from
[CRAN](https://CRAN.R-project.org) with:

``` r
###install.packages("perf.jmeter.reporter")
maybe in future but now only dev version from github



```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("nikkrichko/perf.jmeter.reporter")

#install.packages("remotes")
remotes::install_github("nikkrichko/perf.jmeter.reporter")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` console
user@terminal:~$ Rscript perf.jmeter.reporter::run_app()
```

### Docker container

get and run with docker
container

``` console
user@terminal:~$ docker pull nikkrichko/nikkrichko_pub:perf.jmeter.reporter
user@terminal:~$ docker run -d -p 9999:80 nikkrichko/nikkrichko_pub:perf.jmeter.reporter
```

open application in browser localhost:8888
