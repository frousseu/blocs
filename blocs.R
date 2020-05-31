

library(readxl)
library(mapview)
library(sf)
library(knitr)

### import and format google map list
#d<-as.data.frame(read_excel("C:/Users/User/Documents/FR/blocs.xlsx",sheet=2,col_names=FALSE))
#names(d)<-"loc"
#d<-d[seq(2,nrow(d),by=2),,drop=FALSE]
#s<-strsplit(d$loc,", ")
#d$lat<-as.numeric(gsub("\\(","",sapply(s,"[",1)))
#d$lon<-as.numeric(gsub("\\)","",sapply(s,"[",2)))
#rownames(d)<-1:nrow(d)
#d<-st_as_sf(d, coords = c("lon","lat"))
#st_crs(d)=4326
#mapview(d)
#st_write(d,dsn="C:/Users/User/Documents/FR/blocs.kml",driver="KML")


### read .kml with adds from previous import and pool all layers and unique
layers<-st_layers("C:/Users/User/Documents/FR/My Places.kml")$name
layers<-layers[-grep("Sightseeing Tour",layers)]
l<-lapply(layers,function(i){
	 st_read("C:/Users/User/Documents/FR/My Places.kml",layer=i)
})
x<-do.call("rbind",l)
blocs<-unique(x)

### write csv and kml for next adds
write.csv(st_coordinates(blocs)[,c("X","Y")],"C:/Users/User/Documents/GitHub/blocs/blocs.csv",row.names=FALSE)
st_write(blocs,dsn="C:/Users/User/Documents/GitHub/blocs/blocs.kml",driver="KML",delete_dsn=TRUE)

### knit .Rmd
knit("C:/Users/User/Documents/GitHub/blocs/blocs.Rmd")

#git.exe push origin HEAD:refs/heads/master

system("git add blocs.R blocs.Rmd blocs.csv blocs.kml")
system("git commit blocs.R blocs.Rmd blocs.csv blocs.kml -m \"...\"")
system("git push origin master")

system("git checkout gh-pages")
system("git add index.html blocs.html")
system("git commit index.html blocs.html -m \"...\"")
system("git push origin gh-pages")

system("git checkout master")
