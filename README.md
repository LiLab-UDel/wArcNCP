# wArcNCP
This repository contains the code and data used to produce Figures 1 to 4 in _"Enhanced Net Community Production with Sea Ice Loss in the Western Arctic Ocean
Uncovered by Machine-learning-based Mapping"_ by T. Zhou (UDel), Y. Li (UDel), Z. Ouyang (UDel), W.-J. Cai (UDel), and R. Ji (WHOI)

__Contact information:__ The [Computational Oceanography Lab](https://sites.udel.edu/yunli/) led by Dr. Yun Li (yunli@udel.edu) at University of Delaware

## 1. Main Code
> [!NOTE]
> To run the program, you must install [m_map](https://www.eoas.ubc.ca/~rich/map.html) on your machine.
> After the installation, below is an example on how to add the m_map toolbox into your MATLAB path.
> ```
> addpath(genpath('/home/m_map/'))
> ```
__The four scripts below (fig*.m) are used to generate Figures 1 to 4 in the paper, respectively__
* __fig1_O2Ar_hist_map_yearly.m__
  
  __Figure 1:__ (a-c) _In situ_ data availability; (d-e) Machine learning model performance evaluation
  
* __fig2_NCP_yr_map.m__
  
  __Figure 2:__ (a-g) Maps of May-to-September mean Net Community Production (_NCP_, unit: mmol C m<sup>-2</sup> day<sup>-1</sup>) from 2015 to 2021;
  (h) Four subregions detected by the K-means clustering method
  
* __fig3_NCP_subdivision.m__

  __Figure 3:__ (a-d) Time series of regional export production (_<sub>int</sub>NCP_, unit: Tg C), biological production (_<sub>int</sub>NPP_, unit: Tg C),
  and open water area (unit: 10<sup>4</sup> km<sup>2</sup>); (e-h) Time series of regional e-ratio (unitless)
  
* __fig4_e_ratio.m__
  
  __Figure 4:__ (a) Diagram of e-ratio against _<sub>int</sub>NPP_; (b-c) Time series of integrated spatial area (unit: 10<sup>4</sup> km<sup>2</sup>) above
  local _<sub>int</sub>NCP_ or e-ratio thresholds
  
## 2. Functions and Subroutines
* __add_taylordiag.m__
  
  Subroutine used in __fig1_O2Ar_hist_map_yearly.m__ to create a self-designed partial Taylor diagram
  
* __fun_NCP_adj.m__
  
  Function used in __fig1_O2Ar_hist_map_yearly.m__ and __fig2_NCP_yr_map.m__ to adjust _NCP_ values to a
  self-designed color scale and then mapped by the RGB data in __cmap_NCP.mat__
  
* __info_params.m__
  
  Information used by all the main code __fig*.m__ to specify parameters used for creating figures
  
* __SStats.m__
  
  Subroutine used in __fig1_O2Ar_hist_map_yearly.m__ to calculate the statistics reported in the Taylor diagram
  
## 3. Data
__All the data used for figure generation can be found in the _"./Data"_ folder__
* __cmap_NCP.mat__
  
  The RGB data used in __fig1_O2Ar_hist_map_yearly.m__ and __fig2_NCP_yr_map.m__ to create a self-designed _NCP_ colormap
  
* __compiled_obs_and_ML_eval.mat__
  
  The data used in __fig1_O2Ar_hist_map_yearly.m__, including (1) table of observations and model output,
  (2) sea ice cover seasonal climatology, and (3) machine learning model performance.
  More details can be found in the readmes in the data
  
* __grid_and_mapped_products.mat__

  The data used in all the main code __fig*.m__, including (1) the longitudes, latitudes, and land/water mask of the 6-km grid used in this study,
  (2) K-means cluster labels, (3) years of model annual output (2003-2021), and (4) May-to-September mean Net Community Production
  (_NCP_, unit: mmol C m<sup>-2</sup> day<sup>-1</sup>), Net Primary Production (_NPP_, unit: mmol C m<sup>-2</sup> day<sup>-1</sup>),
  and Open Water Area (_owa_, unit: m<sup>2</sup>). More details can be found in the readmes in the data
  
## Acknowledgment
This work is supported by the NASA FINESST Program (80NSSC24K0011). We also acknowledge the support by the NASA Carbon Cycle Science Program (80NSSC22K0151)
and NSF (OPP-1926158)
