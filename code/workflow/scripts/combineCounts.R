library(data.table)
library(purrr)


args <- commandArgs(trailingOnly = TRUE)


inFiles <- args[1:(length(args)-1)]
outFile <- args[length(args)]

counts <- map(inFiles, fread)

idcols <- counts[[1]][, 1:6]
datacols <- map_dfc(counts, ~.x[, 7])
tbl <- cbind(idcols, datacols)

fwrite(tbl, outFile, sep = "\t")
