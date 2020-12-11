require(saiUI)

ui <- saiPage(
  
  title = 'Demo',
  id = 'demo',
  color = 'dark',
  notifications = TRUE,
  
  tabPanel('First tab',
    sidebarLayout(
      saiMenu(
        sliderInput('bins', 'Number of bins', min = 1, max = 50, value = 30),
        helpText('Select the number of bins in the histogram', small = TRUE)
      ),
      saiMain(
        plotOutput('distPlot')
      )
    )
  ),
  
  tabPanel('Second tab',
    sidebarLayout(
      saiMenu(),
      saiMain()
    )
  ),
  
  # We can add a header and a footer to our page with the header and footer
  # arguments. Note the headerContent and footerContent functions that wraps
  # your text content in a nice container with padding and optional color.
  
  header = headerContent('Welcome to our Shiny app!'),
  footer = footerContent('This is the footer of the page.', color = 'success')
  
)

server <- function(session, input, output) {
  
  output$distPlot <- renderPlot({
    
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    observeEvent(input$bins, {
      sendToast('Bins updated', sprintf('New value is %s', input$bins))
    }, ignoreInit = TRUE)
    
    hist(x, breaks = bins, col = 'red',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
    
  })
  
}

shinyApp(ui = ui, server = server)
