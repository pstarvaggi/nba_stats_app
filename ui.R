library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "My Dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Graphs", tabName = "graphs", icon = icon("bar-chart-o")), 
        menuItem("Data", tabName = "data", icon = icon("database"))
        ),
      selectizeInput(inputId = 'player', 
                     label = 'Player',
                     choices = players,
                     selected = 'LeBron James'),
      selectizeInput(inputId = 'stat',
                     label = 'Statistic',
                     choices = stats$statistic,
                     selected = 'Points')
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "graphs",
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
