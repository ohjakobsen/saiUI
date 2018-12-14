require(shiny)
require(saiUI)

ui <- singlePage(
  
  title = 'Demo',
  
  sidebarLayout(
    saiMenu(
      sliderInput('nbins', 'Number of bins', 2, 50, value = 30, step = 1)
    ),
    saiMain(
      plotOutput('distPlot')
    )
  )
  
)

server <- function(session, input, output) {
  
  output$distPlot <- renderPlot({
    
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$nbins + 1)
    
    hist(x, breaks = bins, col = 'red',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
    
  })
  
}

shinyApp(ui = ui, server = server)