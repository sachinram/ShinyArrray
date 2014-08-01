plot.GPR.quality <- function (data) 
{
  # data: a data set
  # return: nothing
  # output: quality plots
  
  blocks <- max(data$Block)/3
  subset(data,Block<=blocks) -> data1
  subset(data,Block>blocks & Block <= blocks*2) -> data2
  subset(data,Block>blocks*2) -> data3
  split.screen(c(2,3))
  
  pal <- c("")
  pal[1] <- "red"
  pal[26] <- "orange"
  pal[51] <- "yellow"
  pal[101] <- "black"
  pal[201] <- "green"
  palette(pal)
  
  maxresponse <- max(data$response.norm)
  cor12 <- cor(data1$response.norm,data2$response.norm)
  cor23 <- cor(data2$response.norm,data3$response.norm)
  cor31 <- cor(data3$response.norm,data1$response.norm)
  
  screen(1)
  plot(data1$response.norm,data2$response.norm,col=data1$Flags+101,xlab="SA1 Response",ylab="SA2 Response",xlim=c(0,maxresponse),ylim=c(0,maxresponse),pch=46)
  mtext(paste("r=",round(cor12,2)))
  screen(2)
  plot(data2$response.norm,data3$response.norm,col=data2$Flags+101,xlab="SA2 Response",ylab="SA3 Response",xlim=c(0,maxresponse),ylim=c(0,maxresponse),pch=46)
  mtext(paste("r=",round(cor23,2)))
  screen(3)
  plot(data3$response.norm,data1$response.norm,col=data3$Flags+101,xlab="SA3 Response",ylab="SA1 Response",xlim=c(0,maxresponse),ylim=c(0,maxresponse),pch=46)
  mtext(paste("r=",round(cor31,2)))
  screen(4)
  plot(data$response.norm,data$response.sd.norm,col=data$Flags+101,xlab="Response",ylab="Response SD",pch=46)
  screen(5)
  plot(data$Y,data$response.norm,col=data$Flags+101,xlab="Position y",ylab="Response",pch=46)
  screen(6)
  hist(data$response,100,xlab="Response",main="")  
}
