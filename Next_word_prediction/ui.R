#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(
    # App title ----
    titlePanel("Next Word Prediction Algorithm"),
    
    mainPanel(
        # Output: Tabset w/ plot, summary, and table ----
        tabsetPanel(type = "tabs",
                    tabPanel("Use the app",
                             # script to allow "enter" key to be used instead of pressing button
                             tags$script(' $(document).on("keydown", function (e) {
                                     Shiny.onInputChange("lastkeypresscode", e.keyCode);
                                     });
                                     '),
                             
                             
                             # instructions
                             h4('Type in the box below and the next word will be predicted'),
                             
                             # script to allow "enter" key to be used instead of pressing button
                             tags$script(' $(document).on("keydown", function (e) {
                                     Shiny.onInputChange("lastkeypresscode", e.keyCode);
                                     });
                                     '),
                             
                             # text input box for previous words
                             textInput("previous.words", "Previous words:"),
                             #div(style="display: inline-block;vertical-align:top; width: 250px;",textInput("previous.words", "Previous words:")),
                             
                             # text output giving predicted next word based on previous
                             textInput("inText", "Predicted next word:"),
                             #div(style="display: inline-block;vertical-align:top; width: 100px;",textInput("inText", "Next word:")),          
                             # button to combine previous and predicted then print below. This text string
                             # continues to grow each time new words are predicted and the button pressed
                             #h4('Press "ENTER" to add text'),
                             # growing string of text
                             
                             textAreaInput("combination", "Combination (click ENTER):", width = '300px', height = '100px'),
                             actionButton("clear.text", "Start over")
                    ),
                    
                    tabPanel("Info:", 
                             h4('How to use this app:'),
                             h5("This app is intended to make life a little easier by predicting the 
                                next word you intend to type based on previous words. If the predicted 
                                word matches your expectations hit ENTER and all text 
                                will be saved and then displayed below. Continue to follow this method and 
                                a long string of text will be created fairly quickly."),
                             br(),
                             tags$hr(),
                             h4('Background:'),
                             h5('This Shiny app is the final product from the Coursera Data Science Specialization
                                Capstone Project. The goal of this final project was to take a large collect of text
                                from twitter, blogs and news feeds, create a next word prediction algorithm and then
                                demonstrate the resulting model in a user-friendly app.'),
                             p(),
                             h5('The underlying next word prediction algorithm was built in the following way:'),
                             tags$ol(
                                 tags$li('All sources of text data were combined and then randomly split into the following samples:'),
                                 tags$ul(
                                     tags$li('25% for training the model (this sample size was the most that could be used for training
                                             given 16G of RAM)'),
                                     tags$li('5% for validation of the model'),
                                     tags$li('5% for final testing of model')
                                 ),
                                 tags$li('The training text was then organized by sentences.'),
                                 tags$li('Sentences were then split into ngrams (2 to 6-word groupings). At this point in processing
                                        the following items were removed: punctuation, symbols, hyphens, non-ASCII characters,
                                        hash tags, URLs and words containing numbers. All letters were also converted
                                         to lowercase.'),
                                 tags$li('The occurrence of each unique ngram was calculated.'),
                                 tags$li('The last word of each ngram was then separated from the rest of the words giving 
                                        two columns PREVIOUS and PREDICTION.'),
                                 tags$li('The probability of unique PREVIOUS and PREDICTION pairs were then calculated for 
                                        each unique PREVIOUS word set. Stated more plainly, the final data table shows the
                                        probability that a word will occur next given specific previous words.'),
                                 tags$li('The data was then trimmed down by selecting PREDICTION with highest probability for
                                        each PREVIOUS word set'),
                                 tags$li('The resulting data table was then filtered to remove profanity from the PREDICTION 
                                        column.'),
                                 tags$li('Probabilities were then weighted to give higher preference to larger ngrams; the 
                                        predicted next word tends to be more accurate given more previous words.'),
                                 tags$li('Finally, a function was written to take a text string, select the last 5, 4, 
                                        3, 2 and 1 words, search for these word combinations in the previously built 
                                        model, return the matching predictions and then select the predicted next 
                                        word with the highest probability.')
                                 
                             ),
                             h4('Links:'),
                             uiOutput("Github"),
                             uiOutput("Text_data")
                    )
                    
        )
    )
)
    
    
    

