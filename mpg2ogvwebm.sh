#!/bin/sh

### Check this article out: http://askubuntu.com/questions/343727/filenames-with-spaces-breaking-for-loop-find-command
converttheora()
{
	$(ffmpeg2theora $filename)
}

convertwebm()
{
	$(ffmpeg -i $filename $pathprefix.webm)
}

# Only execute actions if there are mp4 files in directory
if [ "$(find $1 -type f -name '*.mp4')" ]; then
	for filename in `find $1 -type f -name '*.mp4'`; do

		# Break up file name into variables filename & extension
		path="${filename%/*}"
		prefix="${filename##*/}"
		prefix="${prefix%.*}"
		extension="${filename##*.}"
		pathprefix="$path/$prefix"
		
		# echo "filename: $filename"
		# echo "path: $path"
		# echo "prefix: $prefix"
		# echo "extension: $extension"
		# echo "path and prefix: $path/$prefix"
		# echo
		echo "\nConverting $prefix.$extension to OggTheora...\n"

		# Check if theora file exists
		if [ -e "$pathprefix.ogv" ]
		then
			overwrite=
			until [ "$overwrite" = "y" ] || [ "$overwrite" = "n" ]; do
				echo "Destination file $prefix.ogv already exists. Overwrite? [y,N]"
				read -n 1 overwrite

				case $overwrite in
					y) #echo "\nOVERWRITING FILE."
						# ffmpeg2theora "$filename"
						converttheora
					;;
					n) #echo "\nNOT OVERWRITING FILE."
					;;
					### TODO Find way to make "return" be the default
					# "") let overwrite="y"
					# 	echo "\nNOT OVERWRITING FILE."
					# ;;
					*) echo "Invalid choice. Please type 'y' or 'n'"
					### Find a way to go back to top of the question
					;;
				esac
			done
		else 
			#echo "DESTINATION FILE '$path.ogv' DOESN'T EXIST; CONVERTING."
			# ffmpeg2theora "$filename"
			converttheora
		fi

		# WEBM CONVERT
		# ffmpeg -i "$filename.mp4" "$filename.webm"
	done
else
    echo "No mp4 files found in directory '$1'."
fi