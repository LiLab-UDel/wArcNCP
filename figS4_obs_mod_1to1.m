% Create Figures S4 of
%    "The Responses of Net Community Production to
%     Sea ice Reduction in the Western Arctic Ocean"
% by Zhou et al. The figure consists of 2 subpanels:
%   - Observation-model comparison of training
%   - Observation-model comparison of testing
%
%         Author: Tianyu Zhou, Aug/25/2024
%         Modified by: Yun Li, UDel, Aug/25/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'figS4_obs_mod_1to1'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx = 0.10; fgw = 0.42; fgdw = 0.32;
fgy = 0.32; fgh = fgw;
fsize = 8;
dlims = [-40 190]; dticks = [-20:40:190]; dbin = 2.5;   % 1:1 plot params
load(fcmap_NCPdens)

%###############
%## load data ##
%###############
load(fobs)
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
   colormap(cmap); caxis(cticks([1 end]))
   c = colorbar('horiz','position',...
       [fgx+fgdw*(kp-1)+0.075 fgy+fgh+0.015 fgw-0.145 0.02]);
   set(c,'xtick',cticks,'xticklabel',10.^cticks)
end
xlabel(['Observation-derived NCP ',unit_NCP],'pos',[dlims(1) dlims(1)-20])
text(dlims(1),dlims(2)+45,...     % colorbar title
    ['Number of data in ',num2str(dbin),' x ',num2str(dbin),...
     ' ',unit_NCP,' bin'],...
     'fontsize',fsize,'horiz','cen','vert','bot')

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
print('-dpng','-r500',ffig)
