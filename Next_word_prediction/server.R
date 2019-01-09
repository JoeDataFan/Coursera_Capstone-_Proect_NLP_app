#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#getwd()

library(shiny)

    server <- function(input, output, session) {
        observe({
            # We'll use the input$controller variable multiple times, so save it as x
            # for convenience.
            x <- input$previous.words
            #pred.string <- ng.15.test[base == str_replace_all(x, "\\s" , "_") %>%
                                          #str_remove_all(., "_$"), pred]
            
            # function to run string through model
            predict_next_word <- function(prev.words, model = ng.model){
                n = 4:1
                patt = sprintf("\\w+( \\w+){0,%d}$", n-1)
                test.input <- data.table(base = stri_extract(prev.words, regex = patt))
                test.input <- test.input[, order := length(test.input$base):1]
                prep.input <- test.input[, base := str_replace_all(test.input$base, "\\s+", "_") %>% 
                                             str_replace(., "_$", "") %>% 
                                             tolower()] 
                prep.input <- setkey(prep.input, base)
                prep.input <- prep.input$base
                results.dt <- model[base %in% prep.input]
                result <- results.dt[order(-prob)[1], pred][1]
                print(result)
            }
            
            prediction <- predict_next_word(prev.words = x)
            
            # This will change the value of input$inText, based on x
            updateTextInput(session, "inText", value = paste(prediction))
            
            ## Can also set the label, this time for input$inText2
            #updateTextInput(session, "inText2",
            #                label = paste("Predicted next word", x),
            #                value = paste("New text", x))
        })
    }
    
