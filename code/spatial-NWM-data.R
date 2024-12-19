
# date: 20-05-22
# author: VB
# purpose: have a look at Native Woodland Model data (from Ewan)

### directories ----------------------------------------------------------------

dirWork <- "~/R Portable/Portable Work Directory/"
dirData <- paste0(dirWork,"data-raw/NWM_OpenData/")
dirScratch <- paste0(dirWork,"data-scratch/")
dirOut <- paste0(dirWork, "data-out/")

### libraries ------------------------------------------------------------------

library(sf)
library(ggplot2)
library(tidyverse)

### read in data ---------------------------------------------------------------

sfNWM <- st_read(paste0(dirData,"nwm_natcov.shp"))

head(sfNWM)
summary(sfNWM)

unique(sfNWM$NEWNVC)
unique(sfNWM$NVCTEXT)

### summarise areas of NVC types -----------------------------------------------

NVC_summary <- sfNWM  %>% 
  group_by(NVCTEXT) %>% 
  summarise(total_area = sum(AREA)) %>% 
  st_drop_geometry()

# assuming area is in m2, convert to ha by either dividing by 10,000 or multiplying by 0.0001

NVC_summary <- NVC_summary %>% mutate(hectares = total_area*0.0001)
NVC_summary
colnames(NVC_summary) <- c("NVC_type", "area_m2", "area_ha")

write.csv(NVC_summary, file = paste0(dirOut,"JHI_Native_Woodland_Model_NVC_summaries.csv"), row.names = F)

### plot -----------------------------------------------------------------------

sfNWM %>% filter(sfNWM$NEWNVC == "W7/W4") %>% 
  ggplot()+
  geom_sf()

type.pal <- c("Amenity.residential.business" = "grey")

#png(paste0(wd,"/figures/type_allocation.png"), width = 800, height = 800)
ggplot() +
  geom_sf(sfNWM, mapping = aes(fill = type), col = NA)+
  scale_fill_manual(values=type.pal)
#dev.off()

