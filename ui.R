
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

options(shiny.maxRequestSize=30*1024^2)


shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Microarray Processing"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    
    h5("GPR File 1"),
    
    fileInput("inputfile1","Select GPR file"),
   
    h5("GPR File 2"),
    
    fileInput("inputfile2","Select GPR file"),
    
    
    hr(),h5("Parameters"),
    
    numericInput("subarrays","Subarrays",3,1,10,1),
    
    selectInput("wavelengths","Wavelength(s)",c("635","532"),c("635"),multiple=T),

    selectInput("responseMethod","Response method",
                c("log2.ratio.median","log2.diff.median","ratio.median","diff.median","fg.median","fg.mean"),c("fg.mean")),

    hr(),h5("Normalization"),
    
    selectInput("normMethod","Method",c("global","non-Acetylated","quantile","invariant"),"invariant"),
    
    
    
    conditionalPanel(condition="input.normMethod=='global' || input.normMethod=='non-Acetylated'",
      numericInput("quantile","Quantile",0.98,0,1)
    ),
    
    conditionalPanel(condition="input.normMethod=='invariant'",
      fileInput("reffile","Reference GPR file")
      #numericInput("refSA","Reference Subarray",2,1,10,1)      
    )
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
      tabPanel("File 1",
        tabsetPanel(
          tabPanel("gpr file",
            dataTableOutput("gprTable1")
          ),
          tabPanel("Quality",
            plotOutput("qualityPlots1",width="100%",height="1000px")
          ),
          tabPanel("Aggregated",
            dataTableOutput("aggTable1")
          ),
          tabPanel("Ac-NonAc",
            dataTableOutput("grepTable1"),
            downloadLink('downloadGrep1', 'Download')
          )
        )
      ),
      tabPanel("File 2",
        tabsetPanel(
          tabPanel("gpr file",
            dataTableOutput("gprTable2")
          ),
          tabPanel("Quality",
            plotOutput("qualityPlots2",width="100%",height="1000px")
          ),
          tabPanel("Aggregated",
            dataTableOutput("aggTable2")
          ),
          tabPanel("Ac-NonAc",
            dataTableOutput("grepTable2"),
            downloadLink('downloadGrep2', 'Download')
          )
        )
      )	
    )
  )
))
