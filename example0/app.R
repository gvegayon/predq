library(shiny)

# User interface
# The UI is what the user will be able to see
ui <- fluidPage(
  
  # Application title
  titlePanel("Here goes the title of your App!"),
  
  # Writing 'paragraphs'
  p(
    "This is a very simple shiny app. In this example the only input is the color",
    "that the user wants to plot the ", code("USArrets"), " dataset with."
    ),
  
  # Here we are using the sidebarLayout 
  verticalLayout(
    
    # Enter values
    textInput("color", "Select a color", value = "blue"),

    # Output values as defined in -server.R
    textOutput("text_out"),
    plotOutput("plot_out")
  )
  
)

# server
# The server function is what does all the work in the back 
server <- function(input, output) {
  
  # Whatever was entered by the user will be stored in the `input`.
  # To return objects we need to put them in `output` using the `render*`
  # functions: 
  output$text_out  <- renderText(paste("You selected", input$color))
  output$plot_out  <- renderPlot({
    
    # Does the color exists
    validate(need(input$color, "Please specify a color."))
    validate(
      need(
        is.matrix(try(col2rgb(input$color), silent = TRUE)),
        "Please make sure that the color exists!"
        )
      )
    
    plot(USArrests, col = input$color, pch=20)
  })
  
}

shinyApp(ui = ui, server = server)
