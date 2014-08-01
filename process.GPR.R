function (file="",name="",response="fg.mean",plotDir="arrays") 
{  
  # file: gpr file name
  # name: dataset name
  # response: column taken as response
  # plotDir: output for quality plots
  
  # return: nothing
  
  # output: qualtity plots
  #         raw datasets, agg and grep datasets as objects
  
  # some settings for reference
  ref.1679 <- ref.1679.43
  ref.1685 <- ref.1685.43
  
  # read datasetname if empty
  if(!nchar(name))
    readline("Datensatzname? ") -> name
  
  
  # read GPR file
  cat("Reading ",file," in dataset ", name, " ...")
  read.GPR(file) -> data
  
  # set the response columns
  set.response.GPR(data,response=response) -> data
  subset(data,Name != "empty") -> data
  
  # normalize with invariant set
  cat("... normalzing ...")
  set.response.GPR(ref.1679,response=response) -> ref.1679
  set.response.GPR(ref.1685,response=response) -> ref.1685
  subset(ref.1679,Name != "empty") -> ref.1679
  subset(ref.1685,Name != "empty") -> ref.1685
  
  
  if(nrow(data) == nrow(ref.1679) || nrow(data) == nrow(ref.1685))
  {
    if(regexpr("1679",name) > 0)
      norm.GPR.invariant(data,ref.1679) -> data
    else if(regexpr("1685",name) > 0)
      norm.GPR.invariant(data,ref.1685) -> data
    else
      cat("!!! Not a 1679/85 data set name, cannot normalize!")
  }
  else
    cat("Dataset error! Lengths differ.",nrow(ref.1679), " ; ", nrow(ref.1685), " ; ", nrow(data))
  
  # write in global variable
  assign(name,data,envir=.GlobalEnv)
  
  # make quality report
  cat("...plotting...")
  if(dev.cur()!=1)
    dev.off()
  if(!file.exists(plotDir))
    dir.create(plotDir)
  
  # plot normalized subarrays
  pdfName=paste(plotDir,"/",name,"_quality-plots.pdf",sep="")
  pdf(pdfName)
  cor123 <- plot.GPR.quality(data)
  dev.off()
  
  
  file.list[grep(name,file.list$data.name),c("cor12","cor23","cor31")] <<- cor123
  
  # aggregate subarrays
  cat("... aggregating ...")
  agg.GPR.data(data) -> data.agg
  assign(paste(name,".agg",sep=""),data.agg,envir=.GlobalEnv)
  
  # grep Acetylated
  cat("... grepping ... ")
  grep.GPR.Ac(data.agg) -> data.grep
  
  file.list[grep(name,file.list$data.name),c("n","n.detectable")] <<- c(nrow(data.grep),nrow(subset(data.grep,ptv<=0.05 & f.mean < f.mean_Ac)))
  
  
  assign(paste(name,".grep",sep=""),data.grep,envir=.GlobalEnv)
  if(dev.cur()!=1)
    dev.off()
  
  cat("... done\n")
}
