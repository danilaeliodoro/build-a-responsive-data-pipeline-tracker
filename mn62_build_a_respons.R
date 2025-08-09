# Load necessary libraries
library(dplyr)
library(ggplot2)
library(shiny)
library(DT)

# Define data model
data_model <- function() {
  # Pipeline stages
  stages <- c("Data Ingestion", "Data Processing", "Data Visualization", "Model Training")
  
  # Pipeline status
  status <- c("Running", "Completed", "Failed")
  
  # Data pipeline tracker
  tracker <- data.frame(
    pipeline_id = 1:10,
    stage = sample(stages, 10, replace = TRUE),
    status = sample(status, 10, replace = TRUE),
    start_time = Sys.time() - runif(10, 0, 100),
    end_time = Sys.time() + runif(10, 0, 100),
    duration = runif(10, 0, 100)
  )
  
  # Return tracker data
  tracker
}

# Create a reactive expression to generate data
data <- eventReactive(input$generate, {
  data_model()
})

# Create a Shiny app
ui <- fluidPage(
  titlePanel("Responsive Data Pipeline Tracker"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("generate", "Generate Data")
    ),
    
    mainPanel(
      DT::dataTableOutput("tracker_table"),
      plotOutput(" tracker_plot")
    )
  )
)

server <- function(input, output) {
  output$tracker_table <- DT::renderDataTable({
    data()
  })
  
  output$tracker_plot <- renderPlot({
    ggplot(data(), aes(x = start_time, y = duration, color = status)) + 
      geom_point() + 
      labs(title = "Pipeline Tracker", x = "Start Time", y = "Duration")
  })
}

shinyApp(ui = ui, server = server)