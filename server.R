
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)




shinyServer(function(input, output) {
  
  source("read.GPR.R")
  source("set.response.GPR.R")
  source("normalize.R")
  source("plot.GPR.quality.R")
  source("agg.GPR.R")
  source("grep.GPR.Ac.R")
  
  datafile <- reactive(read.GPR(input$inputfile[1,"datapath"]))
  datawoempty <- reactive(subset(datafile(), Name != "empty"))
  dataresponse <- reactive(set.response.GPR(datawoempty(),input$responseMethod,input$wavelengths))
  refresponse <- reactive({
    reffile <- read.GPR(input$reffile[1,"datapath"])
    refwoempty <- subset(reffile, Name != "empty")
    set.response.GPR(refwoempty,input$responseMethod,input$wavelengths)
  })
  datanorm <- reactive({
    if(input$normMethod == "non-Acetylated")
      norm.GPR.nac(dataresponse())
    else if (input$normMethod == "global")
      norm.GPR.global(dataresponse())
    else if (input$normMethod == "quantile")
      norm.GPR.quantile(dataresponse())
    else if (input$normMethod == "invariant")
      norm.GPR.invariant(dataresponse(),refresponse())
  })
  
  dataagg <- reactive(agg.GPR(datanorm()))
  output$gprTable <- renderDataTable(datanorm())
  output$qualityPlots <- renderPlot(plot.GPR.quality(datanorm()))
  output$aggTable <- renderDataTable(dataagg())
  output$grepTable <- renderDataTable(grep.GPR.Ac(dataagg()))
})
