# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # Clear ----------------------------------------------------------------------
  # This trick from 
  # https://stackoverflow.com/questions/44203728/how-to-reset-a-value-of-fileinput-in-shiny
  # Allows setting the returning file to empty the reactive argupent -dat-
  status <- reactiveValues(clear = FALSE, example=FALSE)
  
  # For the clear button
  observeEvent(input$clean, {
    status$clear   <- TRUE
    status$example <- FALSE
  })
  
  
  # For the example button
  observeEvent(input$example, {
    status$example <- TRUE
    status$clear   <- FALSE
  })
  
  observeEvent(input$predfile, {
    status$clear   <- FALSE
    status$example <- FALSE
  })
  
  
  
  # Reactive arguments ---------------------------------------------------------
  dat <- reactive({
    
    if (status$example) {
      
      # Re set it to false so we can re run it
      # status$example <- FALSE
      
      return(
        list(
          expected  = cbind(rnorm(20)),
          predicted = cbind(rnorm(20))
        )
      )
    }
    
    
    # If either the clear button was clicked or predfile is empty, then null
    if (status$clear | is.null(input$predfile))
      return(NULL)
    
    ans <- readr::read_csv(input$predfile$datapath)
    with(ans, list(
      predicted = cbind(predicted),
      expected = cbind(expected)
    ))
  })
  
  # Defining the outputs -------------------------------------------------------
  
  # Table with the data that will be printed
  # Creating a nice datatable object with 5 rows per page
  output$dat <- renderDataTable({
    if (!length(dat()))
      return(NULL)
    
    as.data.frame(dat())
  }, options = list(pageLength=5))
  
  # The fancy plot
  output$predPlot <- renderPlot({
    
    # Way to go
    validate(
      need(
        dat(),
        message = "Please either select a file from your computer or click on 'Give me an example'")
      )
    
    plot_predq(dat(), main = input$main)
    
  })
  
  # # Clienty data
  # output$clientD <- renderPrint(session$clientData)
}


