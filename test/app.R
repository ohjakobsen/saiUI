#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

require(shiny)
require(saiUI)
require(htmltools) # dependency must be added to saiUI

# Define UI for application that draws a histogram
ui <- saiPage(
  title = 'Test av UI',

  tabPanel(title = 'Tab 1',
    saiMenu(
      p('Hello world'),
      selectInput('test', 'Test', choices = c('A', 'B'), selected = 'A')
    ),
    saiMain(
      p('Hello world')
    )
  )

)

# Define server logic required to draw a histogram
server <- function(input, output) {

   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)

      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application
shinyApp(ui = ui, server = server)

