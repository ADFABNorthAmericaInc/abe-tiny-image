#!/bin/bash

# source file for api tinypng.
source .env
 
# Make sure source dir is supplied
if [ -z "$1" ]
    then
    echo "Missing argument. Supply the source directory containing the images to be optimized. Usage: ./tinypng.sh <source_dir>"
    exit 1
fi
 
INDIR=$1
 
# Make sure source dir exists
if [ ! -d "$INDIR" ]; then
    echo ""$INDIR" directory not found. Supply the source directory containing the images to be optimized. Source directory should be relative to location of this script. Usage: ./tinypng.sh <source_dir>"
    exit 1
fi
 
DIRNAME=${INDIR##*/}
OUTDIRNAME="${DIRNAME}_tiny"
OUTDIR="`pwd`/$OUTDIRNAME"
 
# Make sure output dir does not already exist with files.
# If dir exists but empty, it's ok, we proceed.
if find "$OUTDIRNAME" -mindepth 1 -print -quit | grep -q .; then
    echo "Output directory ($OUTDIRNAME) already exists. Exiting without optimizing images."
    exit 1
fi
 
# Create output dir if it does not already exist
if [ ! -d "$OUTDIRNAME" ]; then
    echo "Creating output dir "$OUTDIRNAME"..."
    mkdir $OUTDIRNAME   
fi
 
# Begin optimizing images
echo "Optimizing images..."
cd $INDIR
NB_FILES=$(ls | wc -l)
shopt -s nullglob
i=1
for file in *.png *.PNG *.jpg *.JPG *.jpeg *.JPEG
do
    echo "$i /$NB_FILES"
    # Cfile=`curl --dump-header /dev/stdout --silent --user api:$TINYAPIKEY --data-binary @"${file}" https://api.tinify.com/shrink | grep Location | awk '{print $2 }'`
    Cfile=${Cfile// }
    Cfile=`echo -n "$Cfile"| sed s/.$//`
    curl --silent $Cfile -o "${OUTDIR}/${file}"
    i=$((i+1));
done
echo "Optimization done"
 
# Check before replace
INDIR_FILE_COUNT="$(ls | wc -l)"
INDIR_SIZE="$(du | awk '{print $1}' | sed s/.$//g)"
cd $OUTDIR
OUTDIR_FILE_COUNT="$(ls | wc -l)"
OUTDIR_SIZE="$(du | awk '{print $1}' | sed s/.$//g)"

PLACE_SAVED=$(($INDIR_SIZE - $OUTDIR_SIZE))
PCT_SAVED=$((100*$PLACE_SAVED/$INDIR_SIZE))

if [ "$INDIR_FILE_COUNT" = "$OUTDIR_FILE_COUNT" ]; then
    echo "Replacing $INDIR folder with compressed files"
    d=$(date +%Y-%m-%d_%H%M)

    cd $INDIR/..
    tar czvf /tmp/$DIRNAME-$d.tar.gz $DIRNAME
    rm -rf $INDIR
    mv $OUTDIR $INDIR

    echo "###############"
    echo "# $PCT_SAVED %"
    echo "# About $PLACE_SAVED K"
    echo "###############"

else
    echo "Problem when retrieving files from Tinypng"
    echo "Files form $INDIR : $INDIR_FILE_COUNT"
    echo "Files retrieved from Tinypng : $OUTDIR_FILE_COUNT"
fi