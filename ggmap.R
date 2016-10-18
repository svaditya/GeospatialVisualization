library(ggplot2)
library(ggmap)

head(state.x77)
popdata<-data.frame(state=row.names(state.x77),murder=state.x77[,5])
popdata$state<-as.character(popdata$state)

for(i in 1:nrow(popdata)) {
        latlon <- geocode(popdata$state[i])
        popdata$lat[i] <- as.numeric(latlon[2])
        popdata$lon[i] <- as.numeric(latlon[1])
}

usa_center = geocode("United States")
USA <-ggmap(get_map(location=usa_center,zoom=4), extent="panel")

USA + geom_point(aes(x=lon, y=lat), data=popdata, col="black", alpha=0.4, size=popdata$murder)

############ LAB

my.data<-data.frame(federal.states=c("Baden-Württemberg","Bayern","Berlin",
                                     "Brandenburg","Bremen","Hamburg","Hessen",
                                     "Mecklenburg-Vorpommern","Niedersachsen",
                                     "Nordrhein-Westfalen","Rheinland-Pfalz",
                                     "Saarland","Sachsen","Sachsen-Anhalt",
                                     "Schleswig-Holstein","Thüringen"), 
                    Population=c(10716644,12691568,3469849,2457872,661888,1762791,
                                 6093888,1599138,7826739,17638098,4011582,989035,4055274,
                                 2235548,2830864,2156759))
str(my.data)
# Next, examine my.data using the str() function. Notice that the länder are stored as factor. Convert these to character.

my.data$federal.states <- as.character(my.data$federal.states)

# Next, get the geocodes for the German länder.
latlon <- geocode(my.data$federal.states)

# You will received 2 warning messages. The request for geocodes failed for 
# "Baden-ürttemberg" and "Thüringen". This is because geocode() cannot handle 
# the German 'umlaut' (¨). In particular when dealing with letters which aren't 
#standard English, you should be a little careful with geocode(). We therefore 
#handle two locations separately. For Baden-Württemberg, we simply remove the 
# umlaut. For Thüringen, we remove the umlaut, but also specify that the 
# location is in Germany. Otherwise geocode() will find a location in western 
# Austria; you should also be careful with possibly multiple location names.

my.data$federal.states[1]<-"Baden-Wurttemberg"
my.data$federal.states[16]<-"Thuringen Germany"
latlon <- geocode(my.data$federal.states)

# Get the geocodes for the German länder again. This time you shouldn't receive 
# any warning messages. Assign the two variables from latlon to my.data respectively.

my.data$lon <- as.numeric(latlon$lon)
my.data$lat <- as.numeric(latlon$lat)

# With this in place, proceed to get the geocodes of Germany and a raster map with a proper zoom factor.

Germany <- ggmap(get_map(location = "Germany",zoom = 6), extent = "panel")

# The last step is to overlay the map with the population sizes. Consider to 
# set the following options: col for color, alpha for transparency, and size for
# the size of data according to the data frame's population.

circle_scale <- 0.000001
Germany + geom_point(aes(x = lon, y = lat), data = my.data, size = my.data$Population*circle_scale, alpha = 0.4, col = "blue")
