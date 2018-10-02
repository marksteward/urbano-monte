#!/bin/bash

# https://iiif.lib.harvard.edu/manifests/ids:45238311
# https://ids.lib.harvard.edu/ids/iiif/45238311/3072,3072,1024,304/1024,/0/default.jpg
BASE=https://ids.lib.harvard.edu/ids/iiif/45238311/

width=4872
height=3376
tilewidth=1024
tileheight=1024

function dl {
  col=$(printf '%05d' $1)
  row=$(printf '%05d' $2)
  if [[ $(stat -c%s "45238311-tiles/tile-$row,$col.jpg") -le 0 ]]; then
    wget "$BASE/$1,$2,$3,$4/full/0/default.jpg" -O "45238311-tiles/tile-$row,$col.jpg"
  fi
}

for x in $(seq 0 $tilewidth $width); do
  for y in $(seq 0 $tileheight $height); do
    dl $x $y $tilewidth $tileheight
  done
done

echo Combining
montage -mode concatenate -tile $(((width+$tilewidth-1)/$tilewidth)) 45238311-tiles/tile-*.jpg 45238311.jpg
