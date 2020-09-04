library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "My Dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Map", tabName = "map", icon = icon("map")), 
        menuItem("Data", tabName = "data", icon = icon("database"))
        ),
      selectizeInput(inputId = 'player', 
                     label = 'Player',
                     choices = unique(box_scores$playDispNm[order(box_scores$playLNm)]),
                     selected = 'LeBron James'),
      selectizeInput(inputId = 'stat',
                     label = 'Statistic',
                     choices = colnames(box_scores)[20:45][-1*2:5],
                     selected = 'playPTS')
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "map",
                fluidRow(infoBoxOutput('maxBox', width = 'auto'),
                         infoBoxOutput('avgBox', width = 'auto')),
                fluidRow(box(htmlOutput('hist'),
                             width = 'auto',
                             height = 'auto'))),
        tabItem(tabName = "data",
                fluidRow(box(DT::dataTableOutput('table'),
                             width = 12)))
        )
    )
  )
)
