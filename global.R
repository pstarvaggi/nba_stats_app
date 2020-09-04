
# convert matrix to dataframe
state_stat <- data.frame(state.name = rownames(state.x77), state.x77)
# remove row names
rownames(state_stat) <- NULL
# create variable with colnames as choice 
choice <- colnames(state_stat)[-1]


library(shiny)
library(tidyverse)

box_scores = read.csv('NBA_Enhanced_Box_Score_and_Standings/2012-18_playerBoxScore.csv')

box_scores %<>% mutate(playName = paste(playFNm,playLNm))
