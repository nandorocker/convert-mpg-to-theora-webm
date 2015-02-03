#!/bin/sh

for filename in *.mp4; do
	extension="${filename##*.}"
	filename="${filename%.*}"
	echo "Converting file $extension.$filename...\n"
	# THEORA CONVERT
	#
	echo "Ogg Theora\n----------"
	ffmpeg2theora "$filename.mp4"

	### Adding this later
	# # Check if theora file exists
	# if [ -e "$filename.ogv" ]
	# then
	# 	echo "Destination file $filename.ogv already exists. Overwrite? [y,N]"
	# 	read -n 1 overwrite
	# 	### Find a way to put question and answer on same line

	# 	case $overwrite in
	# 		y) echo "\nOVERWRITING FILE."
	# 		;;
	# 		n) echo "\nNOT OVERWRITING FILE."
	# 		;;
	# 		"") echo "\nNOT OVERWRITING FILE."
	# 		;;
	# 		*) echo "Please answer 'y' or 'n'"
	# 		### Find a way to go back to top of the question
	# 		;;
	# 	esac
	# else 
	# 	echo "DESTINATION FILE DOESN'T EXIST; CONVERTING."
	# 	#ffmpeg2theora "$filename.mp4"
	# fi

	# WEBM CONVERT
	#
	echo "Webm\n----"
	ffmpeg -i "$filename.mp4" "$filename.webm"
done