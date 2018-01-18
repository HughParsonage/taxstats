
library(data.table)

sample_file_1415_synth <- fread(file = dir(pattern = "sample_file_1415_synth.tsv$", recursive = TRUE, full.names = TRUE)[[1]])

devtools::use_data(sample_file_1415_synth)

