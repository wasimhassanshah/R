
library(shiny)





# Server is where data is manipulated and visualizations are prepared
server = function(input, output, session) {
  
  output$selected_var <- renderText({
    paste("You have selected", input$region, "and", input$prodCat)
  })
  
}



# Where data is shown and visualizations are served
ui <- fluidPage(
  h1("THe R Shiny App Video Series"),
 # textInput("region", "Enter Region"), # Text Input
 selectInput("region",
             label = "Region",
             choices = c("Region 1", "Region 2"),
             selected = "Region 1"),

 
 
  selectInput("prodCat", 
              label = "Product Category",
              choices = c("Category 1", "Category 2"),
              selected = "Category 1"), # Select Input: 1st entry is input for server, 2nd entry is label, 3rd entry is options in categories to select
  
 
 textOutput("selected_var")
  
)



# Launch the code
shinyApp(ui = ui, server = server)
         
         
         