library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "NBA Stats"),
    
    dashboardSidebar(
      sidebarMenu(
        menuItem("Univariate", tabName = "univariate", icon = icon("bar-chart-o")), 
        menuItem("Bivariate", tabName = "bivariate", icon = icon('basketball-ball')), 
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
        tabItem(tabName = "univariate",
                fluidRow(infoBoxOutput('maxBox', width = 'auto'),
                         infoBoxOutput('avgBox', width = 'auto')),
                fluidRow(box(htmlOutput('hist'),
                             width = 'auto',
                             height = 'auto'))),
        tabItem(tabName = "bivariate",
                selectizeInput(inputId = 'stat2',
                               label = 'y-Axis Statistic',
                               choices = stats$statistic,
                               selected = 'Points'),
                fluidRow(box(htmlOutput('scatter'),
                             width = 12,
                             height = 300))),
        tabItem(tabName = "data",
                fluidRow(box(DT::dataTableOutput('table'),
                             width = 12)))
        )
    )
  )
)
