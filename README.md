Golm Metabolome Database search spectrum for Galaxy
===================================================

[![bioconda-badge](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat-square)](http://bioconda.github.io) [![Build Status](https://travis-ci.org/workflow4metabolomics/tool-bank-golm-lib_search.svg?branch=master)](https://travis-ci.org/workflow4metabolomics/tool-bank-golm-lib_search)

Our project
-----------
The [Workflow4Metabolomics](http://workflow4metabolomics.org), W4M in short, is a French infrastructure offering software tool processing, analyzing and annotating metabolomics data. It is based on the Galaxy platform.


Golm Metabolome Database search spectrum
----------------------------------------

Tool using the Golm Library Search WS.


Galaxy
------
Galaxy is an open, web-based platform for data intensive biomedical research. Whether on the free public server or your own instance, you can perform, reproduce, and share complete analyses. 

Homepage: [https://galaxyproject.org/](https://galaxyproject.org/)


Dependencies using Conda
------------------------
[![bioconda-badge](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat-square)](http://bioconda.github.io)


[Conda](http://conda.pydata.org/) is package manager that among many other things can be used to manage Python packages.

```
#To install miniconda2
#http://conda.pydata.org/miniconda.html
#To install the tool dependencies using conda:
conda install perl-soap-lite perl-list-moreutils perl-json perl-html-template
#To set an environment:
conda create -n tool-bank-golm-lib_search perl-soap-lite perl-list-moreutils perl-json perl-html-template`
#To activate the environment:
. activate tool-bank-golm-lib_search
```


Travis
------
[![Build Status](https://travis-ci.org/workflow4metabolomics/tool-bank-golm-lib_search.svg?branch=master)](https://travis-ci.org/workflow4metabolomics/tool-bank-golm-lib_search)

Test and Deploy with Confidence. Easily sync your GitHub projects with Travis CI and you'll be testing your code in minutes!

Historic contributors
---------------------
 - Yann Guitton @yguitton - [LABERCA - Laboratory of Food Contaminants and Residue Analysis](http://www.laberca.org/) - Ecole Nationale Vétérinaire, Agroalimentaire et de l'Alimentation Nantes-Atlantique - France
 - Gabriel Cretin - [French Metabolomics and Fluxomics Infrastructure (MetaboHUB)](http://www.metabohub.fr/en) - [La plateforme "Exploration du Métabolisme" (PFEM, Clermont-Ferrand)](http://www6.clermont.inra.fr/plateforme_exploration_metabolisme)
 - Franck Giacomoni @fgiacomoni - [French Metabolomics and Fluxomics Infrastructure (MetaboHUB)](http://www.metabohub.fr/en) - [La plateforme "Exploration du Métabolisme" (PFEM, Clermont-Ferrand)](http://www6.clermont.inra.fr/plateforme_exploration_metabolisme)
