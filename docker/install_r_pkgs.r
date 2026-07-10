## Install R packages from renv.lock file
## Attempts to install exact version else tries to install the latest available version

library(renvtools)
library(rlang)
library(remotes)
library(dplyr)

# Set to FALSE to attempt installing exact version
update <- TRUE
options(repos = c(
  CRAN = "https://packagemanager.rstudio.com/all/latest"
))

# read -------------------------------------------------------------------------

dfr <- read_lock("renv.lock", format = "tibble")

# install cran pkgs ------------------------------------------------------------

errs <- vector("list")

pkgdf <- filter(dfr, Source == "Repository", Repository %in% c("RSPM", "CRAN"))
if (nrow(pkgdf) > 0) {
  for (i in 1:nrow(pkgdf)) {
    pkg <- pkgdf$Package[i]
    tryCatch(
      {
        if (!pkg %in% rownames(installed.packages()) || update) {
          if (update) {
            install.packages(pkg)
          } else {
            remotes::install_version(pkg, version = pkgdf$Version[i], upgrade = "never")
          }
        }
      },
      error = function(e) {
        install.packages(pkg)
        errs <- c(errs, data.frame(
          source = pkgdf$Source[i],
          repository = pkgdf$Repository[i],
          pkg = pkg,
          old_ver = pkgdf$Version[i],
          new_ver = ifelse(
            pkg %in% rownames(installed.packages()),
            packageVersion(pkg),
            NA
          )
        ))
      }
    )
  }
}

# renv::install(pkgs,prompt=FALSE)
# pak::pkg_install(pkgs,ask=FALSE,upgrade=TRUE)

# install bioc pkgs ------------------------------------------------------------

# BiocManager::install(version='devel',update=TRUE,ask=FALSE)
pkgdf <- filter(dfr, Source == "Bioconductor")
if (nrow(pkgdf) > 0) {
  for (i in 1:nrow(pkgdf)) {
    pkg <- pkgdf$Package[i]
    tryCatch(
      {
        if (!pkg %in% rownames(installed.packages()) || update) {
          if (update) {
            BiocManager::install(pkg, update = TRUE, ask = FALSE)
          } else {
            BiocManager::install(pkg, version = pkgdf$Version[i], update = FALSE, ask = FALSE)
          }
        }
      },
      error = function(e) {
        BiocManager::install(pkg, update = TRUE, ask = FALSE)
        errs <- c(errs, data.frame(
          source = pkgdf$Source[i],
          repository = pkgdf$Repository[i],
          pkg = pkg,
          old_ver = pkgdf$Version[i],
          new_ver = ifelse(
            pkg %in% rownames(installed.packages()),
            packageVersion(pkg),
            NA
          )
        ))
      }
    )
  }
}

# install github pkgs ----------------------------------------------------------

pkgdf <- filter(dfr, Source == "GitHub")
if (nrow(pkgdf) > 0) {
  for (i in 1:nrow(pkgdf)) {
    pkg <- pkgdf$Package[i]
    tryCatch(
      {
        if (!pkg %in% rownames(installed.packages()) || update) {
          if (update) {
            repo <- paste(pkgdf$RemoteUsername[i], pkgdf$RemoteRepo[i], sep = "/")
            ref <- pkgdf$RemoteRef[i]
            host <- pkgdf$RemoteHost[i]
            remotes::install_github(repo = repo, ref = ref, host = host)
          } else {
            repo <- paste(paste(pkgdf$RemoteUsername[i], pkgdf$RemoteRepo[i], sep = "/"), pkgdf$RemoteSha[i], sep = "@")
            ref <- pkgdf$RemoteRef[i]
            host <- pkgdf$RemoteHost[i]
            remotes::install_github(repo = repo, ref = ref, host = host)
          }
        }
      },
      error = function(e) {
        repo <- paste(pkgdf$RemoteUsername[i], pkgdf$RemoteRepo[i], sep = "/")
        ref <- pkgdf$RemoteRef[i]
        host <- pkgdf$RemoteHost[i]
        remotes::install_github(repo = repo, ref = ref, host = host)

        errs <- c(errs, data.frame(
          source = pkgdf$Source[i],
          repository = pkgdf$Repository[i],
          pkg = pkg,
          old_ver = pkgdf$Version[i],
          new_ver = ifelse(
            pkg %in% rownames(installed.packages()),
            packageVersion(pkg),
            NA
          )
        ))
      }
    )
  }
}

# complete ---------------------------------------------------------------------

# write installation issues and version mismatches
if (length(errs) != 0) write.table(dplyr::bind_rows(errs), file = "pkgs-err.txt", sep = "\t", col.names = T, quote = F, row.names = F)

if (update) update.packages(ask = FALSE)
