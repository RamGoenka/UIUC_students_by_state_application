library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
data <- read_csv("https://raw.githubusercontent.com/wadefagen/datasets/master/students-by-state/uiuc-students-by-state.csv")
ui <- navbarPage("UIUC Students by State",
                 tabPanel("Plot",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("state", "State:", choices = unique(data$State)),
                              sliderInput("year", "Year:", min = min(data$Year), max = max(data$Year), value = c(min(data$Year), max(data$Year))),
                              selectInput("level", "Level:", choices = c("Undergrad", "Professional", "Grad", "Total"))
                            ),
                            mainPanel(
                              plotOutput("linePlot")
                            )
                          )),
                 tabPanel("Table",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("stateTable", "State:", choices = unique(data$State)),
                              sliderInput("yearTable", "Year:", min = min(data$Year), max = max(data$Year), value = c(min(data$Year), max(data$Year))),
                              selectInput("levelTable", "Level:", choices = c("Undergrad", "Professional", "Grad", "Total"))
                            ),
                            mainPanel(
                              tableOutput("studentTable")
                            )
                          )),
                 tabPanel("About",
                          mainPanel(
                            includeMarkdown("about.Rmd")
                          ))
)

server <- function(input, output) {
  data_subset <- reactive({
    filter_data(data, input$state, input$year, input$level)
  })
  
  data_subset_table <- reactive({
    filter_data(data, input$stateTable, input$yearTable, input$levelTable)
  })
  output$linePlot <- renderPlot({
    ggplot(data_subset(), aes_string(x = "Year", y = input$level)) +
      geom_line() +
      labs(title = paste("Number of", input$level, "students from", input$state, "over time"),
           x = "Year",
           y = "Number of Students")
  })
  
  output$studentTable <- renderTable({
    data_subset_table()
  })
}
shinyApp(ui = ui, server = server)

