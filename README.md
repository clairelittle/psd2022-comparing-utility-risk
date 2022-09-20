# Code and data for Comparing the Utility and Disclosure Risk of Synthetic Data with Samples of Microdata

This repository contains information about the data and code used for the paper (which is available [here](https://link.springer.com/chapter/10.1007/978-3-031-13945-1_17))

## Data
Four Census datasets were used. The Canada, Fiji and Rwanda datasets were obtained from [IPUMS-international](https://international.ipums.org/international/) and the UK dataset was obtained from the UK Data Service, study number [7210](https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=7210). Details of the datasets and the variables used for each follow:

### Canada 2011 Census data
URBAN, CA2011A_TENURE, OCCISCO, CA2011A_SEX, CA2011A_AGE, CA2011A_RELATE, CA2011A_IND, CA2011A_INCTOT, CA2011A_DEGREE, CA2011A_YRIMM, CA2011A_LANG, CA2011A_BPL, CA2011A_MINORITY, CA2011A_ABIDENT, CA2011A_MARST, CA2011A_CLASSWK, CA2011A_RELIG, CA2011A_CITIZEN, CA2011A_TRANWORK, CA2011A_WKFULL, CA2011A_HRSWK, CA2011A_EMPSTAT, CA2011A_WKSWORK, CA2011A_BPLPOP, CA2011A_BPLMOM

The GEO1_CA2011 (province) variable was used to subset the data on the (randomly selected) province of Manitoba (46). The GEO1_CA2011 variable was not included in analysis as subsetting on it meant it was then a constant.

The dataset consisted of 32149 records and 25 variables.

### Fiji 2007 Census data
FJ2007A_PROV, FJ2007A_TENURE, FJ2007A_RELATE, FJ2007A_SEX, FJ2007A_AGE, FJ2007A_ETHNIC, FJ2007A_MARST, FJ2007A_RELIGION, FJ2007A_BPLPROV, FJ2007A_RESPROV, FJ2007A_RESSTAT, FJ2007A_SCHOOL, FJ2007A_EDATTAIN, FJ2007A_TRAVEL, FJ2007A_WORKTYPE, FJ2007A_OCC1, FJ2007A_IND2, FJ2007A_CLASSWKR, FJ2007A_MIG5YR

The whole sample was used and the dataset consisted of 84323 records and 19 variables.

### Rwanda 2012 Census data
RW2012A_URBAN, RW2012A_OWNERSH, RW2012A_RELATE, RW2012A_SEX, RW2012A_AGE, RW2012A_STATUS, RW2012A_BPL, RW2012A_NATION, RW2012A_RELIG, RW2012A_DISAB1, RW2012A_DISAB2, RW2012A_HINS, RW2012A_REGBTH, RW2012A_LIT, RW2012A_EDCERT, RW2012A_CLASSWK, RW2012A_WKSECTOR, RW2012A_MARST, RW2012A_NSPOUSE, RW2012A_OCC, RW2012A_IND1

The GEO2_RW2012 (district) variable was used to subset the data on the (randomly selected) district of Karongi (3031). The GEO2_RW2012 variable was not included in analysis as subsetting on it meant it was then a constant.

The dataset consisted of 31455 records and 21 variables.

### UK (Great Britain) 1991 Census data
AREAP, AGE, COBIRTH, ECONPRIM, ETHGROUP, FAMTYPE, HOURS, LTILL, MSTATUS, QUALNUM, RELAT, SEX, SOCLASS, TRANWORK, TENURE

The REGIONP (region) variable was used to subset the data on the (randomly selected) region of West Midlands (9). The REGIONP variable was not included in analysis as subsetting on it meant it was then a constant.

The dataset consisted of 104267 records and 15 variables.

### Census Data Samples
For each of the four Census datasets random samples, without replacement, of increasing sizes were drawn (0.1%, 0.25%, 0.5%, 1%, 2%, 3%, 4%, 5%, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 95%, 96%, 97%, 98%, 99%). For each of these sample fractions n=100 random samples were drawn, producing 100 datasets of that sample fraction size. For instance, for the UK dataset 100 datasets with 104 records (0.1% of the overall 104267 records) were created, 100 datasets with 260 records (0.25%) were created, and so on. 

The code used to generate the samples is in the [code](code) folder.

For the utility and risk metrics the samples were treated in the same way as the synthetic data; by comparing against the original (100%) dataset. For each metric the average across the 100 datasets was used, in order to guard against unusual results.

## Synthetic Data
The synthetic data was created using [synthpop](https://synthpop.org.uk/), [DataSynthesizer](https://github.com/DataResponsibly/DataSynthesizer) and [CTGAN](https://github.com/sdv-dev/CTGAN). Fully synthetic datasets the same size as the original were generated. For each method/parameter setting 5 models were created (using different random seeds) and 1 synthetic dataset generated from each. For the utility and risk metrics the average across the five datasets was used, in order to guard against unusual results.

### Synthpop
Using R version 4.1.3, and Synthpop version 1.7-0. Default parameters were used, and the visit sequence was set to numerical variables first (alphabetically) then categorical variables in order of number of categories (ascending, with a tie decided by alphabetical order). Visit sequences for each of the Census datasets:

- **Canada 2011**: CA2011A_AGE, CA2011A_HRSWK, CA2011A_INCTOT, CA2011A_WKSWORK, CA2011A_ABIDENT, CA2011A_SEX, CA2011A_TENURE, URBAN, CA2011A_WKFULL, CA2011A_BPLMOM, CA2011A_BPLPOP, CA2011A_CITIZEN, CA2011A_CLASSWK, CA2011A_EMPSTAT, CA2011A_LANG, CA2011A_MARST, CA2011A_TRANWORK, CA2011A_RELATE, CA2011A_DEGREE, OCCISCO, CA2011A_YRIMM, CA2011A_MINORITY, CA2011A_RELIG, CA2011A_IND, CA2011A_BPL
- **Fiji 2007**: FJ2007A_AGE, FJ2007A_RESSTAT, FJ2007A_SEX, FJ2007A_MIG5YR, FJ2007A_CLASSWKR, FJ2007A_SCHOOL, FJ2007A_MARST, FJ2007A_TENURE, FJ2007A_WORKTYPE, FJ2007A_OCC1, FJ2007A_PROV, FJ2007A_RELATE, FJ2007A_TRAVEL, FJ2007A_ETHNIC, FJ2007A_EDATTAIN, FJ2007A_RELIGION, FJ2007A_BPLPROV, FJ2007A_IND2, FJ2007A_RESPROV
- **Rwanda 2012**: RW2012A_AGE, RW2012A_STATUS, RW2012A_SEX, RW2012A_URBAN, RW2012A_REGBTH, RW2012A_WKSECTOR, RW2012A_MARST, RW2012A_NSPOUSE, RW2012A_CLASSWK, RW2012A_OWNERSH, RW2012A_DISAB2, RW2012A_DISAB1, RW2012A_EDCERT, RW2012A_RELATE, RW2012A_RELIG, RW2012A_OCC, RW2012A_HINS, RW2012A_NATION, RW2012A_LIT, RW2012A_IND1, RW2012A_BPL
- **UK 1991**: AGE, HOURS, LTILL, SEX, QUALNUM, MSTATUS, TENURE, RELAT, FAMTYPE, SOCLASS, ECONPRIM, ETHGROUP, TRANWORK, AREAP, COBIRTH

### DataSynthesizer
Using python version 3.8.3 and DataSynthesizer version 0.1.9, pandas version 1.1.4, numpy version 1.20.1. 
Default parameters were used, with network degree = 2. The differential privacy (epsilon, ϵ) parameter was varied using values of ϵ = 0 (dp = off), 0.1, 1, 10. 

### CTGAN
Using python version 3.8.3, ctgan version 0.4.3, sdv version 0.12.1, torch verion 1.7.1, pandas version 1.1.4, numpy version 1.20.3.
Default parameters were used, with the number of epochs set at 300.


## Code - Utility and Risk metrics

The code for this project was written using a mixture of R and python. The [code](code) folder contains code for the generation of the data samples, and the metrics used to analyse the data. That is, the utility metrics:
- Ratio of Counts (ROC) univariate
- Ratio of Counts (ROC) for bivariate cross-tabulations
- Confidence Interval Overlap (CIO)

and the disclosure risk metric:
- Targeted Correct Attribution Probability (TCAP)

The mean of the three utility values was used as the overall utility score, and the TCAP was used as the disclosure risk score. Further information specific to each dataset follows:

### Ratio of counts (ROC)

The ROC univariate was calculated for all variables in the dataset, and ROC bivariate for all combinations of two variables. For each dataset missing values were included as an extra category/value (i.e. not discarded).

**Note** to calculate the ROC (and only for this purpose) for the Canada 2011 Census data, the CA2011A_INCTOT variable was binned into ten categories of approximately similar size:

```[-Inf, 1200), [1200, 9000), [9000, 15100), [15100, 20800), [20800, 28100), [28100, 35400), [35400, 43800), [43800, 55600), [55600, 75400), [75400, Inf]```


### Confidence Interval Overlap (CIO)

For each dataset, two logistic regressions were performed, with housing tenure and marital status as the targets. A binary target was created (where it did not already exist). For marital status this was, married (or living together) and any other value. For tenure this was, owning their own home, and any other value. For a parsimonious model, eight predictors were used. Details for each dataset follow (note that in the list of predictors, tenure and marital status are not used as a predictor when they are also the target variable):

**Canada** 
- Targets: CA2011A_MARST, CA2011A_TENURE
- Predictors: CA2011A_AGE, CA2011A_ABIDENT, CA2011A_SEX, URBAN, CA2011A_CLASSWK, CA2011A_EMPSTAT, CA2011A_DEGREE, CA2011A_TENURE/CA2011A_MARST
	
**Fiji** 
- Targets: FJ2007A_MARST, FJ2007A_TENURE
- Predictors: FJ2007A_AGE, FJ2007A_SEX, FJ2007A_CLASSWKR, FJ2007A_PROV, FJ2007A_ETHNIC, FJ2007A_EDATTAIN, FJ2007A_RELIGION, FJ2007A_TENURE/FJ2007A_MARST

Note that the following variables were aggregated: FJ2007A_EDATTAIN (four categories: primary and below, secondary, post_secondary, other); FJ2007A_ETHNIC (three categories: Fijian, Indian, other); FJ2007A_RELIGION (six categories: Methodist, Catholic, Seventh Day Adventist, Assembly of God, Sanatan, None) 

**Rwanda** 
- Targets: RW2012A_MARST, RW2012A_OWNERSH
- Predictors: RW2012A_AGE, RW2012A_SEX, RW2012A_CLASSWK, RW2012A_DISAB1, RW2012A_EDCERT, RW2012A_RELIG, RW2012A_LIT, RW2012A_OWNERSH/RW2012A_MARST

Note that the following variables were aggregated: RW2012A_LIT (three categories: None, Kinyarwanda, Other, Unknown); RW2012A_DISAB1 (two categories: None, Yes) 

**UK** 
- Targets: MSTATUS, TENURE
- Predictors: AGE, ECONPRIM, ETHGROUP, LTILL, QUALNUM, SEX, SOCLASS, TENURE/MSTATUS


### Targeted Correct Attribution Probability (TCAP)

A summary of the key and target variables is listed below. For each dataset, there were three target variables, and the same set of keys were used for all three. Combinations of 3, 4, 5 and 6 keys were used. The six key variables are listed together; the first three were used in the case of 3 keys, the first four for 4 keys, etc.

**Canada** 
- Targets: CA2011A_RELIG, CA2011A_CITIZEN, CA2011A_TENURE
- Keys: CA2011A_AGE, CA2011A_SEX, CA2011A_MARST, CA2011A_MINORITY, CA2011A_EMPSTAT, CA2011A_BPL
	
**Fiji** 
- Targets: FJ2007A_RELIGION, FJ2007A_WORKTYPE, FJ2007A_TENURE
- Keys: FJ2007A_PROV, FJ2007A_AGE, FJ2007A_SEX, FJ2007A_MARST, FJ2007A_ETHNIC, FJ2007A_CLASSWKR

**Rwanda** 
- Targets: RW2012A_RELIG, RW2012A_WKSECTOR, RW2012A_OWNERSH
- Keys: RW2012A_AGE, RW2012A_SEX, RW2012A_MARST, RW2012A_CLASSWK, RW2012A_URBAN, RW2012A_BPL

**UK** 
- Targets: LTILL, FAMTYPE, TENURE
- Keys: AREAP, AGE, SEX, MSTATUS, ETHGROUP, ECONPRIM



