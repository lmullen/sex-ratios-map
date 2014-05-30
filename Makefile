default: us.json coast.json

shapefiles := ~/research-data/nhgis-shapefiles/epsg4326

us2.json:
		node --max_old_space_size=7192 /usr/local/bin/topojson \
		-o $@ \
		-q 1e5 -s 1 \
		--projection 'd3.geo.albers().scale(1000).translate([423, 240])' \
		--id-property GISJOIN \
		-p c=NHGISNAM \
		-p s=STATENAM \
		--filter=small \
		-- \
		$(shapefiles)/county_1820.shp \
		$(shapefiles)/county_1830.shp \
		$(shapefiles)/county_1840.shp \
		$(shapefiles)/county_1850.shp \
		$(shapefiles)/county_1860.shp \
		$(shapefiles)/county_1870.shp \
		$(shapefiles)/county_1880.shp \
		$(shapefiles)/county_1890.shp \
		$(shapefiles)/county_1900.shp \
		$(shapefiles)/county_1910.shp \
		$(shapefiles)/county_1920.shp 
		# $(shapefiles)/county_1930.shp \
		# $(shapefiles)/county_1940.shp \
		# $(shapefiles)/county_1950.shp \
		# $(shapefiles)/county_1960.shp \
		# $(shapefiles)/county_1970.shp \
		# $(shapefiles)/county_1980.shp \
		# $(shapefiles)/county_1990.shp \
		# $(shapefiles)/county_2000.shp
		# $(shapefiles)/county_1790.shp \
		# $(shapefiles)/county_1800.shp \
		# $(shapefiles)/county_1810.shp \

build/ne_50m_coastline.zip:
	mkdir -p $(dir $@)
	curl -o $@ http://www.nacis.org/naturalearth/50m/physical/$(notdir $@)

build/ne_50m_coastline.shp: build/ne_50m_coastline.zip
	unzip -od $(dir $@) $<
	touch $@

coast.json: build/ne_50m_coastline.shp
	ogr2ogr -f "ESRI Shapefile" -overwrite -clipsrc -129, 22, -65, 54 \
		$(dir $<)coast-clipped/ $< 
	topojson -o $@ -s 1.0 \
		--projection 'd3.geo.albers().scale(1000).translate([423, 240])' \
		coast=$(dir $<)coast-clipped/$(notdir $<)

clean: 
	rm -rf build/*

clobber:
	rm -f us.json coast.json 

deploy:
	rsync --progress --delete -avz \
		*.json *.html *.css *.js *.csv \
		reclaim:~/public_html/lincolnmullen.com/projects/sex-ratios/

.PHONY : default clean clobber deploy

