

shinyServer(
  function(input,output){
    output$hist <- renderGvis({ 
      gvisHistogram(
          as.data.frame(box_scores[box_scores$playDispNm == input$player, input$stat]), 
                    options = list(width = 'auto', height = 'auto'))
    })
    # show histogram using googleVis
    
    # show data using DataTable 
    output$table <- DT::renderDataTable({
    datatable(state_stat, rownames=FALSE) %>% 
        formatStyle(input$selected,
                    background="skyblue", 
                    fontWeight='bold') 
    # Highlight selected column using formatStyle
    })
    
    output$maxBox <- renderInfoBox({
      max_value <- max(box_scores[,input$stat]) 
      max_player <-
        box_scores$playDispNm[box_scores[,input$stat]==max_value]
      if (length(max_player) > 1){max_player = 'Multiple Players'}
      infoBox(paste(max_player, 'has most single game', input$stat), 
              max_value, icon = icon("hand-o-up"))
    })

    output$avgBox <- renderInfoBox(
      infoBox(paste(input$player, "AVG.", input$stat), 
              round(mean(box_scores[box_scores$playDispNm == input$player,][,input$stat])),
              icon = icon("calculator"), fill = TRUE))
  }
)