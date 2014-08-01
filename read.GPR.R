read.GPR <- function (file.name = "") 
{
  if (!nchar(file.name)) 
    return()
  sizeLine <- scan(file.name, integer(), 2, skip = 1, sep = "\t")
  headCount = sizeLine[1]
  columnCount = sizeLine[2]
  data <- read.delim(file.name, skip = headCount + 2)
  return(data)
}

