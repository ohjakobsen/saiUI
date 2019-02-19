require(shiny) 
require(saiUI)

ui <- saiDashboard(
  
  title = 'Hello dash!',
  color = 'dark',
  
  dashboardPanel(
    
    title = 'Dashboard', 
    id = 'dash', 
    icon = 'dashboard',
    
    cardGroup(
      type = 'deck',
      dashboardCard(
        header = 'Header',
        footer = tags$button(class = 'btn btn-sm btn-primary', 'Click me'),
        'This is the content'),
      dashboardCard(
        color = 'light',
        header = 'Big number',
        tags$span(class = 'display-1', floor(runif(1, 10, 100))),
        class = 'text-center'),
      dashboardCard(
        color = 'danger',
        'We can put content here',
        footer = 'This is the footer')
    )
  ),
  
  dashboardPanel(
    
    title = 'Eruption data',
    id = 'stats',
    icon = 'bar-chart',
    
    cardNav(navId = 'navtest',
      cardNavItem('test', title = 'Histogram', plotOutput('distPlot')),
      cardNavItem('test2', title = 'Scatter', plotOutput('scatPlot'))
    )
  )
                 
)

server <- function(session, input, output) {
  
  output$distPlot <- renderPlot({
    
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = 31)
    
    hist(x, breaks = bins, col = 'red',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
    
  })
  
  output$scatPlot <- renderPlot({
    
    plot(faithful$waiting, faithful$eruptions,
         xlab = 'Waiting times',
         ylab = 'Eruptions')
    
  })
  
}

shinyApp(ui = ui, server = server)
