#!/bin/bash
## run in the cloned repo

## fail fast
set -e

docker_img="ghcr.io/nbisweden/workshop-raukr:1.5"
docker_dir="/home/rstudio/work"

# check if in the root of the repo
if [ ! -f "_quarto.yml" ]; then
    echo "Error: Are you in the root of the repo? _quarto.yml is missing."
    exit 1
fi

# start time for whole script
start=$(date +%s.%N)

echo "Rendering home files ..."
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render index.qmd
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render home_about.qmd
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render home_faq.qmd
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render home_gallery.qmd
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render home_program.qmd
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render home_registration.qmd
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render home_schedule.qmd
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:${docker_dir} ${docker_img} quarto render home_env.qmd

echo "Rendering slides ..."
echo "Rendering labs ..."

duration=$(echo "$(date +%s.%N) - $start" | bc) && echo "Total time elapsed: $duration seconds"

echo "All files rendered successfully."
exit 0
