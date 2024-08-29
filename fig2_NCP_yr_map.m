% Create Figure 2 of
%    "The Responses of Net Community Production to
%     Sea ice Reduction in the Western Arctic Ocean"
% by Zhou et al. The figure consists of 
%   - 7 subpanels of yearly distribution of NCP
%   - 1 subpanel of kmeans clusters
%
%         Author: Tianyu Zhou, Apr/22/2024
%         Modified by: Yun Li, UDel, Apr/27/2024

clc; clear; close all; info_params;
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'fig02_NCP_yr_map'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx=0.14; fgw=0.20; fgdw=0.205;
fgy=0.50; fgh=0.20; fgdh=0.23;
fs= 7;

%################################
%## (a-g) year-to-year NCP maps #
%################################
load(fmap); load(fcmap_NCP)
NCP = maps.NCP(:,:,maps.years>=af15(1));  
NCP(NCP<-1E6) = NaN;
[NCP_adj,c_adj] = fun_NCP_adj(NCP      ,NCP_linrg,NCP_linrg*8);
[cticks ,~    ] = fun_NCP_adj(NCP_ticks,NCP_linrg,NCP_linrg*8);
for ky = 1:Naf15
  NCP_wrk = squeeze(NCP_adj(:,:,ky));
  SIC = ~isnan(NCP_wrk).*1.; SIC(maps.mask==0)=NaN;
  if ky<5; axes('Position',[fgx+fgdw*(ky-1) fgy      fgw fgh]);
  else;    axes('Position',[fgx+fgdw*(ky-5) fgy-fgdh fgw fgh]); end; hold on
  m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end]);
  m_pcolor(maps.lon_ful,maps.lat_ful,NCP_wrk); shading flat;
  colormap(cmap); caxis(c_adj)
  m_gshhs_l('patch',ldpatch,'linestyle','none');
  m_grid('linest','none','linewidth',0.1,'Fontsize',fs-3,'xtick',185:15:360-130)
  m_text(200,68,[plabels{ky},' ',num2str(af15(ky))],'fontsize',fs,'fontweight','bold','color','w')
  m_contour(maps.lon_ful,maps.lat_ful,SIC,[1 1],'color','k','linewidth',0.5)
end
hco = colorbar('position',[0.08 fgy-fgdh+0.01 0.019 fgh+fgdh*0.7]);
set(hco,'ticks',cticks,'ticklabels',NCP_ticks,'Fontsize',fs-1)
title(hco,{'NCP',unit_NCP},'Fontsize',fs-1)

%####################
%## (h) K-means map #
%####################
ha = axes('Position',[fgx+fgdw*3 fgy-fgdh fgh fgw]); hold on
m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end])
m_pcolor(maps.lon_ful,maps.lat_ful,maps.cluster); shading flat;
colormap(ha,clscolor);
m_gshhs_l('patch',ldpatch,'linestyle','none');
m_grid('linest','none','linewidth',0.1,'Fontsize',fs-3,'xtick',185:15:360-130)
m_text(200,68,plabels{8},'fontsize',fs,'fontweight','bold','color','w')
% text for subdivisions
m_text(360-178,77,'C4','color','w','Fontsize',fs,'fontweight','bold')
m_text(360-178,74,'C3','color','w','Fontsize',fs,'fontweight','bold')
m_text(360-178,71,'C2','color','w','Fontsize',fs,'fontweight','bold')
m_text(360-170,70,'C1','color','w','Fontsize',fs,'fontweight','bold')

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
print('-dpng','-r500',ffig)
