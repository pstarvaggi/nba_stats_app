

shinyUI(
  dashboardPage(
    dashboardHeader(title = "NBA Stats"),
    
    dashboardSidebar(
      sidebarMenu(
        menuItem("Univariate", tabName = "univariate", icon = icon("bar-chart-o")), 
        menuItem("Bivariate", tabName = "bivariate", icon = icon('basketball-ball')),
        menuItem("By Official", tabName = "official", icon = icon('asterisk')),
        menuItem("Date Range", tabName = 'bydate', icon = icon('calendar-alt')),
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
                               selected = 'Assists'),
                fluidRow(infoBoxOutput('maxBox2', width = 6),
                         infoBoxOutput('maxBox3', width = 6)),
                fluidRow(box(htmlOutput('scatter'),
                             width = 'auto',
                             height = 'auto'))),
        tabItem(tabName = "official",
                selectizeInput(inputId = 'ref',
                               label = 'Referee',
                               choices = officials,
                               selected = 'Tony Brothers'),
                fluidRow(box(htmlOutput('byref'),
                             width = 'auto',
                             height = 'auto')),
                fluidRow(box(htmlOutput('hist2'),
                             width = 'auto',
                             height = 'auto')),
                fluidRow(infoBoxOutput('avgBox3', width = 6),
                         infoBoxOutput('avgBox4', width = 6)),
                fluidRow(infoBoxOutput('medBox1', width = 6),
                         infoBoxOutput('medBox2', width = 6)),
                fluidRow(infoBoxOutput('winloss_byref', width = 'auto')),
                fluidRow(infoBoxOutput('winloss', width = 'auto'))
                ),
        tabItem(tabName = "bydate",
                dateRangeInput("daterange", "Date range:",
                               start  = "2017-10-30",
                               end    = "2018-04-11",
                               min    = "2012-10-30",
                               max    = "2018-04-11",
                               separator = "to",
                               startview = 'year'),
                fluidRow(infoBoxOutput('maxBox4', width = 'auto'),
                         infoBoxOutput('avgBox2', width = 'auto')),
                fluidRow(box(htmlOutput('line'),
                             width = 'auto',
                             height = 'auto')),
                fluidRow(box(htmlOutput('hist3'),
                             width = 'auto',
                             height = 'auto'))),
        tabItem(tabName = "data",
                fluidRow(box(DT::dataTableOutput('table'),
                             width = 12)))
        )
    )
  )
)
