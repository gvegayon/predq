#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(polygons)

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
        fileInput("predfile", "Prediction table"),
        actionButton("clean", "clear")
      ),
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("predPlot"),
         tableOutput("dat") #,
         # downloadLink("predPlot", "Save the plot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Clear ----------------------------------------------------------------------
  # This trick from 
  # https://stackoverflow.com/questions/44203728/how-to-reset-a-value-of-fileinput-in-shiny
  # Allows setting the returning file to empty the reactive argupent -dat-
  status <- reactiveValues(clear = FALSE)
  
  observeEvent(input$clean, {
    status$clear <- TRUE
  })
  
  observeEvent(input$predfile, {
    status$clear <- FALSE
  })
  
  # Reactive arguments ---------------------------------------------------------
  dat <- reactive({
    
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
  output$dat <- renderTable(dat())
  
  # The fancy plot
  output$predPlot <- renderPlot({
    if (is.null(dat()))
      return(NULL)
    
    plot_predq(dat(), main = input$main)
    
    })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

