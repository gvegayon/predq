#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# You can actually run source code within a Shiny app!
# there's also 
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
      dataTableOutput("dat") #,
      # HTML(markdown::renderMarkdown(text="## Client data `session`")),
      # verbatimTextOutput("clientD")#,
      # downloadLink("predPlot", "Save the plot")
    )
  )
  
)
