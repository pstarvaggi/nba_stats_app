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
                     choices = colnames(box_scores)[20:45][-2])
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "map",
                fluidRow(infoBoxOutput('maxBox'),
                         infoBoxOutput('minBox'),
                         infoBoxOutput('avgBox')),
                fluidRow(box(htmlOutput('hist'),
                             height = 300))),
        tabItem(tabName = "data",
                fluidRow(box(DT::dataTableOutput('table'),
                             width = 12)))
        )
    )
  )
)
