
# date: 18/12/2024
# author: VB
# purpose: explore WT woodland establishment data

### directories ----------------------------------------------------------------

dirWork <- "C:/Users/vbu/OneDrive - the Woodland Trust/Data-analysis/Spatial-stuff/"
dirData <- paste0(dirWork,"data-raw/")
dirScratch <- paste0(dirWork,"data-scratch/")
dirOut <- paste0(dirWork, "data-out/")
dirFigs <- paste0(dirWork, "figures/")

### libraries ------------------------------------------------------------------

library(sf)
library(ggplot2)
library(tidyverse)

### read in data ---------------------------------------------------------------

sfWdEst<- st_read(paste0(dirData,"Woodland_Trust_data/WT_woodland_establishment.shp"))

head(sfWdEst)
summary(sfWdEst)

# uk boundary data
sfUK <- st_read(paste0(dirData,"OS_boundary_line/Data/GB/high_water_polyline.shp"))

head(sfUK)
unique(sfUK$FILE_NAME)

### explore a bit --------------------------------------------------------------

# how do regions vary by their management type?
dfMgmt <- sfWdEst |> 
  group_by(Region, Management) |>
  summarise(n = n())|>
  st_drop_geometry()

dfMgmt |> 
  ggplot()+
  geom_col(aes(Management, n, fill = Management))+
  facet_wrap(~Region)+
  theme_bw()

# when was woodland created across the estate? And has mgmt focus changed over time?
dfYear <- sfWdEst |> 
  group_by(Region, Management, Year) |> 
  summarise(n = n()) |> 
  st_drop_geometry()

p1 <- dfYear |> 
  ggplot()+
  geom_col(aes(Year, n, fill = Region))+
  facet_wrap(~Management)+
  theme_bw()

# similar, but by area
dfArea <- sfWdEst |> 
  ungroup()|> 
  group_by(Region, Year, Management, gis_area_h) |> 
  summarise(Area = sum(gis_area_h)) |>
  mutate(gis_area_h = NULL) |> 
  st_drop_geometry()

p2 <- dfArea |> 
  ggplot()+
  geom_col(aes(Year, Area, fill = Region))+
  facet_wrap(~Management)+
  theme_bw()

ggsave(p2, filename = paste0(dirFigs,"WT_creation_area_by_mgmt_regime_1995-2024.jpg"))

### plot -----------------------------------------------------------------------

sfWdEst |> 
  filter(sfWdEst$Region == "South West") |> 
  ggplot()+
  geom_sf(mapping = aes(fill = Management))+
  geom_sf(data = sfUK |>  
            filter(FILE_NAME == "CORNWALL" | 
                     FILE_NAME == "DEVON_COUNTY" |
                     FILE_NAME == "SOUTH_DEVON_CO_CONST" |
                     FILE_NAME == "SOMERSET"))+
  theme_bw()

