% Create Figure S9 of
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of 
%   - 12 subpanels of yearly distribution of NCP
%
%         Author: Tianyu Zhou, UDel, Oct/10/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'figS9_NCP_yr_map_03to14'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx=0.24; fgw=0.15; fgdw=0.138;
fgy=0.60; fgh=0.15; fgdh=0.168;
fsize= 6;
nrow = 3; ncol = 4;   % create nrow x ncol subpanels

%###################
%## 8-day NCP maps #
%###################
load(fmap); load(fcmap_NCP)
NCP = maps.NCP(:,:,maps.years<=bf15(end));
NCP(NCP<-1E6) = NaN;
[NCP_adj,c_adj] = fun_NCP_adj(NCP      ,NCP_linrg,NCP_linrg*8);
[cticks ,~    ] = fun_NCP_adj(NCP_ticks,NCP_linrg,NCP_linrg*8);
for ky = 1:nrow
for kb = 1:ncol
  if ky==1&kb==1; plid = 1; else; plid = plid+1; end
  NCP_wrk = squeeze(NCP_adj(:,:,plid));
  SIC = ~isnan(NCP_wrk).*1; SIC(maps.mask==0)=NaN;
  axes('Position',[fgx+fgdw*(kb-1) fgy-fgdh*(ky-1) fgw fgh]); hold on
  m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end]);
  m_pcolor(maps.lon_ful,maps.lat_ful,NCP_wrk); shading flat;
  colormap(cmap); caxis(c_adj)
  m_gshhs_l('patch',ldpatch,'linestyle','none');
  xticklabels = lonticks; if ky<nrow; xticklabels = ''; end
  yticklabels = latticks; if kb>1;   yticklabels = ''; end
  m_grid('linest',':','linewidth',0.05,'Fontsize',fsize-2,...
	  'xtick',lonticks,'xticklabel',xticklabels,...
	  'ytick',latticks,'yticklabel',yticklabels)
  m_text(200,68,[num2str(bf15(plid))],'fontsize',fsize,'fontweight','bold','color','w')
  m_contour(maps.lon_ful,maps.lat_ful,SIC,[1 1],'color','k','linewidth',0.5)
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
