#' test UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_test_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' test Server Function
#'
#' @noRd 
mod_test_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_test_ui("test_ui_1")
    
## To be copied in the server
# callModule(mod_test_server, "test_ui_1")
 
