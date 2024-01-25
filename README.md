# Distributed Sensing Along Fibres

This repository contains data and scripts necessary to reproduce the figures from the paper:

> [1] Brett C. Hannigan, Tyler J. Cuthbert, Chakaveh Ahmadizadeh, and Carlo Menon. Distributed Sensing Along Fibres for Smart Clothing. *Science Advances*. 2023 (In Review).

The repository is dividied into three parts, one for the machine learning models, one for figure generation, and one for the system identifiability analysis:

`/ML`: Python Jupyter notebooks for machine learning training and evaluation, in two parts:

`/ML/StrainReconstruction`: For Section 2 *Localized Strain Reconstruction* of [1], and

`/ML/JointAngles`: For Section 2 *Joint Angle Monitoring* of [1].

`/Figures`: R Jupyter notebooks for producing Figures 2, 4, 6, 7, and S9 of [1].

`/Identifiability/RC3Identifiability.mw`: Maple worksheet for the 3-segment identifiability analysis described as 1. in Section S3 the Supplementary Materials.

`/Identifiability/RC4Identifiability.mw`: Maple worksheet for the 3-segment identifiability analysis described as 2. in Section S3 the Supplementary Materials.

The files, especially the names of intermediate output files, are still fairly unorganized, but it has been tested that all the figures may be reproduced.

## Examples

<p float="left">
  <img src="/Figures/2/Fig2.png" height="100" />
  <img src="/Figures/4/Fig4.png" height="100" /> 
  <img src="/Figures/6/Fig6.png" height="100" />
  <img src="/Figures/7/Fig7.png" height="100" />
</p>

## Requirements:

### Python Notebooks

Python (version 3.8.10 used) with the followig libraries:

- `h5py==3.7.0`
- `ipykernel==6.15.0`
- `ipython==8.4.0`
- `ipython-genutils==0.2.0`
- `jupyter==1.0.0`
- `jupyter-client==7.3.4`
- `jupyter-console==6.4.4`
- `jupyter-core==4.10.0`
- `jupyterlab-pygments==0.2.2`
- `jupyterlab-widgets==1.1.1`
- `keras==2.9.0`
- `Keras-Preprocessing==1.1.2`
- `Markdown==3.3.7`
- `matplotlib==3.5.2`
- `matplotlib-inline==0.1.3`
- `notebook==6.4.12`
- `numpy==1.23.0`
- `pandas==1.4.3`
- `scikit-learn==1.1.1`
- `scipy==1.8.1`
- `tensorboard==2.9.1`
- `tensorboard-data-server==0.6.1`
- `tensorboard-plugin-wit==1.8.1`
- `tensorflow==2.9.1`
- `tensorflow-estimator==2.9.0`
- `tensorflow-io-gcs-filesystem==0.26.0`

### R Notebooks

R (version 4.3.1 used) with the following packages:
- `broom`
- `cowplot`
- `dplyr`
- `ggh4x`
- `ggplot2`
- `magick`
- `patchwork`
- `pdftools`
- `readxl`
- `rsvg`
- `scales`
- `tidyverse`
- `tidyr`

### Maple Worksheets

Maple (version 2021 used) with the following package:
- `SIAN` [version 1.6](https://github.com/pogudingleb/SIAN)

## Known Issues

- The raw motion capture data from `/ML/JointAngles/MotionCapture` is empty, so that the `0_Preprocessing.ipynb` script may not function. However, pre-compiled data is available in the `*_data.csv` files.

©2023 ETH Zurich, Brett Hannigan; D-HEST; Biomedical and Mobile Health Technology (BMHT) Lab; Carlo Menon