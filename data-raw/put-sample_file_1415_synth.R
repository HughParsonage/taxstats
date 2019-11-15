
library(data.table)

sample_file_1516_synth <- fread(file = dir(pattern = "sample_file_1516_synth.tsv$", recursive = TRUE, full.names = TRUE)[[1]])

usethis::use_data(sample_file_1516_synth, compress = "xz", overwrite = TRUE)

