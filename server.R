
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
  
  datafile1 <- reactive(read.GPR(input$inputfile1[1,"datapath"]))
  datafile2 <- reactive(read.GPR(input$inputfile2[1,"datapath"]))
  datawoempty1 <- reactive(subset(datafile1(), Name != "empty"))
  datawoempty2 <- reactive(subset(datafile2(), Name != "empty"))
  dataresponse1 <- reactive(set.response.GPR(datawoempty1(),input$responseMethod,input$wavelengths))
  dataresponse2 <- reactive(set.response.GPR(datawoempty2(),input$responseMethod,input$wavelengths))
  refresponse <- reactive({
    reffile <- read.GPR(input$reffile[1,"datapath"])
    refwoempty <- subset(reffile, Name != "empty")
    set.response.GPR(refwoempty,input$responseMethod,input$wavelengths)
  })
  datanorm1 <- reactive({
    if(input$normMethod == "non-Acetylated")
      norm.GPR.nac(dataresponse1())
    else if (input$normMethod == "global")
      norm.GPR.global(dataresponse1())
    else if (input$normMethod == "quantile")
      norm.GPR.quantile(dataresponse1())
    else if (input$normMethod == "invariant")
      norm.GPR.invariant(dataresponse1(),refresponse(),3)
  })
  datanorm2 <- reactive({
    if(input$normMethod == "non-Acetylated")
      norm.GPR.nac(dataresponse(2))
    else if (input$normMethod == "global")
      norm.GPR.global(dataresponse2())
    else if (input$normMethod == "quantile")
      norm.GPR.quantile(dataresponse2())
    else if (input$normMethod == "invariant")
      norm.GPR.invariant(dataresponse2(),refresponse(),3)
  })
  
  dataagg1 <- reactive(agg.GPR(datanorm1()))
  output$gprTable1 <- renderDataTable(datanorm1())
  output$qualityPlots1 <- renderPlot(plot.GPR.quality(datanorm1()))
  output$aggTable1 <- renderDataTable(dataagg1())
  output$grepTable1 <- renderDataTable(grep.GPR.Ac(dataagg1()))
  output$downloadGrep1 <- downloadHandler(
    filename = function() {
      paste('data-grep', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
         write.csv(grep.GPR.Ac(dataagg1()), con)
     }
  )
  dataagg2 <- reactive(agg.GPR(datanorm2()))
  output$gprTable2 <- renderDataTable(datanorm2())
  output$qualityPlots2 <- renderPlot(plot.GPR.quality(datanorm2()))
  output$aggTable2 <- renderDataTable(dataagg2())
  output$grepTable2 <- renderDataTable(grep.GPR.Ac(dataagg2()))
  output$downloadGrep2 <- downloadHandler(
    filename = function() {
      paste('data-grep', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
         write.csv(grep.GPR.Ac(dataagg2()), con)
     }
  )
})
