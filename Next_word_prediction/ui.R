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
    h4('Next Word Prediction Algorithm'),
    p('Type in the box below and the next word will be predicted'),
    textInput("previous.words", "Previous words"),
    textInput("inText", "Prediction")
)
