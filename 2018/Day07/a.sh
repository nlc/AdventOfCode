#!/usr/bin/bash

declare -A adjacency

while read -r vertex; do
  key=$(echo $vertex | cut -d' ' -f1)
  val=$(echo $vertex | cut -d' ' -f2)
  # echo "$key -> $val"
  adjacency[$key]="${adjacency[$key]},$val"
  echo "$key -> ${adjacency[$key]}"
done < graph.txt
