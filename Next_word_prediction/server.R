#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#getwd()

# libraries---------------------------------------------------------------------
library(shiny)

#functions for later use:-------------------------------------------------------
# save predicted text data and combine with past data
saveData <- function(data) {
    if (exists("textString")) {
        textString <<- paste(textString, data)
    }else{
        textString <<- data
    }
}

# load updated text data
loadData <- function() {
    if (exists("textString")) {
        textString <- str_replace_all(textString, "\\s+", " ")
        textString
    }
}

server <- function(input, output, session) {
    # code below observes text in previous word input box then runs through
    # prediction model when the space bar is used
    
    # Predict next word --------------------------------------------------------
    # Run previous words through model to give predicted next word
    observe({
        if(!is.null(input$lastkeypresscode)){
            if(input$lastkeypresscode == 32){
                # previous words input
                x <- input$previous.words
                # function to run previous word string through model
                predict_next_word <- function(prev.words, model = ng.model){
                    # remove spaces in front and behind word
                    prev.words <- trimws(prev.words)
                    # remove punctuation
                    prev.words <- str_replace_all(prev.words, "[:punct:]", "")
                    # break into 5 to 1 word groups
                    n = 5:1
                    patt = sprintf("\\w+( \\w+){0,%d}$", n-1)
                    test.input <- data.table(base = stri_extract(prev.words, regex = patt))
                    #test.input <- test.input[, order := length(test.input$base):1]
                    # replace spaces with "_" to give same format as model
                    prep.input <- test.input[, base := str_replace_all(test.input$base, "\\s+", "_") %>%
                                                 tolower()] 
                    #prep.input <- setkey(prep.input, base)
                    # isolate just base words
                    prep.input <- prep.input$base
                    # find predictions in model
                    results.dt <- model[base %in% prep.input]
                    # take result with highest probability
                    result <- results.dt[order(-prob)[1], pred][1]
                    # what to do for no result
                    result <- ifelse(is.null(prev.words), "",
                                     ifelse(is.na(result), "prediction", result))
                    print(result)
                }
                
                prediction <- predict_next_word(prev.words = x)
                # This will change the value of input$inText, based on x
                
                updateTextInput(session,
                                "inText",
                                value = paste(prediction))
            }
        }
    })
    
    ################################################################################        
    
    # Combine previous and predicted 
    # function to save previous words and prediction
    textData <- reactive({
        data <- paste(input$previous.words, input$inText)
        #data <- data.table(returned.text = data)
    })
    
    # When the "Yes, that's it!" button is clicked, save the data
    observe({
        if(!is.null(input$lastkeypresscode)){
            if(input$lastkeypresscode == 13){
                # save combination of previous and predicted text
                saveData(textData())
                updateTextAreaInput(session,
                                    "combination",
                                    value = loadData())
            }
        }
    })
    
    # Store and display output ---------------------------------------------
    
    # clear text boxes to allow another prediction to be made
    observe({
        if(!is.null(input$lastkeypresscode)){
            if(input$lastkeypresscode == 13){
                # clear content of previous words and predicted text boxes
                updateTextInput(session, "previous.words", value = "")
                updateTextInput(session, "inText", value = "")}
        }
    })
    
    # clear stored text data------------------------------------------------
    # Button to clear stored text data and start over
    observeEvent(input$clear.text, {
        # clear saved data
        textString <<- NULL
        updateTextAreaInput(session,
                            "combination",
                            value = loadData()
        )
    },ignoreNULL = TRUE, ignoreInit = TRUE, once = FALSE)
    
    # links to code and data -----------------------------------------------
    # github link
    githuburl <- a("Github", href="https://github.com/JoeDataFan/Coursera_Capstone-_Proect_NLP_app")
    output$Github <- renderUI({
        tagList("Code to build the model and this application:", githuburl)
    })
    data.url <- a("Text_data", href = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip")
    output$Text_data <- renderUI({
        tagList("Text data used to build the model:", data.url)
    })
}


