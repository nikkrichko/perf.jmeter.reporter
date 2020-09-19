get_html_report <-
function(){
  rmarkdown::render("test.Rmd")
}


generate_test_report <- function(output_dir=getwd()){
  file <- system.file("Rmd","test.Rmd", package = 'perf.jmeter.reporter')
  if (missing(output_dir)) {
    output_dir <- getwd()
  }
  rmarkdown::render(file, output_dir = output_dir)
}






generate_report <- function(input_jtl_file_path=NULL,input_data_table=NULL, output_dir=getwd(), output_file="test_out_put.html"){
  file <- system.file("Rmd","test.Rmd", package = 'perf.jmeter.reporter')
  if (missing(output_dir)) {
    output_dir <- getwd()
  }
  rmarkdown::render(file, params=list(input_file_path = input_jtl_file_path,
                                      input_data_table       = input_data_table),
                                      output_dir      = output_dir,
                                      output_file     = output_file)
}



# rmarkdown::render(file, params=list(input_file_path = input_jtl_file_path,
#                                     input_data_table       = input_data_table),
#                   output_dir      = output_dir,
#                   output_file     = output_file)
