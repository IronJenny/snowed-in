library(shiny)

shinyServer(function(input, output) {
        
        # Reactive expression to calculate BMI and Waist/Hip Ratio
        sliderValues <- reactive({
                
                # Calculate BMI
                #bmi <<- ( input$weight / ( input$height * input$height ) ) * 703
                #bmi <<- round(bmi,1)
                bmi <<- round ((input$weight * 0.45) / ((input$height * 0.025) ^ 2), digits=1)
                
                #Determine BMI Category
                if (bmi < 18.5) {
                        bmiCategory <- "Underweight"
                }
                else if (bmi >= 18.5 && bmi <= 24.9) {
                        bmiCategory <- "Normal"
                }
                else if (bmi >= 25 && bmi <= 29.9) {
                        bmiCategory <- "Overweight"
                }
                else  {
                        bmiCategory <- "Obese"
                }

                
                # Calculate Waist/Hip Ratio
                whr <<- input$waist / input$hips
                whr <<- round(whr,2)
                
                # Determine Waist/Hip Ratio Category
                if ((whr > .85 && input$gender == 0) || (whr > 1.0 && input$gender == 1))
                {
                        whrCategory <- "Danger"
                }
                else {
                        whrCategory <- "Safe"
                }                

                
                # Compose output data frame
                data.frame(
                        Name = c("BMI Measurement",
                                 "BMI Category",
                                 "Waist/Hip Ratio",
                                 "Waist/Hip Ratio Category"),
                        Value = as.character(c(bmi,
                                               bmiCategory,
                                               whr,
                                               whrCategory), 
                        stringsAsFactors=FALSE))
        }) 

        
        # Show the values using an HTML table
        output$values <- renderTable({
                sliderValues()
        })

        # Read in reference dataset
        f <- "http://www.amstat.org/publications/jse/datasets/body.dat.txt"
        mydf <- read.table(f)
        colnames(mydf) <- c(
                "diameterBiacromial",
                "diameterBiiliac",
                "diameterBitrochanteric",
                "depthChest",
                "diameterChest",
                "diameterElbow",
                "diameterWrist",
                "diameterKnee",
                "diameterAnkle",
                "girthShoulder",
                "girthChest",
                "girthWaist",
                "girthAbdominal",
                "girthHip",
                "girthThigh",
                "girthBicep",
                "girthForearm",
                "girthKnee",
                "girthCalf",
                "girthAnkle",
                "girthWrist",
                "age",
                "weight",
                "height",
                "gender"
        )
        
        # calculate BMI and wasit/hip ratio for each subject
        mydf$bmi <- round((mydf$weight / (mydf$height/100)) / (mydf$height/100),1)
        mydf$whr <- round(mydf$girthWaist/mydf$girthHip,2)
        
        # create a histogram showing the distribution of BMI for those
        # subjects with the same gender as what was entered and draw a
        # vertical line showing the BMI calculated from the input data
        output$histPlot <- 
                renderPlot({
                        #g <- as.numeric(input$gender)
                        if (input$gender == 0) {
                                gn <- "female" 
                                gc <- "pink"
                        }
                        else {
                                gn <- "male"
                                gc <- "blue"
                        }
                        x <- subset(mydf, gender == input$gender)
                        hist(x$bmi, 
                             main=paste("How your BMI compares\n(", gn, ", height=", input$height, " inches, weight=", input$weight, " pounds)", sep=''), 
                             col=gc,
                             xlab="BMI")
                        abline(v=bmi, col="red", lwd=2)
                })
        
        # include instructions
        output$instructions <- 
                renderText({  
                        readLines("Readme.html")  
                })
})