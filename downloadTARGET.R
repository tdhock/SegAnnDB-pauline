profiles <- read.csv(url("http://52.16.111.3/csv_profiles/"))

only.target <- subset(profiles, grepl("TARGET", name))
stopifnot(nrow(only.target) == 23)

dir.create("withNaN", showWarnings=FALSE)
dir.create("withoutNaN", showWarnings=FALSE)
for(row.i in 1:nrow(only.target)){
  one <- only.target[row.i, ]
  u <- sprintf("http://52.16.111.3/secret/%s.bedGraph.gz", one$name)
  withNaN <- sprintf("withNaN/%s.bedGraph.gz", one$name)
  withoutNaN <- sprintf("withoutNaN/%s.bedGraph.gz", one$name)
  if(!file.exists(withNaN)){
    download.file(u, withNaN)
  }
  header <- readLines(withNaN, 1)
  nan <- read.table(withNaN, skip=1, header=FALSE)
  names(nan) <- c("chrom", "chromStart", "chromEnd", "logratio")
  is.bad <- is.na(nan$logratio)
  no.nan <- nan[!is.bad,]
  cat(sprintf("%4d / %4d profiles %d -> %d probes\n",
              row.i, nrow(only.target),
              nrow(nan), nrow(no.nan)))
  con <- gzfile(withoutNaN, "w")
  new.header <- gsub("TARGET", "noNaN-TARGET", header)
  writeLines(new.header, con)
  write.table(no.nan, con, quote=FALSE, sep="\t",
              row.names=FALSE, col.names=FALSE)
  close(con)
}
