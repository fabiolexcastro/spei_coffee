
## Author: Fabio Castro - Llanos 
## Alliance Bioversity CIAT / 2026

# Libraries ---------------------------------------------------------------
source('libraries.R')

# Year + Month ------------------------------------------------------------
year <- 2026
mnth <- 9

# 1. Precipitation --------------------------------------------------------

# Parameters --------------------------------------------------------------
bhtp <- 'https://data.chc.ucsb.edu/products/CHIRPS/v3.0/daily/final/rnl/2026'
dout <- glue('./data/chirps_v3.0/daily/{year}'); dir_create(dout)

# Build the daily file names ----------------------------------------------
## Pattern: chirps-v3.0.rnl.2026.09.DD.tif  (uncompressed .tif, with 'rnl')
days <- sprintf('%02d', 1:30)
flsn <- glue('chirps-v3.0.rnl.{year}.{sprintf("%02d", mnth)}.{days}.tif')
urls <- glue('{bhtp}/{flsn}')

# Download loop -----------------------------------------------------------
walk2(.x = urls, .y = flsn, .f = function(url, fln){
  dst <- glue('{dout}/{fln}')
  if(file_exists(dst)){ cat('Already there: ', fln, '\n'); return(invisible()) }
  cat('Downloading: ', fln, '\n')
  res <- tryCatch(download.file(url, destfile = dst, mode = 'wb', quiet = TRUE),
                  error = function(e) e, warning = function(w) w)
  if(inherits(res, c('error', 'warning'))){
    cat('  >> Failed: ', fln, ' | ', conditionMessage(res), '\n')
    if(file_exists(dst)) file_delete(dst)
  }
})
cat('Finish!\n')

# Parameters --------------------------------------------------------------
bhtp <- 'https://data.chc.ucsb.edu/products/CHIRPS/v3.0/daily/final/rnl/2026'
year <- 2026
mnth <- 9
dout <- glue('./data/chirps_v3.0/daily/{year}'); dir_create(dout)

# Build the daily file names ----------------------------------------------
## Pattern: chirps-v3.0.rnl.2026.09.DD.tif  (uncompressed .tif, with 'rnl')
days <- sprintf('%02d', 1:30)
flsn <- glue('chirps-v3.0.rnl.{year}.{sprintf("%02d", mnth)}.{days}.tif')
urls <- glue('{bhtp}/{flsn}')

# Download loop -----------------------------------------------------------
walk2(.x = urls, .y = flsn, .f = function(url, fln){
  dst <- glue('{dout}/{fln}')
  if(file_exists(dst)){ cat('Already there: ', fln, '\n'); return(invisible()) }
  cat('Downloading: ', fln, '\n')
  res <- tryCatch(GET(url, write_disk(dst, overwrite = TRUE), timeout(180)),
                  error = function(e) e)
  if(inherits(res, 'error') || http_error(res)){
    cat('  >> Failed: ', fln, '\n')
    if(file_exists(dst)) file_delete(dst)
  }
})
cat('Finish!\n')

# Potential Evapotranspiration --------------------------------------------

# AgERA5 ------------------------------------------------------------------

## To configurate the cdsapi
reticulate::py_config() 
reticulate::py_install('cdsapi')
library(ecmwfr)

## Key [API]
wf_set_key(key = 'e1a4b5de-2870-462e-937d-d905ff18c850')

## 
cdsapi <- import('cdsapi')
clnt   <- cdsapi$Client()
mn     <- ifelse(mnth < 10, paste0('0', mnth), mnth)

dout <- './data/agera5/eto/daily/2026'; dir_create(dout)
dst  <- glue('{dout}/agera5_eto_{year}-{mn}.zip')

clnt$retrieve(
  'sis-agrometeorological-indicators',
  list(
    variable = 'reference_evapotranspiration',
    year     = '2026',
    month    = '09',
    day      = as.list(sprintf('%02d', 1:30)),
    version  = '2_0',
    format   = 'zip'
  ),
  dst
)






