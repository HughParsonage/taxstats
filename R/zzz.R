
.onLoad <-function(libname = find.package("taxstats"), pkgname = "taxstats"){
  if (getRversion() >= "2.15.1"){
    utils::globalVariables(c("sample_file_0304", "sample_file_0405", "sample_file_0506", "sample_file_0607",
                             "sample_file_0708", "sample_file_0809", "sample_file_0910", "sample_file_1011",
                             "sample_file_1112", "sample_file_1213", "sample_file_1314"))
  }
}

