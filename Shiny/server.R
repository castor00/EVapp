library(shiny)
require(xlsx)
library(ggplot2)





# Define server logic required to draw a histogram
shinyServer(
        function(input, output) {
                
                dt <- reactive({
                        
                        # input$file1 will be NULL initially. After the user selects
                        # and uploads a file, it will be a data frame with 'name',
                        # 'size', 'type', and 'datapath' columns. The 'datapath'
                        # column will contain the local filenames where the data can
                        # be found.
                        
                        inFile <- input$file1
                        
                        if (is.null(inFile))
                                return(NULL)
                        
                        read.xlsx2(inFile$datapath,1,header = TRUE, colClasses= c("numeric","numeric","numeric","numeric"))
                })
                
               
                
                ## how many rows has the file
                ms <- reactive({sum(is.na(AC()))})
                rnum <- reactive({nrow(dt())-ms()})
                cnum <- reactive({ncol(dt())})
                
                ## the slider max value and predifined value changes according the rows number
                ## of the uploaded file. 
                output$ui1 <- renderUI({
                        if (is.null(input$file1))
                                return()
                        numericInput("Time", label = p("Which column contains the time?"), 
                                     value = 1, min = 1, max = cnum())})
                output$ui2 <- renderUI({
                                if (is.null(input$file1))
                                        return()
                        numericInput("PV", label = p("Which column contains the Planned Value?"), 
                                     value = 2,min = 1, max = cnum())})
                output$ui3 <- renderUI({
                                if (is.null(input$file1))
                                        return()
                        numericInput("AC", label = p("Which column contains the Actual Cost?"), 
                                     value = 3,min = 1, max = cnum())})
                output$ui4 <- renderUI({
                                if (is.null(input$file1))
                                        return()
                        numericInput("EV", label = p("Which column contains the Earned Value?"), 
                                     value = 4,min = 1, max = cnum())})
                output$ui5 <- renderUI({
                                if (is.null(input$file1))
                                        return()
                        sliderInput("AD", label = h3("Enter Actual Day"),
                                    min = 1, max = rnum(), value = round(rnum()/2,0), step = 1)
                        
                        
                })
                        
                
                
                ## columns of the data file that contain Time, PV, AC, EV
                ADcol <- reactive({input$Time})
                PVcol <- reactive({input$PV})
                ACcol <- reactive({input$AC})
                EVcol <- reactive({input$EV})
                
                ## separate columns of PV, AC, EV  
                AD <- reactive({dt()[,ADcol()]})
                PV <- reactive({dt()[,PVcol()]})
                AC <- reactive({dt()[,ACcol()]})
                EV <- reactive({dt()[,EVcol()]})
                
                
                
                ## input of actual time
                t <- reactive({as.numeric(input$AD)})
                
                ## Calculations of SV, CV, SPI, CPI, SCI for all rows
                SV <- reactive({dt()[ ,EVcol()] - dt()[,PVcol()]})
                CV <- reactive({dt()[ ,EVcol()] - dt()[,ACcol()]})
                SPI <- reactive({dt()[,EVcol()] / dt()[,PVcol()]})
                CPI <- reactive({dt()[,EVcol()] / dt()[,ACcol()]})
                SCI <- reactive({SPI() * CPI()})
                
                
                ## creation of earned schedule table
                ESm <- reactive({
                        
                        a <- dt()[ ,ADcol()]
                        for(i in 1: 13) {
                                a <- cbind(a, EV()[i] - PV())
                                }
                        a
                })
                
                ## planned durarion 
                PVmax <- reactive({max(PV())})
                PD <- reactive({sum(PV() < PVmax())+1})
                
                ## find earned schedule 
                ESc <- reactive({ESm()[ ,t()+1]})
                EScpos <-  reactive({ESc()[ which(ESc()>0)]})
                C <- reactive({as.numeric(length(EScpos()))})
                ESt <- reactive({C() + (EV()[t()] - PV()[C()])/(PV()[C()+1] - PV()[C()])})
                
                ## calculation of SPIt, CPI, SCIt
                SPIt <- reactive({ESt()/t()})
                CPIt <- reactive({CPI()[t()]})
                SCIt <- reactive({SPIt()*CPIt()})
                
                ## Calculation of EACt
                meth <- reactive({as.numeric(input$method)})
                PF <- reactive({if(meth() == 1) {1
                } else if(meth() == 2) {SPIt()
                } else SCIt()})
                EACt <- reactive({t() + (PD() - ESt())/PF()})
                
                ## Plot
                
                plot.dt <- reactive({
                                z<- cbind(as.data.frame(AD()),
                                      as.data.frame(PV()),
                                      as.data.frame(AC()),
                                      as.data.frame(EV())
                                )
                                names(z) <- c("AD","PV","AC","EV")      
                                z
                                })
                
                
                ## Outputs
                output$plot <- renderPlot({
                                ggplot(data=plot.dt(), aes(x=AD)) + 
                                geom_line(aes(y=PV,color= "PV")) +
                                geom_line(aes(y=AC,color= "AC")) +
                                geom_line(aes(y=EV,color= "EV")) +
                                scale_colour_manual("",breaks = c("PV", "AC", "EV"),
                                             values = c("blue", "green", "red"))+
                                xlab("Time")+
                                ylab("Values")
                  })   
                output$data <- renderTable({dt()})
                output$SV <- renderPrint({SV()})
                output$CV <- renderPrint({CV()})
                output$SPI <- renderPrint({SPI()})
                output$SCI <- renderPrint({SCI()})
                output$CPI <- renderText({round(CPIt(),3)})
                output$SPIt <- renderText({round(SPIt(),3)})
                output$SCIt <- renderText({round(SCIt(),3)})
                output$EAC <- renderText({round(EACt(),3)})
                
        }
)