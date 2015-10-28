df1 <- as.data.frame(data$PV)
df1$Time <- seq(1:nrow(df1))
names(df1)[1] <- "Planned Value"
df2 <- as.data.frame(cbind(data$EV[1:t],data$AC[1:t]))
df2$Time <- seq(1:nrow(df2))
names(df2) <- c("Earned Value", "Actual Value")

(plot1 <- ggplot(data[, 1], aes(AC)) + 
         geom_point() +
         geom_line(data = df2)
)