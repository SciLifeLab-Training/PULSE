# Docker

Almost all the tools, packages and environment required to run and build all the workshop slides, labs and website are included in this docker image. 

Below are instructions on building and using the docker image.

## Build

```bash
# build the container
docker build --platform=linux/amd64 -t ghcr.io/nbisweden/workshop-raukr:1.5.1 --file docker/dockerfile docker/

# add additional tags
docker tag ghcr.io/nbisweden/workshop-raukr:1.5.1 ghcr.io/nbisweden/workshop-raukr:latest

# push to ghcr repo
docker push ghcr.io/nbisweden/workshop-raukr:1.5.1
docker push ghcr.io/nbisweden/workshop-raukr:latest
```

:warning: Build takes about 3 hours and final image size is about 14GB

## Rstudio

The image contains Rstudio server, so you can work interactively in an Rstudio environment.

```bash
docker run --platform=linux/amd64 --rm -e PASSWORD=raukr -p 8787:8787 -p 4200:4200 -v ${PWD}:/home/rstudio/work ghcr.io/nbisweden/workshop-raukr:latest
```

In a web browser, go to [http://localhost:8787/](http://localhost:8787/). Use following credentials:

> username: rstudio  
> password: raukr

Then set working directory to `/home/rstudio/work`.

## Render

You can convert quarto documents to HTML.

```bash
# render whole website
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:/home/rstudio/work ghcr.io/nbisweden/workshop-raukr:latest quarto render

# render single page
docker run --platform=linux/amd64 --rm -u 1000:1000 -v ${PWD}:/home/rstudio/work ghcr.io/nbisweden/workshop-raukr:latest quarto render index.qmd
```

## Updating docker image

:warning: Risk of overwriting current image on GHCR if tags are not updated!

If new packages are added/required, then they need to be added to the docker image as well. It is assumed that you are working in the container. Add packages as you normally would. Once your new materials and new packages are finalized, follow the steps below.

- Update the `renv.lock` file. You need to run this in R in the container and in the root of the repo. This will add your new packages to `renv.lock`. Pay attention to what is changed. If it looks ok, go forward.

```
renv::snapshot(type="all")
```

- Rebuild the container with the new packages. Run this in a local terminal in the root of the repo. **Increment the version number as needed.**

```
docker build --platform=linux/amd64 -t ghcr.io/nbisweden/workshop-raukr:2025-2 -t ghcr.io/nbisweden/workshop-raukr:latest --file dockerfile .
```

- Push image back to repository

```
# login if needed
# echo "personalaccesstoken" | docker login ghcr.io -u githubusername --password-stdin

docker push ghcr.io/nbisweden/workshop-raukr:2025-2
docker push ghcr.io/nbisweden/workshop-raukr:latest
```
