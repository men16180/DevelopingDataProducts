library(tm)
library(wordcloud)
library(memoise)
library(harrypotter)

# The list of valid books
#books <<- list("The Philosphers Stone","The Chamber of Secrets","The Prisoner of Azkaban", "The Goblet of Fire", "The Order of the Phoenix","The Half Blood Prince","The Deathly Hallows"
#)

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (!(book %in% books))
    stop("Unknown book")
  
  text <- switch(book, "The Philosphers Stone" = philosophers_stone,"The Chamber of Secrets"= chamber_of_secrets,"The Prisoner of Azkaban"=prisoner_of_azkaban, "The Goblet of Fire"=goblet_of_fire, "The Order of the Phoenix"=order_of_the_phoenix,"The Half Blood Prince"=half_blood_prince,"The Deathly Hallows"=deathly_hallows )
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = suppressWarnings(tm_map(myCorpus, content_transformer(tolower)))
  myCorpus = suppressWarnings(tm_map(myCorpus, removePunctuation))
  myCorpus = suppressWarnings(tm_map(myCorpus, removeNumbers))
  myCorpus = suppressWarnings(tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but")))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})


function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    set.seed(1234)
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(3,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Accent"))
  })
}

