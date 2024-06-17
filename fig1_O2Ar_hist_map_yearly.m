% Create Figure 1 of 
%    "The Responses of Net Community Production to
%     Sea ice Reduction in the Western Arctic Ocean"
% by Zhou et al. The figure consists of five subpanels:
%   - data distribution with months
%   - data distribution across years
%   - data geographic distribution
%   - Model ranking of environmental predictors
%   - Taylor Diagram of model performance
%
%         Author: Tianyu Zhou, Apr/22/2024
%         Modified by: Yun Li, UDel, Apr/25/2024

clc; clear; close all; info_params;
%==========================================================
% Edit the following based on user's purpose
ffig = 'fig01_data_distribut_RF_train';
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx=0.15; fgw=0.31; fgdw=0.35;
fgy=0.50; fgh=0.50; fgdh=0.40;
fs= 6.5;

%###################
%##   load data   ##
%###################
load(fobs); load(fmap); load(fcmap_NCP)
dt = out.obs; dt.year = year(dt.date);
disp(' NCP data report')                         % summary of data availability
disp('------------------------------------------')
disp(['        Total  rec  = ' num2str(size(dt,1))])
id = find(maps.mask(dt.gid)); di = dt(id,:);     % data within study domain
disp(['within study region = ' num2str(length(id))])
dt.doy = day(dt.date,'dayofyear');
dt.dO2Ar(dt.doy<obs_str | dt.doy>obs_end) = NaN; % outside the period
dt.dO2Ar(isnan(dt.bbp)) = NaN;                   % outside the openwater
dt.dO2Ar(dt.NCP<=-30) = NaN;                     % remove NCP<-30
dt = rmmissing(dt);                              % remove outliers
disp(['          Remaining = ' num2str(size(dt,1))])

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
    my(ky,kK) = STATS(1,2)./STATS(1,1).*sin(acos(STATS(3,2))); clear STATS
  end
end

%##########################################
%## (a) raw O2/Ar data: monthly histogram #
%##########################################
axpos = [fgx 0.74 fgw 0.20];
axes('Position',axpos); hold on; box off;
XTICK = datenum(0,obs_mm,15); XLIM = datenum(0,[5 12],1)+[-5 5]; YLIM = [2.5 5];
[N1,~] = hist(month(di.date),obs_mm);            % all data within the region
[N2,~] = hist(month(dt.date),obs_mm);            % subset for ML input
bar(XTICK,log10(N1+1),'facecolor','none','linewidth',0.55)
bar(XTICK,log10(N2+1),0.78,'facecolor',ldpatch,'edgecolor','none')
text(XLIM(1)+diff(XLIM)*0.03,YLIM(2)-diff(YLIM)*0.01,plabels{1},...
	'FontSize',fs,'FontWeight','bold','vert','top','horiz','left')
set(gca,'fontsize',fs,...
    'ylim',YLIM,'YTick',3:5 ,'YTickLabel',{'10^{3}','10^{4}','10^{5}'},...
    'xlim',XLIM,'Xtick',XTICK,'xticklabel',datestr(XTICK,'mmm'),'xticklabelrot',0);
axes('Position',axpos,'color','none'); hold on; box off;
plot(1:365,100*(1-out.SIC_clm),'LineWidth',1,'color',ctscolor)
set(gca,'fontsize',fs,...
	'xlim',XLIM,'xtick',XTICK,'xticklabel','','xaxisloc','top',...
	'ylim',[0 100],'ytick',0:25:100,'yaxisloc','right','ycolor',ctscolor)
ylabel('Open water (%)','FontSize',fs,'FontWeight','bold')

%#############################################
%## (b) processed NCP data: yearly histogram #
%#############################################
ha = axes('Position',[fgx fgy fgw 0.20]); hold on; box on;
XLIM = [2012.4 2021.6]; Xbin = 2013:2021;       % x-axis of yearly histogram
% prepare for the broken axis
di.year(di.year<2015)=di.year(di.year<2015)+2;  % shift 2012 up to fit x-position
% yearly histogram
[N1,~] = hist(di.year,Xbin);                    % all data within the region
[N2,~] = hist(dt.year,Xbin);                    % subset for ML input
bar(Xbin,log10(N1+1),'facecolor','none','linewidth',0.55)
bar(Xbin,log10(N2+1),0.78,'facecolor',ldpatch,'edgecolor','none')
text(XLIM(1)+diff(XLIM)*0.03,YLIM(2)-diff(YLIM)*0.01,plabels{2},...
        'FontSize',fs,'FontWeight','bold','vert','top','horiz','left');
ylabel('Number of O_{2}/Ar data','Position',[2011.4 5.5],'FontSize',fs,'FontWeight','bold')
set(gca,'fontsize',fs,...
        'xlim',XLIM,'xtick',Xbin,'xticklabel',datestr(datenum([2011:2012 af15],1,1),'yy'), ...
	'ylim',YLIM,'ytick',3:5,'YTickLabel',{'10^{3}','10^{4}','10^{5}'})
line(XLIM(1)+[1.94 2.09],YLIM(1)+[-1 1]*0.08,'color','k','linewidth',0.5,'Clipping','off');
line(XLIM(1)+[2.10 2.25],YLIM(1)+[-1 1]*0.08,'color','k','linewidth',0.5,'Clipping','off');
line(XLIM(1)+[2.02 2.17],YLIM(1)+[-1 1]*0.08,'color','w','linewidth',1.5,'Clipping','off');

%###############################
%## (d) predictor importance  ##
%###############################
axes('Position',[fgx fgy-fgdh+0.04 fgw 0.32]); hold on
bar(out.ML_predictor_importance,'facecolor',ldpatch)
xlabel('Environmental predictors','FontSize',fs,'FontWeight','bold')
ylabel('Relative importance','FontSize',fs,'FontWeight','bold')
text(0.74,0.37,plabels{4},'FontSize',fs,'FontWeight','bold','hori','left','vert','top')
XTICK = out.ML_predictor_names;
set(gca,'fontsize',fs, ...
    'xlim',[0 length(XTICK)]+0.5,'xtick',1:length(XTICK),'xticklabel',XTICK,...
    'ylim',[0 0.38], 'ytick',0:0.05:0.4,'YGrid','on'); box on;
xtickangle(0); ytickformat('%.2f')

%#######################################
%## (c) NCP data: spatial distribution #
%#######################################
axes('Position',[fgx+fgdw+0.01 fgy fgdw fgdw]); hold on
[NCP_adj,c_adj] = fun_NCP_adj(dt.NCP,NCP_linrg,NCP_linrg*8);
[cticks,~] = fun_NCP_adj(NCP_ticks,NCP_linrg,NCP_linrg*8);
% mapped region and bathy
m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end])
m_gshhs_l('patch',ldpatch,'linestyle','none');
m_grid('linest',':','linewidth',0.1,'Fontsize',fs-1,'xtick',185:15:360-130)
m_text(200,68,['n = ',num2str(size(dt,1))],'fontsize',fs+2,'fontweight','bold','color','w')
[C,h] = m_contour(maps.lon_ful,maps.lat_ful,maps.Bathy,[-40 -100 -500:-1000:-3500],...
	'color',ldpatch,'linewidth',0.3);
% uncomment the line below to manually add bathymetry contours
% clabel(C,h,'manual','fontsize',11)
m_scatter(dt.lon,dt.lat,0.5,NCP_adj,'filled')
colormap(cmap); caxis(c_adj)
text(-0.14,0.17,plabels{3},'fontsize',fs,'fontweight','bold')
% text of geographic location
text(0.035,0.045,{'Canada','Basin'},'fontsize',fs,'fontweight','bold','color',[1 1 1]*0.55)
text(-0.09,-0.035,{'Chukchi','  Shelf'},'fontsize',fs,'fontweight','bold','Rot',74,'color',[1 1 1]*0.55)
% colorbar
hco = colorbar('horiz','position',[0.57,0.915,0.23,0.02]);
set(hco,'ticks',cticks,'ticklabels',NCP_ticks,'Fontsize',fs-0.5)
hco.Ruler.TickLabelRotation = 0;
title(hco,'NCP (mmol C m^{-2} d^{-1})','Position',[50 -9.7],'Fontsize',fs)

%###########################
%##  (e) Taylor Diagram   ##
%###########################
ax = axes('Position',[fgx+fgdw fgy-fgdh fgdw fgdw],'color','none'); hold on
mSTD = [0:0.2:1.0 1.05];
mCOR = [0.7 0.8 0.9 0.95 0.99];
mRMS = [0.1:0.1:0.6];
add_taylordiag;  % create taylor diagram frame;
id = 1:Naf15;
text(mx(id,1),my(id,1),yy2(id),'color','k','fontsize',fs-3);
text(mx(id,2),my(id,2),yy2(id),'color',ctscolor,'fontsize',fs-3);
text(mx(end,1),my(end,1),yy2(end),'color','k','fontsize',fs,'fontweight','bold'); 
text(mx(end,2),my(end,2),yy2(end),'color',ctscolor,'fontsize',fs-0.5,'fontweight','bold');
text(0.05,0.73,plabels{5},'fontsize',fs,'fontweight','bold')
% add a legend
hp = patch([0.18 0.63 0.63 0.18],[0.02 0.02 0.145 0.145],'w');
set(hp,'edgecolor',ldpatch);
text(0.2,0.09,['all train (n=' num2str(sum(dt.flag==1)) ')'],'fontsize',fs-1,'fontweight','bold','hori','left','vert','bot','color','k');
text(0.2,0.03,['all test (n=' num2str(sum(dt.flag==2)) ')'],'fontsize',fs-1,'fontweight','bold','hori','left','vert','bot','color',ctscolor);

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
print('-dpng','-r500',ffig)
