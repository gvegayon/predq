library(shiny)

# You can actually run source code within a Shiny app!
# there's also 
source("plot_predq.r")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Visualizing your Predictions"),
  p(
    "This shiny app uses the R package ",
    a("polygons", href='https://github.com/USCBiostats/polygons', target="_blank"),
    ", and you can checkout the source code ",
    a("here", href="https://github.com/gvegayon/predq"), "."
    ),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      hr(),
      textInput("main", "Title of the plot", value = "Predicted vs Observed"),
      textInput("keymain", "Title of the color key", value = ""),
      hr(),
      textInput("colors", "Base colors", value = "steelblue, lightgray, darkred"),
      helpText("Comma separated values. Should be valid R colors."),
      hr(),
      fileInput("predfile", "Prediction table"),
      helpText("The file must be a CSV file with two columns, \"predicted\" and \"expected\"."),
      hr(),
      fluidRow(
        column(12, actionButton("clean", "Clear the data")),
        column(12, actionButton("example", "Give me an example"))
      )
    ),
    # Show a plot of the generated distribution
    mainPanel(
      h2("Visualizing your predictions"),
      p("This shiny app allows you to visualize the 'quality of your predictions'.",
        "The input data, as described in the panel, should a CSV file with two named",
        "columns: predicted, and, expected. Once read, the app will generate a pie-like",
        "plot in which each slice represents a row (all of the same width), and",
        "each slice has two parts: the predicted (outer) and expected (inner).",
        "If the values of both predicted and expected coincide, then the slice",
        "will be attached to the core of the plot, otherwise, the more different",
        "those values are, the more the slice will get away from the core approaching",
        "the borders."
        ),plotOutput("predPlot"),
      h2("Data"),
      dataTableOutput("dat")
    )
  )
  
)
