#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import data.table
#' @import shinycssloaders
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  # callModule(mod_upload_jtl_file_server, "upload_jtl_file_ui_1")
  
  options(shiny.maxRequestSize=100*1024^2)
  callModule(mod_upload_jtl_file_server, "upload_jtl_file_ui_1")
  
  data_r <- reactiveValues(data = "", name = "")
  transfer_sla1 <- reactiveValues(sla="")
  
  observeEvent(input$tabs, {
    if(input$tabs == "Esquisse graph generator" & exists("result_data")){
      data_r$data <- result_data
      data_r$name <- "result_data"
      
      callModule(module = esquisserServer, id = "esquisse",data=data_r)
    }
  }
  )
  
  observeEvent(input$tabs, {
    if(input$tabs == "Small report" & exists("result_data")){
      
      showNotification("Please wait some moment\nYour report generation ...\nIN PROGRESS....\nFEW MORE MOMENT\nJUST WAIT...",
                       type="warning",duration = 10)
      # render_report_server("small_report",get("result_data") )
      # browser()
      print("server module transfer SLA: =====================================")
      # transfer_sla <- get("transfer_sla")
      # print(transfer_sla)
      # transfer_sla1$sla <- transfer_sla
      # print(transfer_sla)
      # print(transfer_sla1$sla)
      data_r$data <- result_data
      
      callModule(mod_render_report_server, "render_report_ui_1",input_dt=data_r$data, input_sla=transfer_sla)
      
    }
  }
  )
  
  
  
  
}
