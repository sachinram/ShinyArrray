set.response.GPR <- function (data, response = "fg.mean", wavelengths = c("635")) 
{
  for (i in 1:length(wavelengths)) {
    fmeancol = paste("F", wavelengths[i], ".Mean", sep = "")
    fmedcol = paste("F", wavelengths[i], ".Median", sep = "")
    bmeancol = paste("B", wavelengths[i], ".Mean", sep = "")
    bmedcol = paste("B", wavelengths[i], ".Median", sep = "")
    fsdcol = paste("F", wavelengths[i], ".SD", sep = "")
    bsd2col = paste("B", wavelengths[i], ".SD2", sep = "")
    if (length(wavelengths) > 1) 
      responsecol = paste("response", wavelengths[i], sep = "")
    else responsecol = "response"
    if (length(wavelengths) > 1) 
      responsesdcol = paste("response", wavelengths[i], 
                            ".sd", sep = "")
    else responsesdcol = "response.sd"
    if (response == "log2.ratio.median") 
      data[[responsecol]] <- log2(data[[fmedcol]]/data[[bmedcol]])
    else if (response == "log2.diff.median") 
      data[[responsecol]] <- log2(data[[fmedcol]] - data[[bmedcol]])
    else if (response == "ratio.median") 
      data[[responsecol]] <- data[[fmedcol]]/data[[bmedcol]]
    else if (response == "diff.median") 
      data[[responsecol]] <- data[[fmedcol]] - data[[bmedcol]]
    else if (response == "fg.median") {
      data[[responsecol]] <- data[[fmedcol]]
      data[[responsesdcol]] <- data[[fsdcol]]
    }
    else if (response == "fg.mean") {
      data[[responsecol]] <- data[[fmeancol]]
      data[[responsesdcol]] <- data[[fsdcol]]
    }
    else cat("No suitable response value given.")
  }
  return(data)
}
