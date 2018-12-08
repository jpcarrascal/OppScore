# OppScore

Yet another R script for calculating opportunity scores and plotting the Opportunity Map / Landscape.

This one does not require anything beyond base R. A sampledata.csv file is included for testing purposes.

How to use:
1. Format your data as a CSV file. It should have at least 3 columns:
   _outcome_, _importance_ and _satisfaction_. Optionally, modify the _threshold_ parameter in the script. _threshold_ should be your scale middle point. E.g., for a 1-5 scale _threshold_ equals 3. If your scale is 1-7, then it should be 4 and so on.
2. You can also customize the file names and column names to match those in your CSV file.
   The script will ignore any extra columns.
3. Run the whole script. Voila.

*_Values above the threshold parameter (either importance or satisfaction) will be considered positive. This is an important consideration when computing the score. Note that using a scale other than 1-5 deviates from Ulwick's recommendation._

Source:

> Ulwick, Anthony. [What customers want](https://www.amazon.com/What-Customers-Want-Outcome-Driven-Breakthrough/dp/0071408673). McGraw-Hill Professional Publishing, 2005.