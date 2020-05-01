

library(shiny)


# ui.R

shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Text Prediction Application"),
    sidebarPanel(
      h4('This application attempts to predict the next word you want to type - so you don\'t have to!'),
      h4('Enter a sentence - or any text, leaving out your last intended word'),
      textInput("ipLine", "Enter your sentence:", width = 800),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      
      h4('You entered'),
      verbatimTextOutput("inputValue1"),
      h4('which resulted in a prediction of '),
      verbatimTextOutput("predWord")
    )
  )
)
