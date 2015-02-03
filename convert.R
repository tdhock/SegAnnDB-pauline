works_with_R("3.1.2",
             dplyr="0.4.0",
             "Rdatatable/data.table@84ba1151299ba49e833e68a2436630216b653306")

gsm.id <- "GSM634089"
txt.file <- paste0(gsm.id, ".txt")
gsm <- fread(txt.file)
header.tmp <-
  paste('track',
        'type=bedGraph',
        'db=hg19',
        'export=yes',
        'visibility=full',
        'maxSegments=20',
        'alwaysZero=on',
        'share=ugent.be',
        'graphType=points',
        'yLineMark=0',
        'yLineOnOff=on',
        'name=%s',
        'description="%s log10ratio"')
header <- sprintf(header.tmp, gsm.id, gsm.id)
out.file <- paste0(gsm.id, ".bedGraph.gz")
one <- gsm %>%
  mutate(chrom=CHROMOSOME,
         chromStart=sprintf("%d", CHR_POSITION),
         chromEnd=sprintf("%d", CHR_POSITION+1),
         signal=RATIO_LOG10) %>%
  select(chrom, chromStart, chromEnd, signal)
con <- gzfile(out.file, "w")
writeLines(header, con)
write.table(one, con, quote=FALSE, row.names=FALSE, col.names=FALSE)
close(con)
