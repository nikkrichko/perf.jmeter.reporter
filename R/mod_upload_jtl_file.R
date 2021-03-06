#' upload_jtl_file UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_upload_jtl_file_ui <- function(id, label="something"){
  library(esquisse)
  ns <- NS(id)
  tagList(
    sidebarPanel(
      h4("Import jmeter log (*.jtl-file)"),
      # actionButton(ns("reset_button"),"RESET"),
      fileInput(ns("Jmeter_uploaded_file"),"upload jmeter file",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv", ".jtl")),
      # Horizontal line -------------------------------------
      conditionalPanel(condition = "output.fileUploaded == 'TRUE'",ns = ns,
                       tags$hr(style='display: inline-block; height: 5px;width: 100%;color: #555555; background-color: #555555')
      ),
      conditionalPanel(condition = "output.fileUploaded == 'TRUE'",ns = ns,
                       radioButtons(ns("head_display"), "demo display",
                                    choices = c(All = "all",Head = "head"),
                                    selected = "all")),
      
      conditionalPanel(condition = "output.fileUploaded == 'TRUE'",ns = ns,
                       tags$hr(style='display: inline-block; height: 1px;width: 100%;color: #555555; background-color: #555555'),
                       textInput(inputId=ns("Upload_jmeter_text_input"),
                                 "Type exclude label",
                       ),
                       actionButton(ns("Clean_requests"), "Clean_requests",style='width: 100%;color: white; background-color: #008CBA')),
      
      
      conditionalPanel(condition = "output.fileUploaded == 'TRUE'",ns = ns,
                       tags$hr(style='display: inline-block; height: 1px;width: 100%;color: #555555; background-color: #555555'),
                       textInput(inputId=ns("words_to_exclude_text_input"),
                                 "Type words to delete from labels",
                       ),
                       actionButton(ns("Clean_words_from_labels"), "Clean_words_from_labels",style='width: 100%;color: white; background-color: #008CBA'),
                       ### SLA BUTTON
                       tags$hr(style='display: inline-block; height: 1px;width: 100%;color: #555555; background-color: #555555'),
                       textInput(inputId=ns("simple_sla"),
                                 "Define simple SLA (only numbers)",
                       ),
                       actionButton(ns("simple_sla_btn"), "Sefine SLA",
                                    style='width: 100%;color: white; background-color: #008CBA'),
                       
                       
                       ),
      conditionalPanel(condition = "output.fileUploaded == 'TRUE'",ns = ns,
                       tags$hr(style='display: inline-block; height: 1px;width: 100%;color: #555555; background-color: #555555'),
                       h5("select how many % of request you want to see in report"),
                       h6("(less - improve performance)"),
                       sliderInput(ns("percent_dots_to_show"), "Percent dots to show",
                                   min = 0, max = 100,
                                   value = 10)
      ),
      conditionalPanel(condition = "output.fileUploaded == 'TRUE'",ns = ns,
                       tags$hr(style='display: inline-block; height: 1px;width: 100%;color: #555555; background-color: #555555'),
                       actionButton(ns("end_with_preparation_button"), "End_with_prepadation",style='width: 100%;color: white; background-color: #4CAF50'))
      
    ),
    mainPanel(
      conditionalPanel( condition = "output.fileUploaded == 'TRUE'",ns = ns,
                        h2("Preview")),
      verbatimTextOutput(ns("list_unique_labels")),
      DT::dataTableOutput(ns("uploaded_contents"))
    )
    
  )
}
    
#' upload_jtl_file Server Function
#'
#' @noRd 
mod_upload_jtl_file_server <- function(input, output, session){
  library(shiny)
  library(DT)
  library(tidyverse)
  library(data.table)
  library(ggplot2)
  library(esquisse)
  library(shinycssloaders)
  library(lubridate)
  library(report.preprocessing)
  options(scipen = 99999)
  ns <- session$ns

                 # output$uploaded_contents <- renderTable({
                 
                 # input$file1 will be NULL initially. After the user selects
                 # and uploads a file, head of that data file by default,
                 # or all rows if selected, will be shown.
                 temp <- reactiveValues(data = NULL,
                                        exclude_filter = '',
                                        exclude_words='',
                                        end_with_preparation=FALSE,
                                        list_unique_labels='',
                                        simple_sla='')
                 
                 set_exclude_filter_false = function() {
                   # do stuff
                   print("set filter false")
                   temp$exclude_filter <- FALSE
                 }
                 
                 userFile <- reactive({
                   # If no file is selected, don't do anything
                   validate(need(input$Jmeter_uploaded_file, message = FALSE))
                   temp$exclude_filter = ''
                   temp$exclude_words=''
                   temp$end_with_preparation=FALSE
                   temp$list_unique_labels=''
                   simple_sla=''
                   # print(input$Jmeter_uploaded_file)
                   input$Jmeter_uploaded_file
                 })
                 
                 
                 dataframe <- reactive({
                   print("uploading from file")
                   data <-read.csv(userFile()$datapath) %>% as.data.table()
                 })
                 
                 
                 temp$data <- reactive({
                   data <- dataframe()
                   data
                 })
                 
                 
                 
                 output$fileUploaded <- reactive({
                   if(!is.null(temp$data())){
                     result <- "TRUE"
                   } else {
                     result  <- "FALSE"
                   }
                   if(temp$end_with_preparation){
                     result  <- "FALSE"
                   }
                   return(result)
                 })
                 outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)
                 
                 
                 observeEvent(input$Clean_requests, {
                   req(input$Clean_requests)
                   temp$exclude_filter <- input$Upload_jmeter_text_input
                 })
                 
                 observeEvent(input$simple_sla_btn, {
                   req(input$simple_sla_btn)
                   temp$simple_sla=input$simple_sla
                 })
                 
                 
                 observeEvent(input$Clean_words_from_labels, {
                   req(input$Clean_words_from_labels)
                   temp$exclude_words <- input$words_to_exclude_text_input
                 })
                 
                 observeEvent(input$end_with_preparation_button, {
                   req(input$end_with_preparation_button)
                   temp$end_with_preparation <- TRUE
                   
                 })
                 
                 # observeEvent(input$reset_button, {
                 #   req(input$reset_button)
                 #
                 #   # temp$data() = NULL
                 #   temp$exclude_filter = ''
                 #   temp$exclude_words=''
                 #   temp$end_with_preparation=FALSE
                 #   temp$list_unique_labels=''
                 # })
                 
                 
                 
                 
                 
                 delete_specific_words <- function(input_dt, delete_words_list=NULL){
                   if(!is.null(delete_words_list)){
                     for (delete_word in delete_words_list){
                       input_dt$label <- input_dt$label %>% sub(delete_word, "", ., ignore.case = TRUE)
                     }
                   }
                   input_dt
                 }
                 
                 
                 output$uploaded_contents <- DT::renderDataTable({
                   # print("RENDER DATA TABLE function ------------")
                   
                   data <- temp$data() %>% as.data.table()
                   
                   ### display only head or all
                   if(input$head_display == "head"){
                     data <- head(data)
                   }
                   
                   if(nchar(temp$exclude_filter) > 1 ){
                     req(input$Clean_requests)
                     
                     list_of_words_to_exclude <- strsplit(temp$exclude_filter, ",")[[1]] %>%
                       trimws() %>%
                       paste(collapse = "|")
                     # print(list_of_words_to_exclude)
                     # print("Clean_requests button was pressed")
                     data <- data[!grepl(list_of_words_to_exclude, label),] 
                     
                     # temp$exclude_filter <- FALSE
                     
                   }
                   
                   
                   if(nchar(temp$exclude_words) > 1 ){
                     req(input$Clean_words_from_labels)
                     list_of_words_to_exclude <- strsplit(temp$exclude_words, ",")[[1]] %>%
                       trimws()
                     # print(list_of_words_to_exclude)
                     # print("Clean_words button was pressed")
                     data <- delete_specific_words(data,list_of_words_to_exclude)
                   }
                   if(temp$end_with_preparation){
                     # print("Assigning results data ++++++++++++++++++++++++++++++++")
                     result_data <- data %>% as.data.table()
                     result_data[,":="("request_name"=label)]
                     result_data[,":="("response_time"=round(elapsed))]
                     
                     # result_data[,":="("responseCode"=as.factor(responseCode))]
                     # result_data[,":="("responseCode"=as.factor(responseCode))]
                     # result_data[,":="("responseCode"=as.factor(responseCode))]
                     # result_data[,":="("responseCode"=as.factor(responseCode))]
                     
                     # result_data[,":="("timeStamp"=as.numeric(timeStamp)/1000)]
                     # result_data[,":="("request_name"=label)]
                     # result_data[,":="("request_name"=label)]
                     # result_data[,":="("request_name"=label)]
                     
                     
                     # result_data$timeStamp <- as.numeric(result_data$timeStamp)
                     # result_data$timeStamp <- as.POSIXct(result_data$timeStamp/1000, origin="1970-01-01")
                     
                     
                     
                     # result_data$dateTime <- ymd_hms(as.POSIXct(as.numeric(result_data$timeStamp)/1000, origin="1970-01-01"))
                     
                     # result_data$dateTime <- as.character(as.POSIXct(as.numeric(result_data$timeStamp)/1000, origin="1970-01-01", tz="UTC"))
                     
                     
                     # result_data$responseCode <- as.factor(result_data$responseCode)
                     # result_data$responseMessage <- as.factor(result_data$responseMessage)
                     # result_data$elapsed <- as.numeric(result_data$elapsed)
                     # result_data$date <- as.Date(result_data$dateTime)
                     result_data$dateTime <- ymd_hms(as.POSIXct(as.numeric(result_data$timeStamp)/1000, origin="1970-01-01"))
                     result_data$time <- format(result_data$dateTime, "%H:%M:%OS3")
                     # result_data$fulltime <- as.POSIXct(result_data$timeStamp, origin="1970-01-01")
                     result_data$success <- as.logical(result_data$success)
                     result_data$Latency <- as.numeric(result_data$Latency)
                     # result_data$request_name <- as.factor(result_data$label)
                     
                     
                     # result_data[sample(.N,NROW(result_data)/10)]
                     
                     # result_data <<- result_data
                     ### ????????????
                     result_data <<- result_data[sample(.N,round(NROW(result_data)*input$percent_dots_to_show/100))]
                     # result_data <<- result_data[sample(.N,round(NROW(result_data)*10/100))]
                     
                     assign("result_data", result_data)
                     
                   }
                   # print( unique(data$label))
                   temp$list_unique_labels <- unique(data$label)
                   
                   if(temp$simple_sla != "") {
                     transfer_sla <- as.numeric(temp$simple_sla)
                     assign("transfer_sla", transfer_sla, envir = .GlobalEnv)
                     # 
                     # print(paste("upload module: SLA=",transfer_sla,"====================="))
                     # print(paste("upload module: transfer_sla=",transfer_sla,"====================="))
                     data <- data %>% datatable() %>% 
                       formatStyle('elapsed', 
                                   fontWeight = styleInterval(transfer_sla, c('normal', 'bold')),
                                   backgroundColor = styleInterval(transfer_sla, 
                                                                c("", "tomato")),
                                   color = styleInterval(transfer_sla, 
                                                         c("", "white")), 
                                   fontSize = styleInterval(transfer_sla, 
                                                            c("", "200%")))
                        
                   } else {
                     assign("transfer_sla", "", envir = .GlobalEnv)
                   }
                   
                   data
                   
                 })
                 
                 
                 output$list_unique_labels <- renderText({
                   if(length(temp$list_unique_labels)>1){
                     paste("UNIQUE LABELS:\nAMOUNT:",length(unique(temp$list_unique_labels)),"\n",
                           paste(unique(temp$list_unique_labels), collapse = "\n"), sep = "")
                   }
                 })
                 
                 
                 observe({
                   msg <- sprintf("File %s was uploaded", userFile()$name)
                   cat(msg, "\n")
                 })
                 
                 
               
   # end module server
 
}
    
## To be copied in the UI
# mod_upload_jtl_file_ui("upload_jtl_file_ui_1")
    
## To be copied in the server
# callModule(mod_upload_jtl_file_server, "upload_jtl_file_ui_1")
 
