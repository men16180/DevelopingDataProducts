library(shiny)
library(markdown)


# The list of valid books
books <<- list("The Philosphers Stone","The Chamber of Secrets","The Prisoner of Azkaban", "The Goblet of Fire", "The Order of the Phoenix","The Half Blood Prince","The Deathly Hallows"
)

fluidPage(
  # Application title
  titlePanel("Harry Potter Word Cloud Generator"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Choose a book from the Harry Potter series and press Change to update:",
                  choices = books),
      actionButton("update", "Change"),
      hr(),
      sliderInput("freq",
                  "Minimum Word Frequency:",
                  min = 1,  max = 50, value = 15),
      sliderInput("max",
                  "Maximum Number of Words Plotted:",
                  min = 1,  max = 200,  value = 100)
    ),
    
    # Main panel with two tabs - one for the word cloud and one for the documentation
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Word Cloud", plotOutput("plot")),
                  tabPanel("Documentation", includeMarkdown("./DDPAss3_doc.Rmd"))
      )
  
      
    )
  )
)
