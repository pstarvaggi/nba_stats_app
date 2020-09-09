library(shinydashboard)
library(shiny)
library(tidyverse)
library(DT)
library(googleVis)
library(magrittr)


#Read and clean the data
box_scores = read.csv('NBA_Enhanced_Box_Score_and_Standings/2012-18_playerBoxScore.csv')
box_scores %<>% mutate(fanduelPTS = playPTS + 1.2*playTRB + 1.5*playAST + 3*playBLK
                       + 3*playSTL - playTO)
box_scores$gmDate = as.Date(box_scores$gmDate, '%Y-%m-%d')
box_scores %<>% mutate(hover.html.tooltip = case_when(
  teamLoc == 'Away' ~ paste(gmDate, teamRslt, '@', opptAbbr),
  teamLoc == 'Home' ~ paste(gmDate, teamRslt, 'vs', opptAbbr)))


#Make player vector
players = unique(box_scores$playDispNm[order(box_scores$playLNm)])

#Make stats df with col1 colnames(box_scores) and col2 readable versions
stats = colnames(box_scores)[20:52][-1*2:5][-1*23:28]
stats %<>% data.frame(stat = stats, statistic = c('Minutes',
                                                  'Points',
                                                  'Assists',
                                                  'Turnovers',
                                                  'Steals',
                                                  'Blocks',
                                                  'Fouls',
                                                  'Field Goal Attempts',
                                                  'Field Goal Makes',
                                                  'Field Goal Percent',
                                                  '2PT Attempts',
                                                  '2PT Makes',
                                                  '2PT Percent',
                                                  '3PT Attempts',
                                                  '3PT Makes',
                                                  '3PT Percent',
                                                  'FT Attempts',
                                                  'FT Makes',
                                                  'FT Percent',
                                                  'Offensive Rebounds',
                                                  'Defensive Rebounds',
                                                  'Rebounds',
                                                  'Fanduel Points')) %>%
  .[-1]

#make officials vector
officials = unique(data.frame(Names = c(paste(box_scores$offFNm1, box_scores$offLNm1),
         paste(box_scores$offFNm2, box_scores$offLNm2),
         paste(box_scores$offFNm3, box_scores$offLNm3)))) %>%
  mutate(Lname = gsub('^.*\\s','',.$Names)) %>%
  arrange(Lname) %>% .[-1,1]
  
#NBA logo
nba_logo = img(src('nbalogo.jpg'))

