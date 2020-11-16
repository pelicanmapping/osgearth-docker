#!/usr/bin/env bash
MIN_LEVEL=0
MAX_LEVEL=8
MIN_X=-180.0
MIN_Y=-90.0
MAX_X=180.0
MAX_Y=90.0
FILENAME=""
JOB=0
DESTINATION=s3://pelican-public/results/

EARTH=""
LAYER=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --min-x) MIN_X="$2"; shift ;;
        --min-y) MIN_Y="$2"; shift ;;
        --max-x) MAX_X="$2"; shift ;;
        --max-y) MAX_Y="$2"; shift ;;
        --min-level) MIN_LEVEL="$2"; shift ;;
        --max-level) MAX_LEVEL="$2"; shift ;;
        --filename) FILENAME="$2"; shift ;;
        --destination) DESTINATION="$2"; shift ;;
        --earth) EARTH="$2"; shift ;;
        --layer) LAYER="$2"; shift ;;
        --job) JOB="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "MIN_LEVEL=$MIN_LEVEL MAX_LEVEL=$MAX_LEVEL EXTENTS=$EXTENTS FILENAME=$FILENAME JOB=$JOB DESTINATION=$DESTINATION"

# Export an mbtiles
#osgearth_conv --in driver gdalimage \
#              --in url $FILENAME \
#              --out driver mbtilesimage \
#              --out format webp \
#              --out filename $JOB.mbtiles \
#              --extents $MIN_Y $MIN_X  $MAX_Y $MAX_X \
#              --min-level $MIN_LEVEL \
#              --max-level $MAX_LEVEL
#aws s3 cp $JOB.mbtiles s3://pelican-public/results/$JOB.mbtiles

# Export TMS
#osgearth_conv --in driver gdalimage \
#              --in url $FILENAME \
#              --out driver tmsimage \
#              --out format webp \
#              --out url tiles/tms.xml \
#              --extents $MIN_Y $MIN_X  $MAX_Y $MAX_X \
#              --min-level $MIN_LEVEL \
#              --max-level $MAX_LEVEL

# Export TMS from an earth file
osgearth_conv --in-earth $EARTH \
              --in-layer "$LAYER" \
              --out driver tmselevation \
              --out format tif \
              --out url tiles/tms.xml \
              --extents $MIN_Y $MIN_X  $MAX_Y $MAX_X \
              --min-level $MIN_LEVEL \
              --max-level $MAX_LEVEL \
              --osg-options "tiff_compression=lzw"
aws s3 sync --acl public-read tiles $DESTINATION