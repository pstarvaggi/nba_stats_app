
shinyServer(
  function(input,output){

    output$hist <- renderGvis({ 
      gvisHistogram(
          data.frame(box_scores[box_scores$playDispNm == input$player,]
                     [, stats[stats$statistic == input$stat,1]]), 
                    options = list(width = 'auto', height = 500,
                                   legend = 'none',
                                   hAxis = paste0("{title:'",input$stat,"'}"),
                                   vAxis = "{title: 'Number of Games'}"))
    })
    
    output$hist2 <- renderGvis({ 
      x_max = max(box_scores[box_scores$playDispNm == input$player,]
                  [, stats[stats$statistic == input$stat,1]])
      gvisHistogram(
        data.frame(box_scores[box_scores$playDispNm == input$player,]
                   [, stats[stats$statistic == input$stat,1]]), 
        options = list(title = 'All Games',
                       width = 'auto', height = 250,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"',
                                      viewWindowMode: 'explicit', 
                                      viewWindow: {min: 0, max:",x_max,"}}"),
                       vAxis = "{title: 'Number of Games'}"))
    })
    
    output$hist3 <- renderGvis({ 
      gvisHistogram(
        data.frame(box_scores[box_scores$playDispNm == input$player
                              & box_scores$gmDate >= input$daterange[1]
                              & box_scores$gmDate <= input$daterange[2],]
                   [, stats[stats$statistic == input$stat,1]]), 
        options = list(width = 'auto', height = 500,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"'}"),
                       vAxis = "{title: 'Number of Games'}"))
    })
    
    output$table <- DT::renderDataTable({
    datatable(box_scores[box_scores$playDispNm == input$player,
                         if(stats[stats$statistic == input$stat,1] %in%
                         c('gmDate', 'playPTS', 'playTRB', 
                         'playAST','playBLK','playSTL')){
                           c('gmDate', 'playPTS', 'playTRB', 
                             'playAST','playBLK','playSTL')
                         } else {
                         c('gmDate', 'playPTS', 'playTRB', 
                           'playAST','playBLK','playSTL', 
                           stats[stats$statistic == input$stat,1])}], 
              rownames=FALSE) %>%
        formatStyle(stats[stats$statistic == input$stat,1],
                    background="skyblue", 
                    fontWeight='bold')
    })
    
    output$maxBox <- renderInfoBox({
      max_value <- max(box_scores[,stats[stats$statistic == input$stat,1]]) 
      max_player <-
        box_scores$playDispNm[box_scores[,stats[stats$statistic == input$stat,1]]==max_value]
      if (length(max_player) > 1){max_player = 'Multiple Players'}
      infoBox(paste(max_player, 'has most single game', input$stat), 
              max_value, icon = icon("hand-o-up"))
    })
    
    output$maxBox2 <- renderInfoBox({
      max_value <- max(box_scores[box_scores$playDispNm == input$player,stats[stats$statistic == input$stat,1]]) 
      infoBox(paste(input$player, 'max', input$stat), 
              max_value, icon = icon("hand-o-up"))
    })
    
    output$maxBox3 <- renderInfoBox({
      max_value <- max(box_scores[box_scores$playDispNm == input$player,
                                  stats[stats$statistic == input$stat2,1]]) 
      infoBox(paste(input$player, 'max', input$stat2), 
              max_value, icon = icon("hand-o-up"))
    })
    
    
    output$maxBox4 <- renderInfoBox({
      max_value <- max(box_scores[box_scores$playDispNm == input$player
                                  & box_scores$gmDate >= input$daterange[1]
                                  & box_scores$gmDate <= input$daterange[2]
                                  ,stats[stats$statistic == input$stat,1]]) 
      infoBox(paste(input$player, 'max in date range', input$stat), 
              max_value, icon = icon("hand-o-up"))
    })

    output$avgBox <- renderInfoBox({
      infoBox(paste(input$player, "average", input$stat, 'per game'), 
              signif(mean(box_scores[
                box_scores$playDispNm == input$player,
                stats[stats$statistic == input$stat,1]]), 
                digits = 3),
              icon = icon("calculator"), fill = TRUE)
    })
    
    output$avgBox2 <- renderInfoBox({
      infoBox(paste(input$player, "average", input$stat, 'in date range per game'), 
              signif(mean(box_scores[
                box_scores$playDispNm == input$player
                & box_scores$gmDate >= input$daterange[1]
                & box_scores$gmDate <= input$daterange[2],
                stats[stats$statistic == input$stat,1]]), 
                digits = 3),
              icon = icon("calculator"), fill = TRUE)
    })
    
    
    output$scatter <- renderGvis({
      gvisScatterChart(data.frame(
        box_scores[
          box_scores$playDispNm == input$player,
          stats[stats$statistic == input$stat,1]], 
        box_scores[
          box_scores$playDispNm == input$player,
          stats[stats$statistic == input$stat2,1]]),
        options=list(
          title=paste(input$stat, 'vs', input$stat2),
          legend="none",
          pointSize=3,
          curveType = 'function',
          height = 500,
          hAxis=paste0("{title:'",input$stat,"'}"),
          vAxis=paste0("{title:'",input$stat2,"'}")))
    })
    
    
    output$byref <- renderGvis({
      x_max = max(box_scores[box_scores$playDispNm == input$player,]
                  [, stats[stats$statistic == input$stat,1]])
      gvisHistogram(
        data.frame(box_scores[box_scores$playDispNm == input$player & 
                                (paste(box_scores$offFNm1,box_scores$offLNm1)
                                 == input$ref | 
                                   paste(box_scores$offFNm2,box_scores$offLNm2)
                                 == input$ref | 
                                   paste(box_scores$offFNm3,box_scores$offLNm3)
                                 == input$ref),][, stats[stats$statistic ==
                                                           input$stat,1]]),
        options = list(title=paste('Games With', input$ref, 'as an Official'),
                       width = 'auto', height = 250,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"',
                                      viewWindowMode: 'explicit', 
                                      viewWindow: {min: 0, max:",x_max,"}}"),
                       vAxis = "{title: 'Number of Games'}"))
    })
    
    
    output$line <- renderGvis({ 
      gvisLineChart(
        data.frame(box_scores[box_scores$playDispNm == input$player
                              & box_scores$gmDate >= input$daterange[1]
                              & box_scores$gmDate <= input$daterange[2],]
                          [,'gmDate'],
        box_scores[box_scores$playDispNm == input$player
                   & box_scores$gmDate >= input$daterange[1]
                   & box_scores$gmDate <= input$daterange[2],]
                          [, stats[stats$statistic == input$stat,1]]),
        options = list(title = 'All Games',
                       width = 'auto', height = 250,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"'}"),
                       vAxis = "{title: 'Number of Games'}"))
    })   
  }
)