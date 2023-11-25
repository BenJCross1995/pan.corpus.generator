# *pan.corpus.generator*: An R package to import PAN-AV data into R and convert it into a corpus object.

----------DEVELOPMENT VERSION OF THIS PACKAGE----------

This package will be used to import the data from the PAN-AV datasets into R and to turn them into corpus objects suitable for author verification tasks.

This currently works for the 2020, 2021 datasets but not for the earlier 2013-15 datasets as they have a different file schema. However the 2020 (small) and 2021 files give over 150,000 documents for your corpus.

## Installation

To install the latest development version directly from the GitHub repository, you can use:

``` r
devtools::install_github("https://github.com/BenJCross1995/pan.corpus.generator")
```

## Acquiring Datasets

A pre-requisite of this package is the acquisition of the PAN-AV datasets from the PAN website [here](https://pan.webis.de/clef22/pan22-web/index.html). The folder names of the datasets must be in the original format as they were when downloaded. The optimal way to use the package is to have all folders you wish to load as a corpus within the same folder.

## Functions

There are two functions which are exported in this package.

### get_file_details 

This function returns a dataframe containing file information of all files contained in the folder. This is done by iteratively opening all folders and unzipping folders if required and gathering the file locations of every file within the file location.

The function uses text patterns to then gather file info. This is the reason why you must keep the folder names the same when downloaded.

### create_corpus 

This function takes the folder location and create a corpus from all files located within this location. The user has the option to include large files i.e. the 12GB, 2020 large file. The user also has the ability to decide whether they would like the dataset returned as a dataframe or a Quanteda corpus object.

## Planned Next Steps

The next steps planned for the package are as follows:

-   Include the 2013-15 dataset preparation.

-   Convert the code within the create_corpus function into some smaller functions.

-   Utilize parallel processing with the apply family of functions.

-   Look into the **arrow** package for dealing with the large dataset approx 12GB.
