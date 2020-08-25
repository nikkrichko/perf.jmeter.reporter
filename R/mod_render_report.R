#' render_report UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_render_report_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      downloadButton(ns("downloadData"), label = "Download this report"),
      htmlOutput(ns("inc"))
    )
  )
}
    
#' render_report Server Function
#'
#' @noRd 
mod_render_report_server <- function(input, output, session){
  moduleServer(id,
               function(input, output, session){
                 ### setup requirement variables
                 myhtmlfilepath <- "C:/temp" # change to your path
                 temp_dir_path <- paste(myhtmlfilepath,"/",sep = "")
                 temp_file_name <- "jtl_input_dt.html"
                 addResourcePath('myhtmlfiles', myhtmlfilepath)
                 source_path_for_iframe <- paste0("myhtmlfiles/",temp_file_name)
                 full_path_to_ready_report_file <- paste(temp_dir_path,temp_file_name, sep="")
                 
                 
                 
                 getPage<-function() {
                   
                   report.preprocessing:::generate_report(input_data_table=input_dt,
                                                          output_dir = myhtmlfilepath,
                                                          output_file = temp_file_name)
                   
                   return(tags$iframe(src = source_path_for_iframe,
                                      height = "1200px",
                                      width = "100%",
                                      scrolling = "yes",
                                      seamless=TRUE))
                   
                 }
                 
                 output$inc<-renderUI({getPage()})
                 
                 output$downloadData <- downloadHandler(
                   filename <- function() {
                     paste("small_report_",Sys.Date(),".html",sep="")
                   },
                   content  <- function(file) {
                     file.copy(full_path_to_ready_report_file, file)
                   },
                   contentType = "html"
                   
                 )
               }
  )
 
}
    
## To be copied in the UI
# mod_render_report_ui("render_report_ui_1")
    
## To be copied in the server
# callModule(mod_render_report_server, "render_report_ui_1")
 
