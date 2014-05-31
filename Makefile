default: us.json gender-census.csv

shapefiles := ~/research-data/nhgis-shapefiles/epsg4326

gender-census.csv: export.r
	Rscript --vanilla export.r

simplify: clean-shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1790.shp -o build/county_1790.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1800.shp -o build/county_1800.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1810.shp -o build/county_1810.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1820.shp -o build/county_1820.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1830.shp -o build/county_1830.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1840.shp -o build/county_1840.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1850.shp -o build/county_1850.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1860.shp -o build/county_1860.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1870.shp -o build/county_1870.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1880.shp -o build/county_1880.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1890.shp -o build/county_1890.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1900.shp -o build/county_1900.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1910.shp -o build/county_1910.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1920.shp -o build/county_1920.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1930.shp -o build/county_1930.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1940.shp -o build/county_1940.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1950.shp -o build/county_1950.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1960.shp -o build/county_1960.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1970.shp -o build/county_1970.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1980.shp -o build/county_1980.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_1990.shp -o build/county_1990.shp
	mapshaper --auto-snap -i 5000 $(shapefiles)/county_2000.shp -o build/county_2000.shp
	# 2010 needs to be munged into the format of the others
	mapshaper --encoding utf-8 --join fips.csv --join-keys STATEFP10,FIPS:str --expressionm"NHGISNAM=NAME10" --auto-snap -i 5000 ~/research-data/nhgis-shapefiles/epsg4326/county_2010.shp -o build/county_2010.shm

us.json: 
		node --max_old_space_size=7192 /usr/local/bin/topojson \
		-o $@ \
		-q 1e5 --simplify-proportion 0.05 \
		--projection 'd3.geo.albersUsa().scale(1000).translate([423, 240])' \
		--id-property=GISJOIN \
		-p c=NHGISNAM \
		-p s=STATENAM \
		--filter=small-detached \
		-- \
		build/county_1790.shp \
		build/county_1800.shp \
		build/county_1810.shp \
		build/county_1820.shp \
		build/county_1830.shp \
		build/county_1840.shp \
		build/county_1850.shp \
		build/county_1860.shp \
		build/county_1870.shp \
		build/county_1880.shp \
		build/county_1890.shp \
		build/county_1900.shp \
		build/county_1910.shp \
		build/county_1920.shp \
		build/county_1930.shp \
		build/county_1940.shp \
		build/county_1950.shp \
		build/county_1960.shp \
		build/county_1970.shp \
		build/county_1980.shp \
		build/county_1990.shp \
		build/county_2000.shp \
		build/county_2010.shp

clean-shp:
	rm -f build/county_*

clean: 
	rm -rf build/*

clobber: clean
	rm -f us.json
	rm -f gender-census.csv

deploy:
	rsync --progress --delete -avz \
		*.json *.html *.css *.js *.csv \
		reclaim:~/public_html/lincolnmullen.com/projects/sex-ratios/

.PHONY : default clean clobber deploy simplify clean-shp

