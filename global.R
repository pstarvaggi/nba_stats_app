library(shiny)
library(tidyverse)
library(DT)
library(googleVis)

box_scores = read.csv('NBA_Enhanced_Box_Score_and_Standings/2012-18_playerBoxScore.csv')


players = unique(box_scores$playDispNm[order(box_scores$playLNm)])
stats = colnames(box_scores)[20:45][-1*2:5]

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
                                                  'Rebounds')) %>%
  .[-1]



