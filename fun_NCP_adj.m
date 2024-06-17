function [data_adj,c_adj] = fun_NCP_adj(data_in,lin_range,ful_range)
% The function is used to adjust NCP and colormap axis for
% the self-designed colormap below:
%
%  cmin                                                  cmax
%   -------------------------------------------------------
%   |  blue (80) |        rainbow(160)         |  red(80) |
%   -------------------------------------------------------
%                |                             |         
%               \|/                           \|/
%              Lmin                           Lmax
% where
%   (X): the number of colors in the color band.
%  Lmin: the starting data value for a linear display in rainbow color
%  Lmax: the   ending data value for a linear display in rainbow color
%
% Input:
%    data_in: original data to be adjusted for plotting purpose
%  lin_range: user-defined linear data display range [Lmin, Lmax]
%  ful_range: user-defined   full data display range [Fmin, Fmax]
% 
% output:
% data_adj: adjusted data for a display using a nonlinear colorbar
%    c_adj: adjusted data range [cmin,cmax] for the display of data_adj

%################
%## parameters ##
%################
Lmin = lin_range(1); Fmin = ful_range(1);
Lmax = lin_range(2); Fmax = ful_range(2);
cff = (Lmax-Lmin)*0.5;

%##########################
%## adjust cmin and cmax ##
%##########################
% 0.5 is a pre-defined factor based on the user defined NCP cmap
cmin = Lmin - cff;  % blue band is half length of rainbow
cmax = Lmax + cff;  %  red band is half length of rainbow
c_adj = [cmin cmax];

%#################
%## rescale NCP ##
%#################
data_adj = data_in;
id = find(data_in>Lmax); data_adj(id) = Lmax + log(data_in(id)/Lmax)./log(Fmax/Lmax)*cff;
id = find(data_in<Lmin); data_adj(id) = Lmin - log(data_in(id)/Lmin)./log(Fmin/Lmin)*cff;
return;