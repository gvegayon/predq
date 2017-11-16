#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Need to use the polygons package
if (!require(polygons)) {
  devtools::install_github("USCBiostats/polygons")
  library(polygons)
}
 
if (!require(readr)) {
  devtools::install_github("hadley/readr")
  library(readr)
} 


# You can actually run source code!
source("plot_predq.r")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Visualizing your Predictions"),
   HTML("This shiny app uses the R package <a href='https://github.com/USCBiostats/polygons' target=_blank>polygons</a>"),
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        textInput("main", "Title of the plot", value = "Predicted vs Observed"),
        hr(),
        fileInput("predfile", "Prediction table"),
        helpText("The file must be a CSV file with two columns, \"predicted\" and \"observed\"."),
        hr(),
        fluidRow(
          column(12, actionButton("clean", "Clear the data")),
          column(12, actionButton("example", "Give me an example"))
        )
        ),
      # Show a plot of the generated distribution
      mainPanel(
        h2("The fancy plot"),
         plotOutput("predPlot"),
         h2("Data"),
         dataTableOutput("dat"),
         HTML(markdown::renderMarkdown(text="## Client data `session`")),
         verbatimTextOutput("clientD")#,
         # downloadLink("predPlot", "Save the plot")
      )
   )
   
)

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
          expected  = cbind(runif(20)),
          predicted = cbind(runif(20))
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
    if (is.null(dat()))
      return(NULL)
    
    plot_predq(dat(), main = input$main)
    
    })
  
  # Clienty data
  output$clientD <- renderPrint(session$clientData)
}

# Run the application 
shinyApp(ui = ui, server = server)

