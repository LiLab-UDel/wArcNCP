% Create Figure 1 of 
%    "Enhanced Net Community Production with Sea Ice Loss 
%     in the Western Arctic Ocean Uncovered by 
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of four subpanels:
%   - data distribution across years
%   - data distribution with months
%   - data geographic distribution
%   - Taylor Diagram of model performance
%
%         Author: Tianyu Zhou, UDel, Apr/22/2024
%         Modified by: Yun Li, UDel, Apr/25/2024
%                 Tianyu Zhou, UDel, Oct/17/2024

clc; clear; close all; info_params;
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'fig01_data_distribut_RF_train'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx=0.15; fgw=0.33; fgdw=0.35;
fgy=0.60; fgh=0.50; fgdh=0.42;
fs= 6.5;

%###################
%##   load data   ##
%###################
load(fobs); load(fmap); load(fcmap_NCP)
dt = out.obs; dt.year = year(dt.date);
disp(' NCP data report')                         % summary of data availability
disp('------------------------------------------')
disp(['             Total  rec  = ' num2str(size(dt,1))])
id = find(maps.mask(dt.gid)); di = dt(id,:);     % data within study domain
di.doy = day(di.date,'dayofyear');
disp(['     within study region = ' num2str(length(id))])
dt.doy = day(dt.date,'dayofyear');
dt.dO2Ar(maps.mask(dt.gid)~=1) = NaN;            % outside study domain
dt.dO2Ar(dt.doy<obs_str | dt.doy>obs_end) = NaN; % outside the period
dt.dO2Ar(isnan(dt.bbp)) = NaN;                   % outside the openwater
dt.dO2Ar(dt.NCP<=-30) = NaN;                     % remove NCP<-30
dt = rmmissing(dt);                              % remove outliers
disp(['               Remaining = ' num2str(size(dt,1))])
disp(['Data coverage in the wAO = ' ...
      num2str(100*length(unique(dt.gid))./sum(maps.mask(:)==1),'%.1f'),'%'])

%#######################
%##   ML Evaluation   ##
%#######################
wrk = [dt.NCP,dt.NCP_mod];                       % ML training and testing
for ky = 1:length(af15)+1
  if ky<=Naf15; yy2{ky} = datestr(datenum(af15(ky),1,1),'yy');
          else; yy2{ky} = 'all'; end
  for kK = 1:2
    if ky<=Naf15; swrk = wrk(dt.flag==kK & dt.year==af15(ky),:);
            else; swrk = wrk(dt.flag==kK,:); end
    % Calculate STD RMSD and COR
    STATS(:,1) = SStats(swrk(:,1),swrk(:,1));    % reference obs vs obs
    STATS(:,2) = SStats(swrk(:,1),swrk(:,2));    % between obs vs model
    STATS(1,:) = [];                 % reduce dimension from 4x2 to 3x2
    % Normalization of STD and RMSD to hold all years together
    % and calculate data coordinates (mx,my) of the Taylor Diagram
    mx(ky,kK) = STATS(1,2)./STATS(1,1).*STATS(3,2);
    my(ky,kK) = STATS(1,2)./STATS(1,1).*sin(acos(STATS(3,2)));
    % prepare the stats for printing
    Nobs(kK)  = length(swrk(:,1));                  % number of obs NCP data
    oSTD(kK)  = STATS(1,1);                         % standard deviation of obs NCP data
    Rval(kK)  = STATS(3,2);                         % corr. coeff. between obs and model NCP data
    Pval(kK)  = STATS(4,2);                         % p-value of corr. coeff.
    nSTD(kK)  = STATS(1,2)./STATS(1,1);             % normalized STD of model NCP data
    ncRMSD(kK)= sqrt(my(ky,kK).^2+(1-mx(ky,kK)).^2);% normalized cRMSD between obs and model NCP
    clear STATS
  end
  % print stats for each year
  if ky==1
    disp('                                       ')
    disp('ML evaluation report (training,testing)')
    disp('--------------------------------------------------------------------------')
    disp('Year    n      obs.STD           R            p          nSTD       ncRMSD')
  end
  disp([yy2{ky}...
   ' ' num2str(Nobs,  '(%.i,%.i)')...
   ' ' num2str(oSTD,  '(%05.2f,%05.2f)')...
   ' ' num2str(Rval,  '(%.2f,%.2f)')...
   ' ' num2str(Pval,  '(%.e,%.e)')...
   ' ' num2str(nSTD,  '(%.2f,%.2f)')...
   ' ' num2str(ncRMSD,'(%.2f,%.2f)')]);
end
disp('                                       ')

%#############################################
%## (a) processed NCP data: yearly histogram #
%#############################################
ha = axes('Position',[fgx fgy fgw 0.22]); hold on; box on;
xlims = [2012.4 2021.6]; Xbin = 2013:2021;      % x-axis of yearly histogram
YLIM = [2.5 5];
% prepare for the broken axis
di.year(di.year<2015)=di.year(di.year<2015)+2;  % shift 2012 up to fit x-position
% yearly histogram
[N1,~] = hist(di.year,Xbin);                    % all data within the region
[N2,~] = hist(dt.year,Xbin);                    % subset for ML input
bar(Xbin,log10(N1+1),'facecolor','none','linewidth',0.55)
bar(Xbin,log10(N2+1),0.78,'facecolor',ldpatch,'edgecolor','none')
text(xlims(1)+diff(xlims)*0.03,YLIM(2)-diff(YLIM)*0.01,plabels{1},...
        'FontSize',fs+1,'FontWeight','bold','vert','top','horiz','left');
ylabel('Number of O_{2}/Ar data','FontSize',fs,'FontWeight','bold')
set(gca,'fontsize',fs,...
        'xlim',xlims,'xtick',Xbin,'xticklabel',datestr(datenum([2011:2012 af15],1,1),'yy'), ...
        'ylim',YLIM,'ytick',3:5,'YTickLabel',{'10^{3}','10^{4}','10^{5}'})
line(xlims(1)+[1.94 2.09],YLIM(1)+[-1 1]*0.08,'color','k','linewidth',0.5,'Clipping','off');
line(xlims(1)+[2.10 2.25],YLIM(1)+[-1 1]*0.08,'color','k','linewidth',0.5,'Clipping','off');
line(xlims(1)+[2.02 2.17],YLIM(1)+[-1 1]*0.08,'color','w','linewidth',1.5,'Clipping','off');

%##########################################
%## (b) raw O2/Ar data: monthly histogram #
%##########################################
axpos = [fgx+fgdw fgy fgw 0.22];
axes('Position',axpos); hold on; box off;
xticks = datenum(0,obs_mm,15); xlims = datenum(0,[5 12],1)+[-5 5]; 
yticks = [1 2 4 7 12]; dex = 42;
[N1,~] = hist(month(di.date),obs_mm);           % all data within the region
[N2,~] = hist(month(dt.date),obs_mm);           % subset for ML input
% monthly data availability
bar(xticks,log10(N1+1),'facecolor','none','linewidth',0.55)
bar(xticks,log10(N2+1),0.78,'facecolor',ldpatch,'edgecolor','none')
text(xlims(1)+diff(xlims)*0.03,YLIM(2)-diff(YLIM)*0.01,plabels{2},...
	'FontSize',fs+1,'FontWeight','bold','vert','top','horiz','left')
set(gca,'fontsize',fs,...
    'ylim',YLIM,'YTick',3:5 ,'YTickLabel','',...
    'xlim',xlims,'Xtick',xticks,'xticklabel',datestr(xticks,'mmm'),'xticklabelrot',0);
% monthly open water (% of total area) 
axes('Position',axpos,'color','none'); hold on; box off;
plot(1:365,100*(1-out.SIC_clm),'LineWidth',1,'color',ctscolor)
set(gca,'fontsize',fs,...
	'xlim',xlims,'xtick',xticks,'xticklabel','','xaxisloc','top',...
	'ylim',[0 100],'ytick',0:25:100,'yaxisloc','right','ycolor',ctscolor)
ylabel('Open water (%)','FontSize',fs,'FontWeight','bold')
% monthly data coverage of open water (%)
owt= 1:365;
ow = (1-out.SIC_clm)*sum(maps.mask(:)==1);      % daily open water grid cells
for km = 5:11 
  mstr = datenum(0,km,1);
  mend = datenum(0,km+1,1);
  idd = find(di.doy>=mstr & di.doy<mend);       % data within a given month
  gwrk = di.gid(idd); gwrk = unique(gwrk);      % data-available grid cells
  npix_mm(km-4) = length(gwrk);                 % number of data-avaialble grid cells
  npix_ow(km-4) = mean(ow(owt>=mstr& owt<mend));% number of open water grid cells
  disp([datestr(mstr,'mmm') ': ' ...
	num2str(length(gwrk),'%4.4i') ' grid cells w/ obs out of ' ...
	num2str(length(idd ),'%5.5i') ' open water grid cells'])
end
axes('pos',axpos.*[1 1 dex/diff(xlims)+1 1],'color','none'); hold on; box off;
plot(xticks,log10(npix_mm./npix_ow),'s-','linewidth',1,'color',clscolor(4,:),'markersize',3,'markerfacecolor',clscolor(4,:))
set(gca,'fontsize',fs,'tickdir','out',...
    'xlim',xlims+[0 dex],'Xtick',xticks,'xticklabel','','xcolor','none',...
    'ylim',[-2.0 -0.9],'ytick',log10(yticks/100),'yticklabel',yticks,'yaxisloc','right','ycolor',clscolor(4,:));
ylabel({'data coverage';'of open water (%)'},'fontsize',fs,'fontweight','bold');

%#######################################
%## (c) NCP data: spatial distribution #
%#######################################
axes('Position',[fgx-0.05 fgy-fgdh-0.05 fgdw+0.05 fgdw+0.05]); hold on
[NCP_adj,c_adj] = fun_NCP_adj(dt.NCP,NCP_linrg,NCP_linrg*8);
[cticks,~] = fun_NCP_adj(NCP_ticks,NCP_linrg,NCP_linrg*8);
% mapped region and bathy
m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end])
m_gshhs_l('patch',ldpatch,'linestyle','none');
m_grid('linest',':','linewidth',0.1,'Fontsize',fs-1,'xtick',lonticks,'ytick',latticks)
m_text(200,68,['n = ',num2str(size(dt,1))],'fontsize',fs+2,'fontweight','bold','color','w')
[C,h] = m_contour(maps.lon_ful,maps.lat_ful,maps.Bathy,[-40 -100 -500:-1000:-3500],...
	'color',ldpatch,'linewidth',0.3);
% uncomment the line below to manually add bathymetry contours
clabel(C,h,'manual','fontsize',fs-1)
m_scatter(dt.lon,dt.lat,0.5,NCP_adj,'filled')
colormap(cmap); caxis(c_adj)
text(-0.115,0.11,plabels{3},'fontsize',fs+1,'fontweight','bold')
% text of geographic location
text(0.035,0.045,{'Canada','Basin'},'fontsize',fs,'fontweight','bold','color',[0 0 0])
text(-0.09,-0.035,{'Chukchi','  Shelf'},'fontsize',fs,'fontweight','bold','Rot',74,'color',[0 0 0])
% colorbar
hco = colorbar('position',[fgx+fgdw-0.055,fgy-fgdh+0.13,0.012,fgdw-0.11]);
set(hco,'ticks',cticks,'ticklabels',NCP_ticks,'Fontsize',fs-1.5)
hco.Ruler.TickLabelRotation = 0;
title(hco,['NCP ',unit_NCP],'Fontsize',fs-1,'Position',[24 37],'rotation',90)

%###########################
%##  (d) Taylor Diagram   ##
%###########################
ax = axes('Position',[fgx+fgdw fgy-fgdh-0.05 fgdw+0.05 fgdw+0.05],'color','none'); hold on
mSTD = [0:0.2:1.0 1.05];
mCOR = [0.7 0.8 0.9 0.95 0.99];
mRMS = [0.1:0.1:0.6];
add_taylordiag;  % create taylor diagram frame;
id = 1:Naf15;
text(mx(id,1),my(id,1),yy2(id),'color','k','fontsize',fs-2);
text(mx(id,2),my(id,2),yy2(id),'color',ctscolor,'fontsize',fs-2);
text(mx(end,1),my(end,1),yy2(end),'color','k','fontsize',fs,'fontweight','bold'); 
text(mx(end,2),my(end,2),yy2(end),'color',ctscolor,'fontsize',fs+0.5,'fontweight','bold');
text(0.035,0.7,plabels{4},'fontsize',fs+1,'fontweight','bold')
% add a legend
hp = patch([0.18 0.4 0.4 0.18],[0.02 0.02 0.145 0.145],'w');
set(hp,'edgecolor',ldpatch);
text(0.2,0.09,'Training','fontsize',fs,'fontweight','bold','hori','left','vert','bot','color','k');
text(0.2,0.03,'Testing','fontsize',fs,'fontweight','bold','hori','left','vert','bot','color',ctscolor);
%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
%print('-dpng','-r500',ffig)
