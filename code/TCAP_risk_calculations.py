'''
Author: Claire Little https://github.com/clairelittle/psd2022-comparing-utility-risk
Date: April 2022
python version 3.8.8, pandas 1.3.1

This file calculates the TCAP (Targeted Correct Attribution Probability) score which is used for the disclosure risk  

There are two functions: 

    replace_missing() takes the dataset (in the form of a pandas dataframe) and replaces any missing/NA values. It is called from the tcap() function

    tcap() takes the original and synthetic dataset and calculates the TCAP score. This is a simplified version of the code and does not contain the tau or eqmax parameters (as they were not needed for these experiments)


NOTE: the code was written quickly for convenience and is not concise. It does not contain error checking, so use at own risk and make sure the results make sense!
'''

import pandas as pd


'''
function:     replace_missing()   
description:  replaces missing values dependant on data type. Categorical or object NAs are replaced with 'blank', numerical NAs with -999. Can be modified as required
input:        pandas dataframe
output:       pandas dataframe with missing values replaced
'''
def replace_missing(dataset):
    # get a dictionary of the different data types
    types = dataset.dtypes.to_dict()
    # replace object or categorical NAs with 'blank', and numerical with -999
    for col_nam, typ in types.items():
        if (typ == 'O' or typ == 'c'):
            dataset[col_nam] = dataset[col_nam].fillna('blank')
        if (typ == 'float64' or typ == 'int64'):
            dataset[col_nam] = dataset[col_nam].fillna(-999)
    return(dataset)



'''
function:     tcap()   
description:  takes the original and synthetic dataset filenames and a set of keys/target variables and calculates the TCAP score
input:        original = location/filename of original dataset
              synth = location/filename of synthetic dataset
              num_keys = number of key variables
              target = target variable
              key1 = first key variable
              key2 = second key variable
              key3 = third key variable
              key4, key5, key6 = fourth, fifth, sixth key variables, if required (default to None)
              verbose = if set to True it will print out more detailed results
output:       TCAP score and the baseline value for that target variable
'''
def tcap(original, synth, num_keys, target, key1, key2, key3, key4=None, key5=None, key6=None, verbose=False):
       
    # read in the data
    orig = pd.read_csv(original)
    syn = pd.read_csv(synth)

    # define the keys and target. using the num_keys parameter means that a dataset with any number of columns can
    # be used, and only the relevant keys analysed
    if num_keys==6:
        keys_target = [key1,key2,key3,key4,key5,key6,target]
    if num_keys==5:
        keys_target = [key1,key2,key3,key4,key5,target]
    if num_keys==4:
        keys_target = [key1,key2,key3,key4,target] 
    if num_keys==3:
        keys_target = [key1,key2,key3,target]
    
    # select just the required columns (keys and target)    
    orig = orig[keys_target]
    syn = syn[keys_target]
    # replace any missing values
    orig = replace_missing(orig)
    syn = replace_missing(syn)
    # count the categories for the target (for calculating baseline)
    uvd = orig[target].value_counts()
    
    # use groupby to get the equivalance classes for synthetic data
    eqkt_syn = pd.DataFrame({'count' : syn.groupby( keys_target ).size()}).reset_index()           # with target
    eqk_syn = pd.DataFrame({'count' : syn.groupby( keys_target[:num_keys] ).size()}).reset_index() # without target
    # equivalance classes for original data without target
    eqk_orig = pd.DataFrame({'count' : orig.groupby( keys_target[:num_keys] ).size()}).reset_index()

    # merge with original to calculate baseline    
    orig_merge_eqk = pd.merge(orig, eqk_orig, on= keys_target[:num_keys]) 
    orig_merge_eqk.rename({'count': 'count_eqk_orig'}, axis=1, inplace=True)
    # calculate the baseline
    uvt = sum(uvd[orig_merge_eqk[target]]/sum(uvd))
    baseline = uvt/len(orig)
    
    # calculate synthetic cap score. merge syn eq classes (with keys) with syn eq classes (with keys/target)
    syn_merge = eqk_syn.merge(eqkt_syn, on=keys_target[:num_keys])
    syn_merge['prop'] = syn_merge['count_y']/syn_merge['count_x']
    # filter out those less than tau=1
    syn_merge = syn_merge[syn_merge['prop'] >= 1]
    # merge with original, if in syn eq classes (just keys) then this is a matching record (Taub)
    syn_merge = syn_merge.merge(orig_merge_eqk, on=keys_target[:num_keys], how='inner')
    matching_records = len(syn_merge)

    # drop records where the targets are not equal
    syn_merge = syn_merge[syn_merge[target + '_x']==syn_merge[target + '_y']]
    dcaptotal = len(syn_merge)

    if matching_records == 0:
        tcap_undef = 0
    else:
        tcap_undef = dcaptotal/matching_records
   
    # output is [the TCAP as used by Taub, and the baseline]. Modify as required
    output = ([tcap_undef,baseline])
    
    if verbose==True:
        print('TCAP calculation')
        print('===============')
        print('Source dataset is: ',original)
        print('Target dataset is: ',synth)
        print('The total number of records in the source dataset is: ', len(orig))
        print('The total number of records in the target dataset is: ', len(syn))
        print('The target variable is: ', target)
        print('The key size is: ', num_keys)
        print('The keys are: ', key1, key2, key3, key4, key5, key6)
        print('Number of matching records: ', matching_records)
        print('DCAP total is: ', dcaptotal)
        print('TCAP with non-matches undefined is: ', tcap_undef)
        print('The baseline is: ', baseline)

    return(output)