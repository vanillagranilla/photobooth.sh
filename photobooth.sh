#!/bin/bash

#Copyright 2014 Jim Gronowski.  Released under the terms of the Apache 2.0 license
 
#photobooth.sh is a script to automate image processing and printing for unattended photobooths.  It was originally designed to work with Cheese webcam software, though the original source of images isn't important.  Any JPEGs dropped in $PHOTODIRECTORY will be combined into a filmstrip and are formatted to be printed on 4x6 or 5x7 paper.

PHOTODIRECTORY=/home/jgronowski/Pictures/Webcam

cd $PHOTODIRECTORY 

#Continuous work loop, checks for 4 JPEGs, then begins processing.  Waits 10s, then starts over again.
while true;
do
	echo "waiting for images..."
	JPEGCOUNT=`ls *.jpg|wc -w`

	if [ $JPEGCOUNT -eq 4 ]
	then
		echo "Found images.  Processing..."
	
		# old way (no .jpg)- PHOTO2=`ls *.jpg|tail -n 3|head -n 1|sed 's/\.jpg//'`
		PHOTO1=`ls *.jpg|tail -n 4|head -n 1`
		PHOTO2=`ls *.jpg|tail -n 3|head -n 1`
		PHOTO3=`ls *.jpg|tail -n 2|head -n 1`
		PHOTO4=`ls *.jpg|tail -n 1|head -n 1`
		FOOTER="footer.png"

		#echo "Photo 1: $PHOTO1"
		#echo "Photo 2: $PHOTO2"
		#echo "Photo 3: $PHOTO3"
		#echo "Photo 4: $PHOTO4"
		#echo "Photo footer: $FOOTER"

		convert $PHOTO1[800x800] $PHOTO2[800x800] $PHOTO3[800x800] $PHOTO4[800x800] $FOOTER[800x800] -background white -splice 0x10  -append -crop -0+10 out.png

		#Double up for printing
		convert out.png out.png -background white -splice 15x0 +append -gravity east -crop -15+0 print.png

		#*****PRINT PHOTO HERE*****
		echo "Printing photo..."	
		lpr -o page-left=6 -o page-top=6 print.png
	
		#Clean up files
		DATETIME="`date '+%Y%m%d%H%M%S'`"
		mv *.jpg $PHOTODIRECTORY/originals/
		mv out.png $PHOTODIRECTORY/filmstrips/$DATETIME.png
		mv print.png $PHOTODIRECTORY/filmstrips/print$DATETIME.png

		echo "Done!"
	fi

	sleep 10 
done
