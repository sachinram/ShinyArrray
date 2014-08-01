norm.GPR.global <- function (data, subarrays=3, quant=0.98)
{
  blocksPerSA <- max(data$Block)/subarrays
  result <- data.frame();
  for(i in 1:subarrays)
  {
    sa <- subset(data, Block <= i*blocksPerSA & Block > (i-1)*blocksPerSA)
    sa$response.norm <- sa$response/quantile(sa$response,quant)*2^16*quant
    if(i==1)
      result <- sa
    else
      result <- rbind(result,sa)
  }
  return(result)
}

norm.GPR.nac <- function (data,subarrays=3, quant=0.98) 
{
  blocksPerSA <- max(data$Block)/subarrays
  
  nac <- subset(data, ID %in% grep("^......K......$", ID, value = TRUE))
  global.quant <- quantile(nac$response, quant)
 
  result <- data.frame();
  for(i in 1:subarrays)
  {
    sa <- subset(data, Block <= i*blocksPerSA & Block > (i-1)*blocksPerSA)
    sa.nac <- subset(sa, ID %in% nac$ID) 
    qant <- quantile(sa.nac$response,quant)
    sa$response.norm <- sa$response/qant*global.quant
    if(i==1)
      result <- sa
    else
      result <- rbind(result,sa)
  }
  return(result)
}

norm.GPR.quantile <- function (data,subarrays=3) 
{
  library(preprocessCore)
  
  response.matrix <- matrix(data$response, ncol = subarrays)
  
  data$response.norm <- matrix(normalize.quantiles(response.matrix),ncol = 1)
  return(data)
}

norm.GPR.invariant <- function (data, ref, subarrays=3, refSA=2) 
{
  prd.td.vals = c(0.003, 0.008)
  library(affy)
  
  blocksPerSA <- max(data$Block)/subarrays
  result <- data.frame();
  ref <- subset(ref, Block <= refSA*blocksPerSA & Block > (refSA-1)*blocksPerSA)
  for(i in 1:subarrays)
  {
    sa <- subset(data, Block <= i*blocksPerSA & Block > (i-1)*blocksPerSA)
    tmp <- normalize.invariantset(sa$response, ref$response,prd.td = prd.td.vals)
    sa$response.norm <- as.numeric(approx(tmp$n.curve$y, tmp$n.curve$x, 
                                         xout = sa$response, rule = 2)$y)
    sa$response.sd.norm <- as.numeric(approx(tmp$n.curve$y, tmp$n.curve$x, 
                                             xout = sa$response.sd, rule = 2)$y)
    if(i==1)
      result <- sa
    else
      result <- rbind(result,sa)
  }
  return(result)
}


