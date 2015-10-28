library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        navbarPage("Project Duration Estimation",
                 tabPanel("Data Upload",
                        sidebarLayout(
                
                        sidebarPanel(
                                fileInput('file1', 'Select the data file',
                                #Accepted files
                                accept=c('.xlsx',".xls")),
                                uiOutput("ui1"),
                                uiOutput("ui2"),
                                uiOutput("ui3"),
                                uiOutput("ui4")
                                ),
                        mainPanel(
                                h4("Preview of Uploaded Data"),
                                tableOutput("data"))
                        )),
                
                tabPanel("Output",
                         sidebarLayout(
                                sidebarPanel( 
                                uiOutput("ui5"),
                                radioButtons("method", label = h3("Select Estimation Method"),
                                          choices = list("PF = 1" = 1, "PF = SPI(t)" = 2,
                                                         "PF = SCI(t)" = 3),selected = 1)
                                ),
                        mainPanel(
                                h4("Project's Schedule Performance Index (SPI(t)) is"),
                                textOutput("SPIt"),
                                h4("Project's Cost Performance Index (CPI) is"),
                                textOutput("CPI"),
                                h4("Project's Schedule Cost Index (SCI(t)) is"),
                                textOutput("SCIt"),
                                h4("Project's Estimated at Completion Time (EAC(t)) is"),
                                textOutput("EAC")
                        ))
                ),
                tabPanel("Documentation",
                         h4("Introduction"),
                         p("This application takes the input form the user (an excel file) and 
                                calculates the basic earned schedule indexes and 
                                makes an estimate on the completion day of the project.
                                The application has two tabs: the 'Data Upload' tab, where the user 
                                uploads and configures the the data and the 'Output' tab, where the
                                the output is given according the user selections. 
                                The application uses the earned schedule method proposed by Lipke (2003). 
                           More information on earned schedule can be found", 
                           a("here.",
                             href = "http://www.earnedschedule.com")),
                         p("The code for the application can be found",
                           a("here.",
                             href = "https://github.com/castor00/Dev_Data_Prod_Course_prj")),
                         h4("Data Upload"),
                         p("The user is asked to upload his/her data file. The application supports
                                only '.xlsx' file formats. The file, in the first sheet, 
                           should contain the following:"),
                         br(),
                         p(strong("a. A column with the time in numbers")),
                         p(strong("b. A column with the planned value")),
                         p(strong("c. A column with the actual cost, and")),
                         p(strong("d. A column with the earned value")),
                         br(),
                         p("Since the file is uploaded the user should indicate which column number
                                contains the above data. The first row of the file is a header 
                                and the rest contain the data. A preview of the uploaded data is given 
                                to help the user."),
                         h4("Output"),
                         p("In the output tab the user is asked to select the project's actual day 
                                by using the slider and select the estimation method. 
                                The project's",
                         strong("actual day"),"is the",
                           em("Time Now"),"and is counted in days from the project's start day. 
                                The estimation method configures the method that should be used for the 
                                calculation of the",
                        strong("Performance Factor (PF)"),".The PF is an assumption on the expected performance of the future work, 
                          as follows:"),
                        br(),
                        p(strong("1. PF = 1." ), "Future performance is expected to follow the baseline schedule."),
                        p(strong("2. PF = SPI(t)." ), "Future performance is expected to follow the current time performance."),
                        p(strong("3. PF = SCI(t)." ), "Future performance is expected to follow the current time and cost performance."),
                        br(),
                        p("The application calculates the basic performance indexes (SPI(t), CPI and SCI(t)) and the Estimated At Completion Time (EAC(t)) 
                    for the Actual Day entered and the estimation method (PF) selected. Some basic 
                          information on the indexes calculated is given below:"),
                         br(),
                         p(strong("SPI(t)" ), "is and index that shows the current schedule performance. 
                    SPI(t) > 1 means that the project is ahead of schedule,
                    SPI(t) < 1 means that the project is behind schedule and
                    SPI(t) = 1 means that the project is on schedule"),
                         p(strong("CPI" ), "is and index that shows the current cost performance. 
                    CPI > 1 means that the project is under budget,
                    CPI < 1 means that the project is over budget and
                    CPI = 1 means that the project is on budget"),
                         p(strong("CSI(t)" ), "is a composite index for schedule and cost performance. 
                    It is the product of SPI(t) and CPI."),
                         p(strong("EAC(t)" ), "Is the Estimation At Completion Time, i.e. the estimated duration of the project."),
                         br(),
                         p(strong("References")),
                         p("Lipke, Walt (2003). Schedule is Different. The Measurable News, March & Summer 2003"))
                  
)))