% Parameter information for 
%    "The Responses of Net Community Production to
%     Sea ice Reduction in the Western Arctic Ocean" 
% by Zhou et al.
%
% Reference:
%   Zhou et al. ...
%
%         Author: Yun Li, UDel, Apr-24-2024

%################################################
%##                                            ##
%##  To run the program, especially Fig1_xx.m, ##
%##  you must install m_map on your machine.   ##
%##  Below is an example on how to add m_map   ##
%##  toolbox into your MATLAB path.            ##
%##    ____                                    ##
%##   /    \    More information regarding     ##
%##  | NOTE |   the m_map toolbox:             ##
%##   \____/    www.eoas.ubc.ca/~rich/map.html ##
%##                                            ##
%################################################
%addpath(genpath('/home/yunli/toolbox_yun/m_map_zhou/'))

%###########################
%##  Geographic boundary  ##
%###########################
lat_str = 65; lon_str = 179.9;             % lower bound of lat and lon
lat_end = 78; lon_end = 360-140.1;         % upper bound of lat and lon

%########################
%##  Time range & info ##
%########################
obs_mm = 5:11;                             % available months of obs
obs_str = datenum(0,5,25)-1;               % start date of study period
obs_end = datenum(0,9, 5)+1;               %   end data of study period
af15 = 2015:2021; Naf15 = length(af15);    % years 2015-2021 for baseline run (after 2015)
bf15 = 2003:2014; Nbf15 = length(bf15);    % years 2003-2014 for sensitivity run (before 2015)
ally = 2003:2021; Nally = length(ally);    % all years 2003-2021
af15_yy = datestr(datenum(af15,1,1),'yy'); % two-digit year marks for baseline run
ally_yy = datestr(datenum(ally,1,1),'yy'); % two-digit year marks for all runs

%################
%## File info  ##
%################
fobs = './data/compiled_obs_and_ML_eval.mat';     % observation and ML results
fmap = './data/grid_and_mapped_products.mat';     % model grid and output
fcmap_NCP = './data/cmap_NCP.mat';                % colormap for NCP

%################
%##  colorbar  ##
%################
NCP_ticks = [-24 -8 -3 1 5:5:20 60 160]';  % NCP ticks, stretching at low(high) values
NCP_linrg = [-3 20];                       % NCP range set for linear display
clscolor = lines(5); 
clscolor = clscolor([5 4 3 1],:);          % colors for clusters 1 to 4 = (g,p,o,b)
ldpatch = [1 1 1]*0.6;                     % land patch color
ctscolor= [0.85 0.325 0.098];              % red color used for open water and testing data

%#############################
%## conversion coefficients ##
%#############################
cff_mgC2mmolC  = 1/12;                     % mg C -> mmol C
% integrate NCP at each grid point over May-Sep
%   intNCP = NCPx(36 km2)x(8 days)x(13 bins)
cff_NCP2intNCP = 12e-3*1e-12*36e6*8*13;    % mmol C/m2/d -> Tg C

%######################
%##  Subplot labels  ##
%######################
plabels = {'(a)', '(b)', '(c)', '(d)', ...
           '(e)', '(f)', '(g)', '(h)', ...
           '(i)', '(j)', '(k)', '(l)', ...
           '(m)', '(n)', '(o)', '(p)'};
