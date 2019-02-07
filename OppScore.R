######################################################################################################
#
# Yet another R script for computing the opportunity score and plotting the opportunity map/landscape
# Does not require anything beyond base R.
#
# Written by JP Carrascal: www.jpcarrascal.com, www.github.com/jpcarrascal
#
# How to use:
# 1. Format your data as a CSV file. It should have at least 3 columns:
#    "outcome", "importance" and "satisfaction"
# 2. You can also customize the file names and column names below to match those in yout CSV file.
#    The script will ignore any extra columns.
# 3. Run the whole script. Voila.
#
######################################################################################################

# threshold above which Importance and Satisfaction are counted as positive and non-neutral
# It should be the middle point of your scale.
# E.g., if your scale is 1-5, threshold should be 3. For 1-7 it should be 4, etc.

threshold <- 3

# File and column names:

filename <- "sampledata.csv"
outcomeName <- "outcome"
impName <- "importance"
satName <- "satisfaction"


# functions:
op_score <- function(imp, sat) {
  return(imp + max(imp-sat,0) )
}

count_positives <- function(x, threshold) {
  x = na.omit(x)
  return (10* (sum(x>threshold)/length(x)) )
}

plotOppScore <- function(values)
{
  grey <- "#AAAAAA"
  par(xpd=F)
  plot(NULL, xlim=c(0,10), ylim=c(0,10), yaxt="n", xaxt="n", xaxs="i", yaxs="i", xlab = "Importance", ylab = "Satisfaction", main="Opportunity Landscape")
  axis(1, at = c(1:10), labels=c(1:10), cex=1)
  axis(2, at = c(1:10), labels=c(1:10), cex=1)
  segments(0, 0, 10, 10, lty = 1, col=grey)
  segments(5, 0, 10, 10, lty = 1, col=grey)
  abline(a = -11.5, b = (10-1)/(10-5.5), lty = 3, col=grey)
  abline(a = -14.5, b = (10-1)/(10-5.5), lty = 3, col=grey)
  text(3,5.8,"Overserved",col=grey)
  text(4,2,"Appropriately\nServed",col=grey)
  text(8,2,"Undeserved",col=grey)
  text(8.5,6,"Opp>10",col=grey)
  text(9,4.5,"Opp>12",col=grey)
  text(9.5,3,"Opp>15",col=grey)
  par(xpd=T)
  points(values$importance, values$satisfaction, xlim=c(0,10), ylim=c(0,10), col=2, pch=19, cex=2)
  with(values, text(satisfaction~importance, labels = c(1:length(values$outcome)), pos = 2, col=1, srt=0, cex=0.8))
  legend(0.1,9.9, paste(c(1:length(values$outcome)),values$outcome,sep=". "), cex=0.85, x.intersp=0.0)
}

# Borrowed from http://jeromyanglim.tumblr.com/post/50228877196/round-numbers-in-data-frame-that-contains-non
round_df <- function(x, digits) {
  # round all numeric variables
  # x: data frame 
  # digits: number of digits to round
  numeric_columns <- sapply(x, class) == 'numeric'
  x[numeric_columns] <-  round(x[numeric_columns], digits)
  x
}

# Read the data and run the functions:

inputData <- read.csv(filename, header = T, sep = ",", fileEncoding="UTF-8-BOM")
inputData <- inputData[c(outcomeName,impName, satName)]
colnames(inputData) <- c("outcome","importance","satisfaction")
imp <- aggregate(importance~outcome, inputData, count_positives, threshold=threshold)
sat <- aggregate(satisfaction~outcome, inputData, count_positives, threshold=threshold)
values <- merge(x = imp, y = sat, by = "outcome", all = TRUE)
values$oppscore = op_score(values$importance, values$satisfaction)
values <- values[order(-values$oppscore),]
print(round_df(values, 2))
plotOppScore(values)



