library(shiny)

shinyUI(fluidPage(
        
        #  Application title
        titlePanel("BMI Analyzer"),
        
        # Sidebar to collect input
        sidebarLayout(
                sidebarPanel(
                        radioButtons("gender", label = h4("Choose a Gender"),
                                     choices = list("Female" = 0, "Male" = 1),
                                     selected = 0),
                                                
                        sliderInput("height", "Height (inches):",
                                    min = 48, max = 84, value = 64, step= 0.5),
                        sliderInput("weight", "Weight (pounds):",
                                    min = 80, max = 300, value = 140, step= 1.0),
                        sliderInput("waist", "Waist (inches):",
                                    min = 25, max = 55, value = 34, step= 0.5),
                        sliderInput("hips", "Hips (inches):",
                                    min = 25, max = 55, value = 43, step= 0.5),
                        
                        submitButton("Calculate")
                        
                ),
                
                # Show a table with the results
#                mainPanel(
#                        tableOutput("values"),
#                        plotOutput("histPlot")
#                )
                mainPanel(
                        tabsetPanel(
                                tabPanel("Results", 
                                        tableOutput("values"),
                                        plotOutput("histPlot")),        
                        tabPanel("About this App", 
                                 htmlOutput("instructions"))
                        )
                )
        )
))