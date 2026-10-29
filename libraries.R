
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, gtools, stringr, ggspatial)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)
