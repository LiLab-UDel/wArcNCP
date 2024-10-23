% Create Figures S5 of
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of 4 subpanels:
%   - Observation-model comparison of training
%   - Observation-model comparison of testing
%   - Spatial distribution of observation-derived NCP
%   - Spatial distribution of RF-model-derived NCP
%
%         Author: Tianyu Zhou, UDel, Aug/25/2024
%         Modified by: Yun Li, UDel, Aug/25/2024
%                 Tianyu Zhou, UDel, Oct/14/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'figS5_obs_mod_1to1_map'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx = 0.20; fgw = 0.37; fgdw = 0.28;
fgy = 0.50; fgh = fgw;  fgdh = 0.41;
fsize = 8;
dlims = [-40 190]; dticks = [-20:40:190]; dbin = 2.5;   % 1:1 plot params
load(fcmap_NCPdens); cmap_NCPdens = cmap;
load(fcmap_NCP);     cmap_NCP     = cmap;

%###############
%## load data ##
%###############
load(fobs); load(fmap)
id_ML = find(~isnan(out.obs.flag));
obs = out.obs(id_ML,:);

%#################################
%## display % of extreme values ##
%#################################
for wrk = [60 80 160]
   disp([num2str(100*sum(obs.NCP>=wrk)./size(obs,1),'%.2f'),...
         '% data > ' num2str(wrk) unit_NCP]); end 

%###########################
%## 1:1 data density plot ##
%###########################
for kp = 1:2
   if     kp==1; label = 'training'; cticks=log10([1 10 100]);
   elseif kp==2; label = 'testing';  cticks=log10([1  3  10]);
   end
   X = obs.NCP(    obs.flag==kp);
   Y = obs.NCP_mod(obs.flag==kp);
   % calculate stats
   [r,p] = corr(X,Y);                     % linear correlation
   rmsd = sqrt(sum((X-Y).^2)./length(X)); % root mean squared diff
   std_obs = std(X);                      % standard deviation of obs
   % data density
   bins = [dlims(1):dbin:dlims(end)];        % bins for data density plot
   [XI,YI,DENS] = fun_diag11_dens(X,Y,bins); % count data density per bin
   DENS(DENS==0) = NaN; DENS = log10(DENS);
   % plotting
   axes('position',[fgx+fgdw*(kp-1) fgy fgw fgh]); hold on
   pcolor(XI,YI,DENS); shading flat
   plot(dlims,dlims,'-k','linewidth',0.5)         % 1:1 line
   plot(dlims,dlims+std_obs,':k','linewidth',0.3) % +1*std
   plot(dlims,dlims-std_obs,':k','linewidth',0.3) % -1*std
   axis equal
   text(dlims(1)+0.05*diff(dlims),dlims(2)-0.05*diff(dlims),...
	   [plabels{kp} ' '  label],'fontweight','bold',...
	   'fontsize',fsize,'horiz','left','vert','top')
   text(dlims(2)-0.05*diff(dlims),dlims(1)+0.05*diff(dlims),...
	   {['n = ' num2str(length(X))],...
	    ['RMSD = ' num2str(rmsd,'%.2f')],...
	    ['R = ' num2str(r,'%.2f')]},...
	     'fontsize',fsize,'horiz','right','vert','bot')
   % figure settings
   set(gca,'fontsize',fsize,...
        'xlim',dlims,'xtick',dticks,'xticklabelrot',0,...
        'ylim',dlims,'ytick',dticks); grid on; box on
   if kp==1; ylabel(['RF model ',unit_NCP]); end
   if kp==2; set(gca,'yticklabel',''); end
   % colormap and colorbar
   colormap(cmap_NCPdens); caxis(cticks([1 end]))
   c = colorbar('horiz','position',...
       [fgx+fgdw*(kp-1)+0.075 fgy+fgh+0.015 fgw-0.145 0.02]);
   set(c,'xtick',cticks,'xticklabel',10.^cticks)
end
xlabel(['Observation-derived NCP ',unit_NCP],'pos',[dlims(1) dlims(1)-20])
text(dlims(1),dlims(2)+45,...     % colorbar title
    ['Number of data in ',num2str(dbin),' x ',num2str(dbin),...
     ' ',unit_NCP(2:end-1),' bin'],...
     'fontsize',fsize,'horiz','cen','vert','bot')

%###################################
%## observed and modeled NCP maps ##
%###################################
for kp = 1:2
   ax=axes('Position',[fgx+0.045+(kp-1)*fgdw*0.99 fgy-fgdh fgdw+0.016 fgdw+0.016]); hold on
   if kp==1; NCP_tmp = obs.NCP;
   else;     NCP_tmp = obs.NCP_mod;
   end
   [NCP_adj,c_adj] = fun_NCP_adj(NCP_tmp,NCP_linrg,NCP_linrg*8);
   [cticks,~] = fun_NCP_adj(NCP_ticks,NCP_linrg,NCP_linrg*8);
   m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end])
   m_gshhs_l('patch',ldpatch,'linestyle','none');
   yticklabels = latticks; if kp == 2; yticklabels = ''; end
   m_grid('linest',':','linewidth',0.1,'Fontsize',fsize-3,...
	   'xtick',lonticks,'ytick',latticks,'yticklabel',yticklabels)
   [C,h] = m_contour(maps.lon_ful,maps.lat_ful,maps.Bathy,[-40 -100 -500:-1000:-3500],...
        'color',ldpatch,'linewidth',0.3);
   m_scatter(obs.lon,obs.lat,0.5,NCP_adj,'filled')
   colormap(ax,cmap_NCP); caxis(c_adj)
   text(-0.15,0.12,plabels{kp+2},'fontsize',fsize,'fontweight','bold')
end
hco = colorbar('position',[fgx+0.022,fgy-fgdh+0.03,0.01,fgdw-0.01]);
set(hco,'ticks',cticks,'ticklabels',NCP_ticks,'Fontsize',fsize-1)
hco.Ruler.TickLabelRotation = 0;
title(hco,['NCP ',unit_NCP],'Fontsize',fsize-1,'Position',[-18 45],'rotation',90)

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
%print('-dpng','-r500',ffig)
