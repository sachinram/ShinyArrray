t.test.welch <- function (m1,s1,n1,m2,s2,n2) 
{
  t=(m1-m2)/sqrt(s1^2/n1+s2^2/n2)
  return(t)
}

dfr.welch <- function (s1,n1,s2,n2) 
{
  dfr <- ((s1^2/n1+s2^2)/n2)^2/(((s1^2/n1)^2)/(n1-1)+((s2^2/n2)^2)/(n2-1))
  return(dfr)
}

grep.GPR.Ac <- function(x,ac=".K.Ac..")
{
  # x: aggregated Dataset
  # ac: representation of Ac-Lys in Name column
  
  # return dataset with columns for acetylated and non-Acetylated Lysine
  
  gsub("Lys","K",x$Name) -> x$Name
  gsub(ac,"B",x$Name) -> x$Name
  ac <-  grep("^......B......$",x$Name)
  nac <- grep("^......K......$",x$Name)
  ac <- x[ac,]
  nac <- x[nac,]
  
  names(ac) <- paste(names(ac),"Ac",sep="_")
  
  tv=t.test.welch(nac$f.mean,nac$f.sd,nac$n,ac$f.mean,ac$f.sd,ac$n)
  dfr=dfr.welch(nac$f.sd,nac$n,ac$f.sd,ac$n)
  ptv=dt(tv,dfr)
  return(cbind(nac,ac,ptv))
}
