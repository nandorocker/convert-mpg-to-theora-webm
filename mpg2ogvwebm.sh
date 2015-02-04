#!/bin/bash

# Argument $1 is directory PATH
# Argument $2 is REPLACE FILES (y,n)
#
### TODO Check this article out: http://askubuntu.com/questions/343727/filenames-with-spaces-breaking-for-loop-find-command

# Array with file formats
targetformat[0]="ogv"
targetformat[1]="webm"

# Array with format names
formatname[0]="OggTheora"
formatname[1]="Google Webm"

# Convert to something
convert()
{
	case $1 in
		"ogv")
			#echo "\nConverting $2 to OggTheora...\n"
			$(ffmpeg2theora $2)
		;;
		"webm")
			#echo "\nConverting $2 to Webm...\n"
			$(ffmpeg -i $2 $pathprefix.webm)
		;;
	esac
}

# Only execute actions if there are mp4 files in directory
if [ "$(find $1 -type f -name '*.mp4')" ]; then

	# Cycle through all files in directory
	for filename in `find $1 -type f -name '*.mp4'`; do

		# Break up file name into variables filename & extension
		path="${filename%/*}"
		prefix="${filename##*/}"
		prefix="${prefix%.*}"
		extension="${filename##*.}"
		pathprefix="$path/$prefix"

		i="0"
		while [ $i -lt 2 ]; do
			t_format="${targetformat[$i]}"
			t_name="${formatname[$i]}"

			# Check if file exists AND user did not invoke 'do not overwrite' argument
			if [ -e "$pathprefix.$t_format" ] && [ "$2" != "n" ]; then

				overwrite=$2
				if [ "$overwrite" ]; then
					#echo "Destination file '$pathprefix.$t_format' found; overwriting."
					echo "\nConverting to $t_name..."
					convert "$t_format" "$filename"
				else
					until [ "$overwrite" = "y" ] || [ "$overwrite" = "n" ]; do

						if [ "$overwrite" != "y" ]; then
							echo "Destination file $prefix.$t_format already exists. Overwrite? [y,N]"
							read -n 1 overwrite
						fi

						case $overwrite in
							y) echo "\nConverting to $t_name..."
								convert "$t_format" "$filename"
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
				fi

			# If 'do not overwrite' argument was invoked
			elif [ -e "$pathprefix.$t_format" ] && [ "$2" == "n" ]; then
				echo "Destination file '$prefix.$t_format' found; skipping."
			else
				#echo "Destination file '$pathprefix.$t_format' not found; converting to $t_format."
				convert "$t_format" "$filename"
			fi

			i=$[$i+1]
		done
	done
else
    echo "No mp4 files found in directory '$1'."
fi