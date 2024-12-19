
# date: 05-04-22
# author: VB
# purpose: have a look at WEAG data (sent by Louise, tif format)

### directories ----------------------------------------------------------------

dirWork <- "~/R Portable/Portable Work Directory/"
dirData <- paste0(dirWork,"data-raw/WEAG-2020-data/")
dirScratch <- paste0(dirWork,"data-scratch/")
dirOut <- paste0(dirWork, "data-out/")

### libraries ------------------------------------------------------------------

library(terra)

### read in data ---------------------------------------------------------------

rstWEAG <- rast(paste0(dirData,"weag.tif"))

### plot -----------------------------------------------------------------------

plot(rstWEAG)
