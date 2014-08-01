combined.sd <- function (S,N) 
{
  return(sqrt(sum((N-1)*S^2)/sum(N)-length(N)))
}

weighted.sd <- function (x, w) 
{
  w <- w/sum(w)
  return(sqrt(sum(w^2 * x^2)))
}

agg.GPR <- function(data)
{
  library(mapReduce)
  
  # data: a GPR dataset
  # return: dataset, aggregated by ID
    
  gsub("Lys","K",data$ID) -> data$ID
  
  ifelse(data$Flags==-100,1,0) -> data$badness
  
  1/(data$response.sd.norm^2) -> data$weight

  weighted.sd <- function(x,w)
  {
    return(sqrt(sum(w^2*x^2)/sum(w^2)))
  }
  
  as.data.frame(mapReduce(ID,f.mean=mean(F635.Mean),f.sd=combined.sd(F635.SD,F.Pixels),
                          n=sum(F.Pixels),response.norm.w=weighted.mean(x=response.norm,w=weight),
                          response.sd.norm.w=weighted.sd(x=response.sd.norm,w=weight),badness=sum(badness),
                          data=data,apply=base::sapply)) -> result

  result$Name <- row.names(result)
  row.names(result) <- NULL
  return(result)  
}