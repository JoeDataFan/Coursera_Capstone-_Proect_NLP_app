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

#functions for later use:
saveData <- function(data) {
    #data <- as.data.frame((data))
    if (exists("textString")) {
        textString <<- rbind(textString, data)
    }else{
        textString <<- data
        }
}

loadData <- function() {
    if (exists("textString")) {
        textString <- unique(textString)
        textString <- as.character(textString[[1]])
        textString <- paste(textString, collapse = " ")
        textString
    }
}

    server <- function(input, output, session) {
        observe({
            # We'll use the input$controller variable multiple times, so save it as x
            # for convenience.
            x <- input$previous.words
            #pred.string <- ng.15.test[base == str_replace_all(x, "\\s" , "_") %>%
                                          #str_remove_all(., "_$"), pred]
            
            # function to run string through model
            predict_next_word <- function(prev.words, model = ng.model){
                prev.words <- trimws(prev.words)
                n = 5:1
                patt = sprintf("\\w+( \\w+){0,%d}$", n-1)
                test.input <- data.table(base = stri_extract(prev.words, regex = patt))
                test.input <- test.input[, order := length(test.input$base):1]
                prep.input <- test.input[, base := str_replace_all(test.input$base, "\\s+", "_") %>% 
                                             #str_replace(., "_$", "") %>% 
                                             tolower()] 
                prep.input <- setkey(prep.input, base)
                prep.input <- prep.input$base
                results.dt <- model[base %in% prep.input]
                result <- results.dt[order(-prob)[1], pred][1]
                result <- if_else(is.na(result), " ", result)
                print(result)
            }
            
            prediction <- predict_next_word(prev.words = x)
            
            # This will change the value of input$inText, based on x
            updateTextInput(session,
                            "inText",
                            value = paste(prediction))
            
            # save previous words and prediction when button is clicked
            textData <- reactive({
                data <- paste(input$previous.words, input$inText)
                data <- data.table(returned.text = c(data))
                })
            
            # When the "Yes, that's it!" button is clicked, save the data
            observeEvent(input$yes, {
                saveData(textData())
            }, ignoreNULL = TRUE, ignoreInit = TRUE, once = TRUE)
            
            # Show the previous responses
            # (update with current response when Submit is clicked)
            observeEvent(input$yes, {
                output$textString <- renderText({
                loadData()
                    })
                }, ignoreNULL = TRUE, ignoreInit = TRUE, once = TRUE)     
            
            observeEvent(input$yes, {
                updateTextInput(session, "previous.words", value = "")
                updateTextInput(session, "inText", value = "")
                }, ignoreNULL = TRUE, ignoreInit = TRUE, once = TRUE)
        })
    }
    
    
    
    
    
    
#    # Whenever a field is filled, aggregate all form data
#    formData <- reactive({
#        data <- sapply(fields, function(x) input[[x]])
#        data
#    })
#    
#    # When the Submit button is clicked, save the form data
#    observeEvent(input$submit, {
#        saveData(formData())
#    })
#    
#    # Show the previous responses
#    # (update with current response when Submit is clicked)
#    output$responses <- DT::renderDataTable({
#        input$submit
#        loadData()
#    })     
