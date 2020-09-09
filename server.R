
shinyServer(
  function(input,output){

    #Choose one player and one stat to make histogram
    output$hist <- renderGvis({ 
      df_hist = data.frame(box_scores[box_scores$playDispNm == input$player,]
                 [, stats[stats$statistic == input$stat,1]])
      colnames(df_hist) <- as.character(input$stat)
      
      gvisHistogram(df_hist, 
                    options = list(width = 'auto', height = 500,
                                   legend = 'none',
                                   hAxis = paste0("{title:'",input$stat,"'}"),
                                   vAxis = "{title: 'Number of Games'}",
                                   title = paste(input$player, input$stat)))
    })
    
    #one player one stat histogram for comparison with byref histogram
    output$hist2 <- renderGvis({ 
      x_max = max(box_scores[box_scores$playDispNm == input$player,]
                  [, stats[stats$statistic == input$stat,1]])
      
      df_hist2 = data.frame(box_scores[box_scores$playDispNm == input$player,]
                            [, stats[stats$statistic == input$stat,1]])
      
      colnames(df_hist2) <- as.character(input$stat)
      
      gvisHistogram(
        df_hist2, 
        options = list(title = 'All Games',
                       width = 'auto', height = 250,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"',
                                      viewWindowMode: 'explicit', 
                                      viewWindow: {min: 0, max:",x_max,"}}"),
                       vAxis = "{title: 'Number of Games'}"))
    })
    
    #make histogram for one player, one stat for selected date range
    output$hist3 <- renderGvis({ 
      df_hist3 = data.frame(
        box_scores[box_scores$playDispNm == input$player
                   & box_scores$gmDate >= input$daterange[1]
                   & box_scores$gmDate <= input$daterange[2],]
        [, stats[stats$statistic == input$stat,1]])
      colnames(df_hist3) <- as.character(input$stat)
      
      gvisHistogram(
        df_hist3, 
        options = list(title = paste('Games between', input$daterange[1],
                                     'and', input$daterange[2]),
                       width = 'auto', height = 500,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"'}"),
                       vAxis = "{title: 'Number of Games'}"))
    })
    
    #make data table for data tab
    output$table <- DT::renderDataTable({
    #select columns from box_scores
    x <- box_scores[box_scores$playDispNm == input$player,
                    if(stats[stats$statistic == input$stat,1] %in%
                       c('gmDate', 'playPTS', 'playTRB', 
                         'playAST','playBLK','playSTL')){
                      c('gmDate', 'playPTS', 'playTRB', 
                        'playAST','playBLK','playSTL')
                    } else {
                      c('gmDate', 'playPTS', 'playTRB', 
                        'playAST','playBLK','playSTL', 
                        stats[stats$statistic == input$stat,1])}]
    
    #give columns readable names
    colnames(x) <- if(stats[stats$statistic == input$stat,1] %in%
                      c('gmDate', 'playPTS', 'playTRB', 
                        'playAST','playBLK','playSTL')){
      c('Date', 'Points', 'Rebounds',
        'Assists','Blocks','Steals')
    } else {
      c('Date', 'Points', 'Rebounds',
        'Assists','Blocks','Steals',
        stats[stats$statistic == input$stat,2])} 
    
    #make data frame a datatable
    datatable(x,rownames=FALSE) %>%
        formatStyle(stats[stats$statistic == input$stat,2],
                    background="skyblue", 
                    fontWeight='bold')
    })
    
    
    #Lots of infoboxes
    output$maxBox <- renderInfoBox({
      max_value <- max(box_scores[,stats[stats$statistic == input$stat,1]]) 
      max_player <-
        box_scores$playDispNm[
          box_scores[,stats[stats$statistic == input$stat,1]]==max_value
          ]
      if (length(max_player) > 1){max_player = 'Multiple Players'}
      infoBox(paste(max_player, 'has most single game', input$stat), 
              max_value, icon = icon("hand-o-up"))
    })
    
    output$maxBox2 <- renderInfoBox({
      max_value <- max(box_scores[box_scores$playDispNm == 
                                    input$player,stats[stats$statistic == 
                                                         input$stat,1]]) 
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
      infoBox(paste(input$player, 
                    "average", 
                    input$stat, 
                    'in date range per game'), 
              signif(mean(box_scores[
                box_scores$playDispNm == input$player
                & box_scores$gmDate >= input$daterange[1]
                & box_scores$gmDate <= input$daterange[2],
                stats[stats$statistic == input$stat,1]]), 
                digits = 3),
              icon = icon("calculator"), fill = TRUE)
    })
    
    output$avgBox3 <- renderInfoBox({
      infoBox(paste("Mean", input$stat, 'with',
                    input$ref), 
              signif(mean(box_scores[
                box_scores$playDispNm == input$player & 
                  (paste(box_scores$offFNm1,box_scores$offLNm1)
                   == input$ref | 
                     paste(box_scores$offFNm2,box_scores$offLNm2)
                   == input$ref | 
                     paste(box_scores$offFNm3,box_scores$offLNm3)
                   == input$ref),
                stats[stats$statistic == input$stat,1]]), 
                digits = 3),
              icon = icon("calculator"), fill = TRUE)
    })
    
    output$avgBox4 <- renderInfoBox({
      infoBox(paste("Overall mean", input$stat), 
              signif(mean(box_scores[
                box_scores$playDispNm == input$player,
                stats[stats$statistic == input$stat,1]]), 
                digits = 3),
              icon = icon("calculator"), fill = TRUE)
    })
    
    output$medBox1 <- renderInfoBox({
      infoBox(paste("Median", input$stat, 'with',
                    input$ref), 
              signif(median(box_scores[
                box_scores$playDispNm == input$player & 
                  (paste(box_scores$offFNm1,box_scores$offLNm1)
                   == input$ref | 
                     paste(box_scores$offFNm2,box_scores$offLNm2)
                   == input$ref | 
                     paste(box_scores$offFNm3,box_scores$offLNm3)
                   == input$ref),
                stats[stats$statistic == input$stat,1]]), 
                digits = 3),
              icon = icon("calculator"), fill = TRUE)
    })
    
    output$medBox2 <- renderInfoBox({
      infoBox(paste("Overall median", input$stat), 
              signif(median(box_scores[
                box_scores$playDispNm == input$player,
                stats[stats$statistic == input$stat,1]]), 
                digits = 3),
              icon = icon("calculator"), fill = TRUE)
    })
    
    #scatter plot
    output$scatter <- renderGvis({
      gvisScatterChart(data.frame(
        box_scores[
          box_scores$playDispNm == input$player,
          stats[stats$statistic == input$stat,1]], 
        box_scores[
          box_scores$playDispNm == input$player,
          stats[stats$statistic == input$stat2,1]],
        hover.html.tooltip = as.character(box_scores[
          box_scores$playDispNm == input$player,
          'hover.html.tooltip'])),
        options=list(
          title=paste(input$stat, 'vs', input$stat2),
          legend="none",
          pointSize=3,
          curveType = 'function',
          height = 500,
          hAxis=paste0("{title:'",input$stat,"'}"),
          vAxis=paste0("{title:'",input$stat2,"'}")))
    })
    
    #histogram of univariate stat filtered by referee
    output$byref <- renderGvis({
      x_max = max(box_scores[box_scores$playDispNm == input$player,]
                  [, stats[stats$statistic == input$stat,1]])
      
      df_byref = 
        data.frame(box_scores[box_scores$playDispNm == input$player & 
                                (paste(box_scores$offFNm1,box_scores$offLNm1)
                                 == input$ref | 
                                   paste(box_scores$offFNm2,box_scores$offLNm2)
                                 == input$ref | 
                                   paste(box_scores$offFNm3,box_scores$offLNm3)
                                 == input$ref),][, stats[stats$statistic ==
                                                           input$stat,1]])
      colnames(df_byref) <- as.character(input$stat)
      
      gvisHistogram(
        df_byref,
        options = list(title=paste('Games With', input$ref, 'as an Official'),
                       width = 'auto', height = 250,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"',
                                      viewWindowMode: 'explicit', 
                                      viewWindow: {min: 0, max:",x_max,"}}"),
                       vAxis = "{title: 'Number of Games'}"))
    })
    
    #line graph of single stat by date for selected date range
    output$line <- renderGvis({ 
      df_line = data.frame(box_scores[
          box_scores$playDispNm == input$player
          & box_scores$gmDate >= input$daterange[1]
          & box_scores$gmDate <= input$daterange[2]
          ,'gmDate'],
        box_scores[box_scores$playDispNm == input$player
          & box_scores$gmDate >= input$daterange[1]
          & box_scores$gmDate <= input$daterange[2],
          stats[stats$statistic == input$stat,1]])
      colnames(df_line) <- c('Date', input$stat)
      gvisLineChart(
        df_line,
        options = list(title = paste('Games between', input$daterange[1],
                                     'and', input$daterange[2]),
                       width = 'auto', height = 250,
                       legend = 'none',
                       hAxis = paste0("{title:'",input$stat,"'}"),
                       vAxis = "{title: 'Number of Games'}"))
    })
    
    
    #make overall win-loss histogram
    output$winloss <- renderGvis({
      df_winloss = data.frame(result = box_scores[box_scores$playDispNm == 
                                           input$player, 'teamRslt'])
      df_winloss %<>% summarize(wins = sum(result == 'Win'), 
                                     losses = sum(result == 'Loss')) %>%
        gather(key = 'Result', value = 'Count')
      
      gvisPieChart(df_winloss,
                   options = list(title = 'Overall Record'))
    })
    
    #make overall win-loss histogram by referee
    output$winloss_byref <- renderGvis({
      df_winloss_byref = 
        data.frame(result = box_scores[box_scores$playDispNm ==
                                input$player & 
                                (paste(box_scores$offFNm1,box_scores$offLNm1)
                                == input$ref | 
                                paste(box_scores$offFNm2,box_scores$offLNm2)
                                == input$ref | 
                                paste(box_scores$offFNm3,box_scores$offLNm3)
                                == input$ref)
                                       , 'teamRslt'])
      
      df_winloss_byref %<>% summarize(wins = sum(result == 'Win'), 
                                losses = sum(result == 'Loss')) %>%
        gather(key = 'Result', value = 'Count')
      
      gvisPieChart(df_winloss_byref,
                    options = list(
                      title = paste('Record When',
                                    input$ref, 'Refs')))
    })
  }
)