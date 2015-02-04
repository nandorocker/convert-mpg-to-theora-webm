#!/bin/sh

### Check this article out: http://askubuntu.com/questions/343727/filenames-with-spaces-breaking-for-loop-find-command

# Declare variables
if [ "$2" == "skip" ]; then
	skip="$2"
fi

# Convert to something
convert()
{
	case $1 in
		"theora")
			echo "\nConverting $2 to OggTheora...\n"
			$(ffmpeg2theora $2)
		;;
		"webm")
			echo "\nConverting $2 to Webm...\n"
			$(ffmpeg -i $2 $pathprefix.webm)
		;;
	esac
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

		# Check if file exists
		if [ -e "$pathprefix.ogv" ] && [ "$skip" != "skip" ]
		then
			overwrite=
			until [ "$overwrite" = "y" ] || [ "$overwrite" = "n" ]; do
				echo "Destination file $prefix.ogv already exists. Overwrite? [y,N]"
				read -n 1 overwrite

				case $overwrite in
					y) #echo "\nOVERWRITING FILE."
						convert "theora" "$filename"
					;;
					n) #echo "\nNOT OVERWRITING FILE."
					;;
					### TODO Find way to make "return" be the default
					# "") let overwrite="y"
					# 	echo "\nNOT OVERWRITING FILE."
					# ;;
					*) echo "Invalid choice. Please type 'y' or 'n'"
					;;
				esac
			done
		else 
			#echo "DESTINATION FILE '$path.ogv' DOESN'T EXIST; CONVERTING."
			convert "theora" "$filename"
		fi
	done
else
    echo "No mp4 files found in directory '$1'."
fi