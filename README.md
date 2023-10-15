# *pan.corpus.generator*: An R package to import PAN-AV data into R and convert it into a corpus object.

----------DEVELOPMENT VERSION OF THIS PACKAGE----------

This package will be used to import the data from the PAN-AV datasets into R and to turn them into corpus objects suitable for author verification tasks.

## Installation

To install the latest development version directly from the GitHub repository, you can use:

```R
devtools::install_github("https://github.com/BenJCross1995/pan.corpus.generator")
```

## Acquiring Datasets

A pre-requisite of this package is the aquisition of the PAN-AV datasets from the PAN website [here](https://pan.webis.de/clef22/pan22-web/index.html).

## Directory Structure

The main issue with combining these datasets will be concerning the very different file structures year on year, for example;

### 2015

```bash
├── pan15-authorship-verification-test-and-training.zip
│   ├── pan15-authorship-verification-test-dataset2-2015-04-19.zip
│   │   ├── pan15-authorship-verification-test-dataset2-english-2015-04-19.zip
│   │   ├── pan15-authorship-verification-test-dataset2-dutch-2015-04-19.zip
│   │   ├── pan15-authorship-verification-test-dataset2-greek-2015-04-19.zip
│   │   ├── pan15-authorship-verification-test-dataset2-spanish-2015-04-19.zip
│   │   │   ├── contents.json
│   │   │   ├── truth.txt
│   │   │   ├── SP100
│   │   │   │   ├── unknown.txt
│   │   │   │   ├── known01.txt
│   │   │   │   ├── known02.txt
│   │   │   │   ├── known03.txt
│   │   │   │   ├── known04.txt
│   ├── pan15-authorship-verification-training-dataset-2015-04-19.zip
│   │   ├── pan15-authorship-verification-training-dataset2-english-2015-04-19.zip
│   │   ├── pan15-authorship-verification-training-dataset2-dutch-2015-04-19.zip
│   │   ├── pan15-authorship-verification-training-dataset2-greek-2015-04-19.zip
│   │   ├── pan15-authorship-verification-training-dataset2-spanish-2015-04-19.zip
│   │   │   ├── contents.json
│   │   │   ├── truth.txt
│   │   │   ├── SP100
│   │   │   │   ├── unknown.txt
│   │   │   │   ├── known01.txt
│   │   │   │   ├── known02.txt
│   │   │   │   ├── known03.txt
│   │   │   │   ├── known04.txt
```

### 2020

```bash
├── pan20-authorship-verification-training-small.zip
│   ├── pan20-authorship-verification-training-small.jsonl
│   └── pan20-authorship-verification-training-small-truth.jsonl
```
