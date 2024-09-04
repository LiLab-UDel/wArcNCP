% Create Figure 3 of
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of
%   - 4 subpanels of regional int_NCP, int_NPP, and open water area
%   - 4 subpanels of regional e-ratio
%
%         Author: Tianyu Zhou, UDel, Apr/22/2024
%         Modified by: Yun Li, UDel, Apr/27/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'fig03_NCP_subreg_time_series'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx=0.07;  fgw=0.19; fgdw=0.20;
fgy=0.395; fgh=0.40; fgdh=0.175;
fs= 5.5;  sz = 5;

%##################
%##  Load data   ##
%##################
load(fmap); tid = find(maps.years>=af15(1));
NCP = reshape(maps.NCP(:,:,tid),[411*411 Naf15]); NCP(NCP<-1E6) = 0;
NPP = reshape(maps.NPP(:,:,tid),[411*411 Naf15]); NPP(NPP<-1E6) = 0;
owa = reshape(maps.owa(:,:,tid),[411*411 Naf15]);

%##################
%##  Make plots  ##
%##################
% parameters to control broken axes
ycut = 0.2; cff = 0.15; cgap = 0.015;
YLIM1 = [ycut 20.2]; YTICK1 = ycut+linspace(0,20,6);
YLIM2 = [   0 ycut]; YTICK2 = 0:0.1:0.2; YTICKL2={'0.0','0.1',''};
YLIM3 = [   0   32]; YTICK3 = linspace(0,32,6);
YLIM4 = [0.05 0.55]; YTICK4 = 0:0.1:0.6;
XLIM  = [2014.4 2021.6];
disp('Region   total     AOWA      int_NCP   int_NPP    e_ratio    OWA-int_NCP     slope         power-law expo')
disp('      (1E4 km2)  (1E4 km2)  (Tg C)    (Tg C)                              (Tg C/1E4 km2)    PRELIMINARY  ');
disp('---------------------------------------------------------------------------------------------------------')
for kc = 1:5
  %-----------------------
  % regional integration
  %-----------------------
  if kc<5
    gid = find(maps.cluster==kc); 
    clsnam = [' C' num2str(kc)];
    mcolor = clscolor(kc,:);
  else;
    gid = find(maps.cluster>0); 
    clsnam = 'all'; 
  end
  cnum = length(gid);
  NCP_yr = sum(NCP(gid,:))*cff_NCP2intNCP;
  NPP_yr = sum(NPP(gid,:))*cff_NCP2intNCP;
  owa_yr = sum(owa(gid,:))/1e6/1e4;  % 10^6 m^2=1 km^2; 10^4 order of magnitude
  eratio_yr = NCP_yr./NPP_yr;

  %------------------------------------------------
  % report statistics
  %   intNCP = sum[ NCP * dA * dt] 
  %          = sum[mask * dA * dt] * effective_NCP
  %          = owa^1 * effective_NCP
  % Linear-fit:  
  %   intNCP = a * owa + b
  %------------------------------------------------
  [rr,pp] = corr(owa_yr(:),NCP_yr(:));      % correlation
  cff_lin = polyfit(owa_yr(:),NCP_yr(:),1); % linear regression
  cff_pow = polyfit(log10(owa_yr(:)),...
                    log10(NCP_yr(:)),1);    % preliminary power-law regression (not shown)
  disp([clsnam ...
	  '   ' num2str(cnum*36/1e4,'%4.2f') ...
	  '   ' num2str(mean(owa_yr),'%4.2f') '+/' num2str(std(owa_yr),'%4.2f') ...
	  '   ' num2str(mean(NCP_yr),'%4.2f') '+/' num2str(std(NCP_yr),'%4.2f') ...
	  '   ' num2str(mean(NPP_yr),'%4.2f') '+/' num2str(std(NPP_yr),'%4.2f') ...
	  '   ' num2str(mean(eratio_yr),'%4.2f') '+/' num2str(std(eratio_yr),'%4.2f') ...
	  '   (' num2str(rr,'%3.2f') ', ' num2str(pp,'%6.4f') ')' ...
	  '   ' num2str(cff_lin(1),'%6.3f') ...
	  '   ' num2str(cff_pow(1),'%6.3f') ...
	  ] )
  if kc>4; continue; end

  %------------------------------------------------
  % uppper panel - broken axis bottom part
  %------------------------------------------------
  ha1 = axes('pos',[fgx+fgdw*(kc-1) fgy fgw fgh*cff]); hold on; 
  hb = bar(af15-0.2,NCP_yr,0.4); 
  set(hb,'linewidth',0.5, 'edgecolor',mcolor,'facecolor',mcolor);
  hb = bar(af15+0.2,NPP_yr,0.4); 
  set(hb,'linewidth',0.5, 'edgecolor',mcolor,'facecolor','none');
  set(ha1,'XAxisLocation','bot','fontsize',fs-1,'box','off',...
	  'xlim',XLIM ,'xtick',af15,'xticklabel','',...
          'ylim',YLIM2,'ytick',YTICK2,'yticklabel','');
  if kc==1; set(gca,'yticklabel',YTICKL2); end
  axes('pos',[fgx+fgdw*(kc-1) fgy fgw fgh*cff],'color','none'); hold on; 
  set(gca,'XAxisLocation','bot','fontsize',fs-1,'box','off',...
          'xlim',XLIM ,'xtick',af15,'xticklabel','',...
          'ylim',YLIM2,'ytick',YTICK2,'yticklabel','','yaxisloc','right');

  %------------------------------------------------
  % upper panel - broken axis top part (int prod)
  %------------------------------------------------
  ha2 = axes('pos',[fgx+fgdw*(kc-1) fgy+fgh*(cff+cgap) fgw fgh*(1-cff-cgap)]); hold on; 
  hb = bar(af15-0.2,NCP_yr,0.4,'hist');
  set(hb,'linewidth',0.5, 'edgecolor',mcolor,'facecolor',mcolor);
  hb = bar(af15+0.2,NPP_yr,0.4,'hist');
  set(hb,'linewidth',0.5, 'edgecolor',mcolor,'facecolor','none');
  set(ha2,'XAxisLocation','bot','fontsize',fs,...
          'xlim',XLIM ,'xtick',af15,'xticklabel','','xcolor',get(gcf,'color'),...
          'ylim',YLIM1,'ytick',YTICK1,'yticklabel','');
  hp = patch(XLIM(1)+diff(XLIM)*[1e-3 1e-3 0.2 0.2],YLIM1(2)-diff(YLIM1)*[0 0.14 0.14 0],'k');
  set(hp,'facecolor',mcolor,'edgecolor','none');
  text(XLIM(1)+diff(XLIM)*0.1,YLIM1(2)-diff(YLIM1)*0.07,clsnam,'color','w',...
          'fontsize',fs+2,'fontweight','bold','horiz','cen','vert','mid');
  text(XLIM(2)-diff(XLIM)*0.02,YLIM1(2)-diff(YLIM1)*0.02,plabels{kc},...
	  'fontsize',fs+1,'fontweight','bold','horiz','right','vert','top');
  if kc==1; set(gca,'yticklabel',YTICK1); ytickformat('%.1f'); 
            ylabel('Regional production (Tg C)','pos',[2013.1 8.5],'fontsize',fs+1,'FontWeight','bold'); end;

  %------------------------------------------------
  % upper panel - top part overlay (open water)
  %------------------------------------------------
  axes('pos',[fgx+fgdw*(kc-1) fgy+fgh*(cff+cgap) fgw fgh*(1-cff-cgap)],'color','none'); hold on; 
  plot(af15, owa_yr,'ks-','markerfacecolor','k','markersize',3,'linewidth',1.2);
  set(gca,'xAxisLocation','top','fontsize',fs-0.5,'box','off',...
          'xlim',XLIM ,'xtick',af15,'xticklabel','',...
          'ylim',YLIM3,'ytick',YTICK3,'yticklabel','','yaxisloc','right');
  if kc==4; set(gca,'yticklabel',YTICK3); ytickformat('%.1f');
            ylabel('Mean open water area (10^4 km^2)','fontsize',fs+0.5,'FontWeight','bold'); end 

  %------------------------------------------------
  % lower panel - e-ratio
  %------------------------------------------------
  axes('pos',[fgx+fgdw*(kc-1) fgy-fgdh fgw fgdh-0.02]); hold on; box on; grid on;
  plot(af15, eratio_yr,'ks-','markerfacecolor','k','markersize',3,'linewidth',1.2);
  set(gca,'fontsize',fs,...
          'xlim',XLIM ,'xtick',af15,'xticklabel',af15_yy,'xticklabelrot',0,...
          'ylim',YLIM4,'ytick',YTICK4,'yticklabel','');
  text(XLIM(2)-diff(XLIM)*0.02,YLIM4(2)-diff(YLIM4)*0.02,plabels{kc+4},...
          'fontsize',fs+1,'fontweight','bold','horiz','right','vert','top');
  if kc==1; set(gca,'yticklabel',[0:0.1:0.5]); ytickformat('%.1f');
            ylabel('e-ratio','fontsize',fs+1,'pos',[2013.1 0.25],'FontWeight','bold');
            xlabel('Year','FontSize',fs+1,'FontWeight','bold','Position',[2029.5 -0.03]); end
end

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off')
%print('-dpng','-r500',ffig)
