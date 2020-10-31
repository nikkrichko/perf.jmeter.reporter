#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    # fluidPage(
    #   mod_upload_jtl_file_ui("upload_jtl_file_ui_1")
    # )
    
    
    fluidPage(
      titlePanel("opening web pages"),
      tabsetPanel(id = "tabs",
                  ### tab UPLOAD file ------------------------
                  tabPanel("UPLOAD file",
                           mod_upload_jtl_file_ui("upload_jtl_file_ui_1")
                           
                  ),
                  ### tab Small report ------------------------
                  tabPanel("Small report",
                           mod_render_report_ui("render_report_ui_1")
                  ),
                  ### tab Esquisse graph generator ------------------------
                  tabPanel("Esquisse graph generator",
                           h2("esquisse"),
                           esquisserUI(
                             id = "esquisse",
                             header = FALSE,
                             disable_filters = FALSE
                           )
                  )
                  ### closing braces ----------------------
                  
      )
    )
    
    
      
    # mod_upload_jtl_file_ui("upload_jtl_file_ui_1")
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @import golem
#' @importFrom golem activate_js favicon
#' @noRd
golem_add_external_resources <- function(){
  
  golem::add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    golem::bundle_resources(
      path = app_sys('app/www'),
      app_title = 'perf.jmeter.reporter'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

