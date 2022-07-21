################################################################################################################################
##
## Author: Claire Little https://github.com/clairelittle/psd2022-comparing-utility-risk
## Date: April 2022
## r version: 4.1.3
## RStudio version: 2021.09.0+351 "Ghost Orchid" Release (077589bcad3467ae79f318afe8641a1899a51606, 2021-09-20) for Windows
##
## Code to calculate the confidence interval overlap (CIO) for the sample/synthetic data compared to original data
##
## ***** NOTE: This code is simple and without error checking - use at own risk - check it is doing what you think it should!
##
################################################################################################################################

library(tidyverse) 

####################################################### Confidence interval overlap
#
# This used code from the 'Bowen-regression_utility.R' file, available here (on 20/09/21):
# https://github.com/ClaireMcKayBowen/Code-for-NIST-PSCR-Differential-Privacy-Synthetic-Data-Challenge/tree/master/rcode
# and used in the paper: "Comparative Study of Differentially Private Synthetic Data Algorithms from the NIST PSCR Differential
# Privacy Synthetic Data Challenge" by Bowen and Snoke
#
# But I have changed the code to accommodate the case where the synthetic data did not contain some of the categories that were 
# in the original data (so there would be no coefficient). In this case, it is set to zero - that means the overlap is zero. 
# (The original code set it as NA and resulted in the whole calculation returning NA for this scenario)
# Also, extra output is added to cover the case where the overlap is negative - this means there is no overlap - and the 
# overlap is therefore set to zero. This affects the mean/median calculations as negatives values drag it down.
# The output contains both options - leaving negative values, or setting them to zero
#
## requires tidyverse



################################################################################################################################
# Confindence interval overlap function
################################################################################################################################

# INPUTS:
#     orig_glm: output from a fitted glm object for original data
#     syn_glm:  output from fitted glm object for the synthetic data
# OUTPUTS:
#     results:  confidence interval overlap for all regression coefficients and mean/median standardized coefficient difference
#               And mean and median confidence interval overlap where negative overlap is set to zero


CIO_function = function(orig_glm, syn_glm){
  
  # put them into a form so it is easier to extract the coefficients etc.
  syn_glm <- list(as.data.frame(summary(syn_glm)$coef))
  orig_glm <- as.data.frame(summary(orig_glm)$coef)
  
  orig_tibble = as_tibble(orig_glm) %>% mutate('names' = rownames(orig_glm))
  syn_tibble = as_tibble(syn_glm[[1]]) %>%  mutate('names' = rownames(syn_glm[[1]]))
  
  # join the original and synth
  combined = left_join(select(orig_tibble, names, Estimate, `Std. Error`), 
                       syn_tibble, by = 'names', suffix = c('_orig', '_syn'))
  
  # now compute std. diff and ci overlap
  results = combined %>% 
    mutate('std.coef_diff' = abs(Estimate_orig - Estimate_syn) / `Std. Error_orig`,
           'orig_lower' = Estimate_orig - 1.96 * `Std. Error_orig`, 
           'orig_upper' = Estimate_orig + 1.96 * `Std. Error_orig`,
           'syn_lower' = Estimate_syn - 1.96 * `Std. Error_syn`, 
           'syn_upper' = Estimate_syn + 1.96 * `Std. Error_syn`) %>%
    mutate('ci_overlap' = 0.5 * (((pmin(orig_upper, syn_upper) - pmax(orig_lower, syn_lower)) / (orig_upper - orig_lower)) + 
                                   ((pmin(orig_upper, syn_upper) - pmax(orig_lower, syn_lower)) / (syn_upper - syn_lower)))) %>%
    select(names, 'std.coef_diff', 'ci_overlap') %>% 
    filter(names != '(Intercept)') %>%
    replace_na(list('std.coef_diff' = 0,'ci_overlap' = 0)) %>% # replace NA with zero
    # set negative overlaps to zero
    mutate('ci_overlap_noNeg' = ifelse(ci_overlap <0, 0, ci_overlap)) %>%
    
    # return the mean/median overall coefficients for each measure
    summarize('mean_std_coef_diff' = mean(std.coef_diff, na.rm=TRUE), 
              'median_std_coef_diff' = median(std.coef_diff, na.rm=TRUE),
              'mean_ci_overlap' = mean(ci_overlap, na.rm=TRUE), 
              'median_ci_overlap' = median(ci_overlap, na.rm=TRUE),
              # add in the overlaps where negatives were changed to zeros
              'mean_ci_overlap_noNeg' = mean(ci_overlap_noNeg, na.rm=TRUE), 
              'median_ci_overlap_noNeg' = median(ci_overlap_noNeg, na.rm=TRUE))
  
  return(results)
}


################################################################################################################################
################################################################################################################################


########################################################## Example of usage

### For each Census dataset regression models were created predicting the targets:
### marital status: individual is married (or living as married), or not
### tenure: individual owns (outright or mortgage) the home, or not

### NOTE missing values were coded as 'B', creating a separate category (the appropriateness of this depends upon the data)

### create binary version of attribute to be predicted, for the synthetic and original data
original$TENURE_bin <- ifelse(original$TENURE <= 2, 0, 1)                       # own outright/mortgage house, or not
synthetic$TENURE_bin <- ifelse(synthetic$TENURE <= 2, 0, 1)                     # own outright/mortgage house, or not


### set.seed(1234) # Probably advisable to set a random seed

### Perform logistic regression on the original data
TENURE_original_glm <- glm(TENURE_bin~AGE+ECONPRIM+ETHGROUP+LTILL+MSTATUS+QUALNUM+SEX+SOCLASS,
                           data = original, family = binomial(link = 'logit'))

### Perform logistic regression on the synthetic data
TENURE_synth_glm <- glm(TENURE_bin~AGE+ECONPRIM+ETHGROUP+LTILL+MSTATUS+QUALNUM+SEX+SOCLASS,
                        data = synthetic, family = binomial(link = 'logit'))

### then calculate the CIO
TENURE_CIO <- CIO_function(TENURE_original_glm, TENURE_synth_glm)
### From this extract whatever information is needed

