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


# File and column names:

filename <- "sampledata.csv"
outcomeName <- "outcome"
impName <- "importance"
satName <- "satisfaction"

# threshold: above which Importance and Satisfaction are counted as positive and non-neutral
# It should be the middle point of your scale, e.g., threshold=3 if your scale is 1-5, 4 for 1-7, etc.

threshold <- 3

# functions:
op_score <- function(imp, sat) {
  return(imp + max(imp-sat,0) )
}

count_positive <- function(x, threshold) {
  x = na.omit(x)
  return (10* (sum(x>threshold)/length(x)) )
}

plotOppScore <- function(values)
{
  grey <- "#AAAAAA"
  par(xpd=F)
  plot(NULL, xlim=c(1,10), ylim=c(1,10), yaxt="n", xaxt="n", xaxs="i", yaxs="i", xlab = "Importance", ylab = "Satisfaction", main="Opportunity Landscape")
  axis(1, at = c(1:10), labels=c(1:10), cex=1)
  axis(2, at = c(1:10), labels=c(1:10), cex=1)
  segments(1, 1, 10, 10, lty = 1, col=grey)
  segments(5.5, 1, 10, 10, lty = 1, col=grey)
  abline(a = -11.5, b = (10-1)/(10-5.5), lty = 3, col=grey)
  abline(a = -14.5, b = (10-1)/(10-5.5), lty = 3, col=grey)
  text(3,5.8,"Overserved",col=grey)
  text(4,2,"Appropriately\nServed",col=grey)
  text(8,2,"Undeserved",col=grey)
  text(8.5,6,"Opp>10",col=grey)
  text(9,4.5,"Opp>12",col=grey)
  text(9.5,3,"Opp>15",col=grey)
  par(xpd=T)
  points(values$importance, values$satisfaction, xlim=c(1,10), ylim=c(1,10), col=2, pch=19, cex=2)
  with(values, text(satisfaction~importance, labels = c(1:length(values$outcome)), pos = 2, col=1, srt=0, cex=0.8))
  legend(1.1,9.9, paste(c(1:length(values$outcome)),values$outcome,sep=". "), cex=0.85, x.intersp=0.0)
}

# Read the data and run the functions:

inputData <- read.csv(filename, header = T, sep = ",")
inputData <- inputData[c(outcomeName,impName, satName)]
colnames(inputData) <- c("outcome","importance","satisfaction")
imp <- aggregate(importance~outcome, inputData, count_positive, threshold=threshold)
sat <- aggregate(satisfaction~outcome, inputData, count_positive, threshold=threshold)
values <- merge(x = imp, y = sat, by = "outcome", all = TRUE)
values$oppscore = op_score(values$importance, values$satisfaction)
print(values)
plotOppScore(values)



