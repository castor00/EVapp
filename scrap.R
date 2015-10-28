data <- reactive({
        
        inFile <- input$file1
        if (is.null(inFile)) {return(NULL)
        } else {data <- read.xlsx2(inFile$datapath,
                                   header = input$header,sep = input$sep,
                                   quote = input$quote, dec = input$dec,  stringsAsFactors =FALSE)
        } 
        mydata
        
})


## Calculations of SV, CV, SPI, CPI, SCI 
SV <- reactive({dt()[ ,EVcol()] - dt()[,PVcol()]})
CV <- reactive({dt()[ ,EVcol()] - dt()[,ACcol()]})
SPI <- reactive({dt()[,EVcol()] / dt()[,PVcol()]})
CPI <- reactive({dt()[,EVcol()] / dt()[,ACcol()]})
SCI <- reactive({SPI() * CPI()})

ESm <- reactive({
        
        a <- dt()[ ,ADcol()]
        for(i in 1: 13) {
                a <- cbind(a, EV()[i] - PV())
        }
        a
})

PVmax <- max(data$PV)
PD <- sum(data$PV < PVmax)+1



ESc <- reactive({ESm()[ ,t()+1]})
EScpos <-  reactive({ESc()[ which(ESc()>0)]})
C <- reactive({as.numeric(length(EScpos()))})
ESt <- reactive({C() + (EV()[t()] - PV()[C()])/(PV()[C()+1] - PV()[C()])})
SPIt <- reactive({ESt()/t()})
CPI <- reactive({dt$CPI[t()]})
SCIt <- reactive({SPIt()*dt$CPI[t()]})

meth <- reactive({as.numeric(input$method)})
PF <- reactive({if(meth() == 1) {1
} else if(meth() == 2) {SPIt()
} else SCIt()})

EACt <- reactive({t() + (PD - ESt())/PF()})


