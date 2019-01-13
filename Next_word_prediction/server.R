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
    #data <- as.data.frame((data))
    if (exists("textString")) {
        textString <<- rbind(textString, data)
    }else{
        textString <<- data
    }
}

# load updated text data
loadData <- function() {
    if (exists("textString")) {
        textString <- unique(textString)
        textString <- as.character(textString[[1]])
        textString <- paste(textString, collapse = " ")
        textString
    }
}


server <- function(input, output, session) {
    # code below observes text in previous word input box then automatically runs
    # through prediction model to give output
    
    # Predict next word --------------------------------------------------------
    # Run previous words through model to give predicted next word
    observe({
        # previous words input
        x <- input$previous.words
        # function to run previous word string through model
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
        
        # Combine previous and predicted 
        # function to save previous words and prediction
        textData <- reactive({
            data <- paste(trimws(input$previous.words), input$inText)
            data <- data.table(returned.text = c(data))
        })
        
        # When the "Yes, that's it!" button is clicked, save the data
        observe({
            if(!is.null(input$lastkeypresscode)){
                if(input$lastkeypresscode == 13){
                    
                    #observeEvent(input$yes, {
                    saveData(textData())
                }
            }
        })
        
        
        # Store and display output ---------------------------------------------
        
        # When the button is clicked show the previous responses combined with
        # current response in the textbox
        observe({
            if(!is.null(input$lastkeypresscode)){
                if(input$lastkeypresscode == 13){
                    updateTextAreaInput(session,
                                        "combination",
                                        value = loadData()
                    )
                }
            }
        })   
        
        # clear text boxes to allow another prediction to be made
        observe({
            if(!is.null(input$lastkeypresscode)){
                if(input$lastkeypresscode == 13){
                    
                    #observeEvent(input$yes, {
                    updateTextInput(session, "previous.words", value = "")
                    updateTextInput(session, "inText", value = "")}
            }
        })
        
        # clear stored text data------------------------------------------------
        # Button to clear stored text data and start over
        observeEvent(input$clear.text, {
            textString <<- NULL
            #output$textString <- renderText({
            #loadData()
            updateTextAreaInput(session,
                                "combination",
                                value = loadData()
            )
        },ignoreNULL = TRUE, ignoreInit = TRUE, once = TRUE)
        
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
    })
}


