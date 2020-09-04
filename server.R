

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
      max_value <- max(state_stat[,input$selected]) 
      max_state <-
        state_stat$state.name[state_stat[,input$selected]==max_value] 
      infoBox(max_state, max_value, icon = icon("hand-o-up"))
    })
    
    output$minBox <- renderInfoBox({
      min_value <- min(state_stat[,input$selected]) 
      min_state <-
        state_stat$state.name[state_stat[,input$selected]==min_value] 
      infoBox(min_state, min_value, icon = icon("hand-o-down"))
    })
    
    output$avgBox <- renderInfoBox(
      infoBox(paste("AVG.", input$selected), 
              mean(state_stat[,input$selected]),
              icon = icon("calculator"), fill = TRUE))
  }
)