#!/bin/bash

# https://www.davidrumsey.com/MediaManager/srvr?mediafile=/JP2K/RUMSEY~8~1/179/10130011.jp2&x=12000&y=9000&width=467&height=251&level=0
BASE=https://www.davidrumsey.com/MediaManager/srvr?mediafile=/JP2K/RUMSEY~8~1/179/10130011.jp2

width=12467
height=9251
tilewidth=750
tileheight=750

function dl {
  col=$(printf '%05d' $1)
  row=$(printf '%05d' $2)
  if [[ $(stat -c%s "10130011-tiles/tile-$row,$col.jpg") -le 0 ]]; then
    wget "$BASE&x=$1&y=$2&width=$3&height=$4&level=0" -O "10130011-tiles/tile-$row,$col.jpg"
  fi
}

for x in $(seq 0 $tilewidth $((width - 750))); do
  for y in $(seq 0 $tileheight $((height - 750))); do
    dl $x $y $tilewidth $tileheight
  done
  y=9000
  dl $x $y $tilewidth 251
done
x=12000
for y in $(seq 0 $tileheight $((height - 750))); do
  dl $x $y 467 $tileheight
done
y=9000
dl $x $y 467 251

echo Combining
montage -mode concatenate -tile $(((width+$tilewidth-1)/$tileheight)) 10130011-tiles/tile-*.jpg 10130011.jpg
