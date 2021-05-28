ui <- fluidPage(
  titlePanel("name"),
  fluidRow(
    column(4,
           selectInput("yr",
                       "Year:",
                       c("All",
                         unique(as.character(stroke_mortality_combined$Year))))          
    ),
    column(4,
           selectInput("lA",
                       "State:",
                       c("All",
                         unique(as.character(stroke_mortality_combined$LocationAbbr))))
    ),
    column(4,
           selectInput("ld",
                       "Name of county:",
                       c("All", 
                         unique(as.character(stroke_mortality_combined$LocationDesc))))
    ),
    column(4,
           selectInput("data",
                       "Data Value:",
                       c("All", 
                         unique(as.character(stroke_mortality_combined$Data_Value))))
  ),
  column(4,
         selectInput("strat1",
                     "Gender:",
                     c("All", 
                       unique(as.character(stroke_mortality_combined$Stratification1))))
  ),
  column(4,
         selectInput("strat2",
                     "Ethnicity:",
                     c("All", 
                       unique(as.character(stroke_mortality_combined$Stratification2))))
   
  )
),
  DT::dataTableOutput("table"),
)

server <- function(input, output) {
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- stroke_mortality_combined
    if (input$yr != "All") {
      data <- data[data$Year == input$yr,]
    }
    if (input$la != "All") {
      data <- data[data$LocationAbbr == input$la,]
    }
    if (input$ld != "All") {
      data <- data[data$LocationDesc == input$ld,]
    }
    if (input$data !="All"){
      data <- data[data$Data_Value == input$data,]
    }
    if (input$strat1 !="All"){
      data <- data[data$Stratification1 == input$strat1,]
    }
    if (input$strat2 !="All"){
      data <- data[data$Stratification2 == input$strat2,]
    }
    data
  }))
}

