################################################################################################################################
## 
## Author: Claire Little https://github.com/clairelittle/psd2022-comparing-utility-risk
## Date: April 2022
## r version: 4.1.3
## RStudio version: 2021.09.0+351 "Ghost Orchid" Release (077589bcad3467ae79f318afe8641a1899a51606, 2021-09-20) for Windows
##
## This file calculate the Ratio of counts/estimates (usually referred to as ROC/ROE) for the samples/synthetic data compared 
## to the original data.
## Code is for calculating univariate and bivariate cross-tabulations
##
## Since the comparison between original and sample data is not even (i.e. they contain a different number of rows), the ROC 
## function was modified to compare proportions instead of counts (which only works when both datasets are the same size)
## (The results are the same whichever function is used for datasets of the same size)
##
################################################################################################################################


###################################################### ROC functions


##### ***** NOTE: This code is simple and without error checking - use at own risk - check the results make sense!
##### ***** For both the functions, it requires that the data column (variable) order is the same for the original and the 
##### ***** synthetic/sample data. 
##### ***** Also that the columns to be compared are of the same type (e.g data$age is integer and synth$age is integer)



################################################################################################################################
########################### ROC univariate function
################################################################################################################################
# Ratio of Counts/Estimates - univariate - using one variable

# INPUTS:
#     original:   the original dataset
#     synthetic:  the synthetic dataset
#     var_num:    index of the variable (e.g. for column 1, use 1)
# OUTPUTS:
#     results:    the ratio of estimates/counts for the particular variable


roe_univariate <- function(original, synthetic, var_num) {
  # create frequency tables for the original and synthetic data, on the variable
  orig_table <- as.data.frame(ftable(original[,var_num]))
  syn_table <- as.data.frame(ftable(synthetic[,var_num]))
  # calculate the proportions by dividing by the number of records in each dataset
  orig_table$prop <- orig_table$Freq/nrow(original)
  syn_table$prop <- syn_table$Freq/nrow(synthetic)
  # merge the two tables, by the variable
  combined<- merge(orig_table, syn_table, by= c('Var1'), all = TRUE) 
  # merging will induce NAs where there is a category mismatch - i.e. the category exists in one dataset but not the other
  # to deal with this set the NA values to zero:
  combined[is.na(combined)] <- 0
  # get the maximum proportion for each category level:
  combined$max <- pmax(combined$prop.x, combined$prop.y)
  # get the minimum proportion for each category level:
  combined$min <- pmin(combined$prop.x, combined$prop.y)
  # roc is min divided by max (a zero value for min results in a zero for ROC, as expected)
  combined$roc <- combined$min/combined$max 
  #combined$roc[is.na(combined$roc)] <- 1
  mean(combined$roc)
}



################################################################################################################################
########################### ROC Bivariate function
################################################################################################################################

# Ratio of Counts/Estimates - bivariate - using two variables

# INPUTS:
#     original:    the original dataset
#     synthetic:   the synthetic dataset
#     var1, var2:  index of the variables (e.g. for column 1, use 1, column 2 use 2)
# OUTPUTS:
#     results:     the ratio of estimates/counts for the particular variables



roc_bivariate <- function(original, synthetic, var1, var2){
  # create frequency tables for the original and synthetic data, on the two variable cross-tabulation
  orig_table <- as.data.frame(ftable(original[,var1], original[,var2]))   
  syn_table <- as.data.frame(ftable(synthetic[,var1], synthetic[,var2]))
  # calculate the proportions by dividing by the number of records in each dataset
  orig_table$prop <- orig_table$Freq/nrow(original)                       
  syn_table$prop <- syn_table$Freq/nrow(synthetic)
  # merge the two tables, by the variables
  combined <- merge(orig_table, syn_table, by= c('Var1', 'Var2'), all=TRUE)
  # merging will induce NAs where there is a category mismatch - i.e. the category exists in one dataset but not the other
  # to deal with this set the NA values to zero:
  combined[is.na(combined)] <- 0
  # get the maximum proportion for each category level:
  combined$max<- pmax(combined$prop.x, combined$prop.y)
  # get the minimum proportion for each category level:
  combined$min <- pmin(combined$prop.x, combined$prop.y)
  # roc is min divided by max (a zero value for min results in a zero for ROC, as expected)
  combined$roc <- combined$min/combined$max 
  #combined$roc[is.na(combined$roc)]<-1
  return(mean(combined$roc))
}



################################################################################################################################
################################################################################################################################


########################################################## Example of usage

### NOTE missing values were coded as 'B', creating a separate category (the appropriateness of this depends upon the data)

# original:   is the original dataframe
# synthetic:  is the synthetic dataframe

# get the ROC univarite for column 1
roc_univ <- roc_univariate(original, synthetic, 1)

# get the ROC bivariate for cross-tabulation of columns 1 and 2
roc_biv <- roc_bivariate(original, synthetic, 1, 2)



