% Create Figure S8 of
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of 
%   - 12 subpanels of 8-day NCP maps
%
%         Author: Tianyu Zhou, UDel, Oct/09/2024
%                      Yun Li, UDel, Oct/09/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
yids = [7 8 5];  % the id of selected years (high vs low SIC)
ystr = {'High SIC','Climatology','Low SIC'};
ffig = [ffig_dir 'figS8_NCP_8day_map'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx=0.24; fgw=0.15; fgdw=0.138;
fgy=0.60; fgh=0.15; fgdh=0.168;
fsize= 6;

%###################
%## 8-day NCP maps #
%###################
% load data
load(fmap); load(fcmap_NCP)
years = maps.years_8d; years = [num2str(years(:));'    ']; nyr = length(yids);
tdoy = maps.tdoy_8d; nb = length(tdoy);
NCP = maps.NCP_8d; NCP(NCP<-1E6) = NaN;
% calculate climatology
mask_SIC = 1.*isnan(NCP);
wrk = NCP; wrk(mask_SIC==1) = 0;
wrk = squeeze(mean(wrk,4));
wrk(sum(mask_SIC,4)>=5) = NaN;
NCP(:,:,:,8) = wrk;    % additional dim for NCP clm
% make plots
[NCP_adj,c_adj] = fun_NCP_adj(NCP      ,NCP_linrg,NCP_linrg*8);
[cticks ,~    ] = fun_NCP_adj(NCP_ticks,NCP_linrg,NCP_linrg*8);
for ky = 1:nyr; yid = yids(ky);
for kb = 1:nb
  NCP_wrk = squeeze(NCP_adj(:,:,kb,yid));
  SIC = ~isnan(NCP_wrk).*1; SIC(maps.mask==0)=NaN;
  axes('Position',[fgx+fgdw*(kb-1) fgy-fgdh*(ky-1) fgw fgh]); hold on
  m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end]);
  m_pcolor(maps.lon_ful,maps.lat_ful,NCP_wrk); shading flat;
  colormap(cmap); caxis(c_adj)
  m_gshhs_l('patch',ldpatch,'linestyle','none');
  xticklabels = lonticks; if ky<nyr; xticklabels = ''; end
  yticklabels = latticks; if kb>1;   yticklabels = ''; end
  m_grid('linest',':','linewidth',0.05,'Fontsize',fsize-2,...
	  'xtick',lonticks,'xticklabel',xticklabels,...
	  'ytick',latticks,'yticklabel',yticklabels)
  m_contour(maps.lon_ful,maps.lat_ful,SIC,[1 1],'color','k','linewidth',0.5)
  if ky==1; title(datestr(tdoy(kb),'mmm-dd'),'fontsize',fsize+1); end
  if kb==nb; text(0.20,0.02,{years(yid,:);ystr{ky}},...
	  'fontsize',fsize+1,'fontweight','bold','rot',-90,'hor','cent'); end
end
end
hco = colorbar('position',[fgx-0.06 fgy-2*fgdh+0.04 0.011 fgh+fgdh*1.55]);
set(hco,'ticks',cticks,'ticklabels',NCP_ticks,'Fontsize',fsize-0.5)
title(hco,{'NCP',unit_NCP},'Fontsize',fsize-0.5)

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
%print('-dpng','-r500',ffig)
