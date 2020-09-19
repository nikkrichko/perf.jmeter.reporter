#' render_report UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import shinycssloaders
mod_render_report_ui <- function(id){
  
  ns <- NS(id)
  tagList(
    fluidPage(
      downloadButton(ns("downloadData"), label = "Download extended report"),
      shiny::actionButton(inputId = ns("gen_report"), label = "Open extended report in new tab"),
      shinycssloaders::withSpinner(dataTableOutput(ns("aggregated_data_table")),
                                   type = getOption("spinner.type", default = 4),
                                   color = getOption("spinner.color", default = "#0275D8"),
                                   size = getOption("spinner.size", default = 1.5))
      
      # htmlOutput(ns("inc"))
      )
  )
}
    
#' render_report Server Function
#'
#' @noRd 
mod_render_report_server <- function(input, output, session, input_dt){
                 ### setup requirement variables
                 myhtmlfilepath <- "C:/temp" # change to your path
                 temp_dir_path <- paste(myhtmlfilepath,"/",sep = "")
                 temp_file_name <- paste("jtl_input_dt_",format(Sys.time(), "%Y%m%d_%H%M%S"),".html",sep = "")
                 # browser()
                 addResourcePath('myhtmlfiles', myhtmlfilepath)
                 source_path_for_iframe <- paste0("myhtmlfiles/",temp_file_name)
                 full_path_to_ready_report_file <- paste(temp_dir_path,temp_file_name, sep="")
                 # browser()
                 
                 
                 output$aggregated_data_table <- renderDataTable({
                   
                   perf.jmeter.reporter:::generate_report(input_data_table=input_dt,
                                                          output_dir = myhtmlfilepath,
                                                          output_file = temp_file_name)
                   
                   res_aggregated_dt <- report.preprocessing::clean_jmeter_log(input_dt,
                                                                               delete_ending_digets=FALSE,
                                                                               delete_words_from_labels = NULL,
                                                                               labels_to_delete_list=NULL) %>% 
                   report.preprocessing::get_aggregate_table()
                   res_aggregated_dt
                 })
                 
                 
                 
                 
                 # getPage <- function() {
                 #   print(head(input_dt))
                 #   # browser()
                 #   # # report.preprocessing:::
                 #   # perf.jmeter.reporter:::generate_report(input_data_table=input_dt,
                 #   #                                        output_dir = "c:\\temp\\",#myhtmlfilepath,
                 #   #                                        output_file = "jtl_input_dt.html")#temp_file_name)
                 #   # 
                 #   
                 #   # 
                 #   
                 #   
                 #   browser()
                 #   # file <- system.file("Rmd","test.Rmd", package = 'perf.jmeter.reporter')
                 #   
                 #   browser()
                 #   
                 #   # if (missing(output_dir)) {
                 #   #   output_dir <- getwd()
                 #   # }
                 #   input_dt <- result_data
                 #   print(unique(input_dt$label))
                 #   # rmarkdown::render(file, params=list(input_file_path = NULL,
                 #   #                                     input_data_table       = input_dt),
                 #   #                   output_dir      = "c:\\temp\\",
                 #   #                   output_file     = "jtl_input_dt.html")
                 #   
                 #   # browser()
                 #   # generate_report(input_jtl_file_path=NULL,
                 #   #                             input_data_table=NULL, 
                 #   #                             output_dir="c:\\temp\\",
                 #   #                             output_file="test_out_put_from_manual_function.html")
                 #     
                 #   # browser()
                 #   
                 #   
                 #   
                 #   
                 #   # perf.jmeter.reporter:::generate_test_report()
                 #   
                 #   browser()
                 #   # return(tags$iframe(src = source_path_for_iframe,
                 #   #                    height = "1200px",
                 #   #                    width = "100%",
                 #   #                    scrolling = "yes",
                 #   #                    seamless=TRUE))
                 #   return(includeHTML("c:\\temp\\jtl_input_dt.html"))
                 #   
                 # }
                 
                 # getPage <- function() {
                 #   return(includeHTML(full_path_to_ready_report_file))
                 # }
                 
                 observeEvent(input$gen_report,{
                   browseURL(full_path_to_ready_report_file)
                 })
                 
                 
                 
                 
                 
                 # output$inc <- renderUI({getPage()})
                 # output$inc <- renderUI({
                 #                            tags$iframe(src = "c:/temp/jtl_input_dt.html",
                 #                                     height = "1200px",
                 #                                     width = "100%",
                 #                                     scrolling = "yes",
                 #                                     seamless=TRUE)
                 #   })
                 # output$inc <- renderUI({
                 #   tagList(
                 #     sliderInput("n", "N", 1, 1000, 500),
                 #     textInput("label", "Label")
                 #   )
                 #   })
                 # browser()
                 
                 
                 
                 output$downloadData <- downloadHandler(
                   filename <- function() {
                     temp_file_name
                   },
                   content  <- function(file) {
                     file.copy(full_path_to_ready_report_file, file)
                   },
                   contentType = "html"

                 )
                 # browser()
              
}
    
## To be copied in the UI
# mod_render_report_ui("render_report_ui_1")
    
## To be copied in the server
# callModule(mod_render_report_server, "render_report_ui_1")
 
