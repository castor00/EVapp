

library(xlsx)

data <- read.xlsx2("data/EV_input.xlsx",1, header = TRUE, colClasses= c("numeric","numeric","numeric","numeric"))
data$SV <- data$EV - data$PV
data$SV <- data$EV - data$AC
data$SV <- data$EV - data$PV
data$CV <- data$EV - data$AC
data$SPI <- data$EV / data$PV
data$CPI <- data$EV / data$AC
data$SCI <- data$SPI * data$CPI

ESm <- data[,1]

for(i in 1:nrow(data)) {
        ESm <- cbind(ESm, data$EV[i] - data$PV)
}

PVmax <- max(data$PV)
PD <- sum(data$PV < PVmax)+1
t <- 5
ESc <- ESm[ ,t+1]
EScpos <-  ESc[ESc>0]
C <- as.numeric(length(EScpos))

ESt <- C + (data$EV[t] - data$PV[C])/(data$PV[C+1] - data$PV[C])
SPIt <- ESt/t
SCIt <- SPIt*data$CPI[t]

PF1 <- 1
PF2 <- SPIt
PF3 <- SCIt

EAC1 <- t + (PD - ESt)/PF1
EAC2 <- t + (PD - ESt)/PF2
EAC3 <- t + (PD - ESt)/PF3

## Plot

plotdata <- list(PV = data$PV, AC = data$AC[1:t], EV = data$EV[1:t])
xrange <- range(1:nrow(data)) 
yrange <- range(0,data$AC,data$PV, data$EV )
plotchar <- c(1,2,3)
colors <- c("red","green","blue")

plot(xrange, yrange, type="n", xlab="Time",
     ylab="Value" ) 
lines(data$PV, type="b", lwd=1.5, pch = plotchar[1],col=colors[1])
lines(data$EV[1:5], type="b", lwd=1.5, pch = plotchar[2],col=colors[2])
lines(data$AC[1:5], type="b", lwd=1.5, pch = plotchar[3],col=colors[3])

legend(xrange[1], yrange[2], c("Planned Value", "Earned Value", "Actual Cost"), cex=0.8, col=colors,
       pch=plotchar)


