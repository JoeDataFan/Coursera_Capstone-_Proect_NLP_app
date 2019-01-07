#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

    server <- function(input, output, session) {
        observe({
            # We'll use the input$controller variable multiple times, so save it as x
            # for convenience.
            x <- input$previous.words
            prediction <- ng.15.test[base == str_replace_all(x, "\\s", "_"), pred]
            
            # This will change the value of input$inText, based on x
            updateTextInput(session, "inText", value = paste(prediction))
            
            # Can also set the label, this time for input$inText2
            updateTextInput(session, "inText2",
                            label = paste("Prediction", x),
                            value = paste("New text", x))
        })
    }
    
