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
require(data.table)
require(DT)

# Define UI for application that draws a histogram
ui <- saiPage(
  title = 'Test av UI', color = 'dark',

  tabPanel(title = 'Histogram',
    sidebarLayout(
      saiMenu(color = 'white',
        selectInput('test', 'Test', choices = c('A', 'B'), selected = 'A')
      ),
      saiMain(
        h2('Old Faithful plot'),
        plotOutput('distPlot')
      ))
  ),
  tabPanel(
    title = 'Table',
    div(class = 'col-12',
      h2('This is Tab 2'),
      dataTableOutput('dt')
    )
  ),
  tabPanel(
    title = 'Content',
    div(class = 'col-12 p-3',
      tabsetPanel(type = 'tabs',
      tabPanel(title = 'One',
        p('One')
      ),
      tabPanel(title = 'Two',
        p('Two')
      ),
      tabPanel(title = 'Three',
        p('Three')
      )
    ))
  )

)

# Define server logic required to draw a histogram
server <- function(input, output) {

   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = 30)

      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'blue', border = 'white')
   })

   output$dt <- renderDataTable({
     DT::datatable(iris)
   })
}

# Run the application
shinyApp(ui = ui, server = server)

