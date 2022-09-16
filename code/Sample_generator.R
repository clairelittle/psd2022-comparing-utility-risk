################################################################################################################################
## 
## Author: Claire Little https://github.com/clairelittle/psd2022-comparing-utility-risk
## Date: April 2022
## r version: 4.1.3
## RStudio version: 2021.09.0+351 "Ghost Orchid" Release (077589bcad3467ae79f318afe8641a1899a51606, 2021-09-20) for Windows
##
## This file generates the samples, of varying sizes, of the original data
##
################################################################################################################################


################################################################################################################################
########################### Sample generator function
################################################################################################################################

# INPUTS:
#     original:      the original dataset
#     sample_size:   the sample sizes to generate
#     random_seed:   set the random seed so that results can be reproduced (and varied)
#     num_datasets:  the number of datasets to generate for each sample size
# OUTPUTS:
#     sample datasets labelled by sample size, and numbered. They will be saved to whichever is the working directory 


sample_generator = function(original, sample_size, random_seed=123, num_datasets=1){
  for (j in 1:length(sample_size)){
    set.seed(j + random_seed)                                                 # set a different random seed for each sample size
    num_records <- nrow(original)*sample_size[j]                              # set the number of records to generate
    for (i in 1:num_datasets) { 
      samp <- original[sample(nrow(original), num_records, replace=FALSE), ]  # select the samples without replacement
      filename <- paste0('UK_1991_',sample_size[j],'_sample_',i,'.csv')       # create a numbered filename
      write.csv(samp,filename,row.names = FALSE)                              # save file (make sure correct directory)
    }
  }
}


################################################################################################################################
################################################################################################################################

########################################################## Example of usage

##### set working directory to where the data should be saved
setwd("C:/folder/another_folder/UK1991_samples")

##### set desired sample sizes
## 0.1%, 0.25%, 0.5%, 1%, 2%, 3%, 4%, 5%, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 95%, 96%, 97%, 98%, 99%
sample_sizes=c(0.001,0.0025,0.005,0.01,0.02,0.03,0.04,0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,0.96,0.97,0.98,0.99)


##### this will generate 100 datasets for each sample size:
sample_generator(original_data, sample_sizes, random_seed=1234, num_datasets=100)



