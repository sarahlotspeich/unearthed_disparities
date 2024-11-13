# Load necessary packages
library(sf) ## for spatial functions
library(ggplot2) ## for mapping functions
library(viridis) ## for color schemes

# Link to this particular earthquake
## https://earthquake.usgs.gov/earthquakes/eventpage/usp000jj3u/executive
## Go to ShakeMaps --> Downloads --> ShakeMap Shape Files

# Read in earthquake shapefile (.shp) from USGS
shake_dat <- st_read("~/Downloads/shape/mi.shp")

# Create the ShakeMap of the modified mercalli intensity (MMI)
shakemap = ggplot() + 
  geom_sf(data = shake_dat, 
          aes(fill = PARAMVALUE)) + 
  ggtitle("Earthquake near CCASANET clinic Santiago, Chile") + 
  coord_sf() + 
  scale_fill_viridis(option = "viridis", 
                     name = "MMI") + 
  theme_void()

# Overlay the (lat, long) coordinates of the site onto the ShakeMap
clinic_coord = data.frame(lat = -33.45694, 
                          long = -70.64827)
shakemap = shakemap + 
  geom_point(data = clinic_coord, 
             aes(x = long, y = lat), ## say lat, long but plot long, lat
             color = "red", 
             shape = 17) 

# Use point-in-polygon analysis to find MMI *at* the clinic location 
## Define the clinic location (point) and convert to sf object
clinic_coord = st_as_sf(clinic_coord, 
                        coords = c("long", "lat"))
## Define the coordinate reference system (CRS) for the clinic location
clinic_coord = st_set_crs(x = clinic_coord, 
                          value = 4326)

## Find the polygon from the shakemap that intersects the points
st_intersection(x = clinic_coord, 
                y = shake_dat)

## If you get this error: 
### Error in wk_handle.wk_wkb(wkb, s2_geography_writer(oriented = oriented,  : 
### Loop 70 is not valid: Edge 34 is degenerate (duplicate vertex)
sf_use_s2(FALSE) ### Run this and then try to run the st_intersection() line again

## Find the polygon from the shakemap that intersects the points
st_intersection(x = clinic_coord, 
                y = shake_dat)
