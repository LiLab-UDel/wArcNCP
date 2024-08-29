% Create Figures S1 and S2 of 
%    "The Responses of Net Community Production to
%     Sea ice Reduction in the Western Arctic Ocean"
% by Zhou et al. The figure consists of 8 subpanels:
%   - 7 subpanels of time series of SSS or SST
%   - 1 subpanel  of 1:1 data density plot
%
%         Author: Tianyu Zhou, Aug/25/2024
%         Modified by: Yun Li, UDel, Aug/25/2024

clc; clear; close all; info_params
%=============================================
% Edit the following based on user's purpose
var = 'SSS';  % 'SSS' or 'SST'
ffig = [ffig_dir 'figS1S2_',var,'_match'];
%=============================================
%#######################
%## figure properties ##
%#######################
fgx = 0.07; fgw = 0.27;  fgdw = 0.30;
fgy = 0.6;  fgh = 0.155; fgdh = 0.205;
fsize = 7;
tticks = 1:8:366; % time ticks of 8-day bins
tticklabels = datestr(tticks,'mm-dd');
cticklabels = [1 10 100]; load(fcmap_TSdens)  % colorbar

%###############
%## load data ##
%###############
load(fobs); obs = out.obs;
id_ML = find(~isnan(obs.flag));    % data for machine learning
obs  = obs(id_ML,:);
% sort 2017 cruises
idd  = find(year(obs.date)==2017);
idd2 = [idd(obs.lat(idd)>73);idd(obs.lat(idd)<73)];
obs(idd,:) = obs(idd2,:); clear idd idd2
% time info
time = datenum(obs.date)';
yrs  = year(obs.date)';
time(abs(diff(time))>=1) = nan;   % add nan when obs stops (for plotting only)

%############################
%## prepare for comparison ##
%############################
% var-dependent figure params
switch var
  case{'SSS'}
  X = obs.iSSS; Y = obs.SSS;
  vlabel = 'ECCO2'; vunit = '';
  ylims = [24 35.5]; yticks = [20:3:40];              % time series params
  vlims = [22 36.0]; vticks = [23:2:35]; dbin = 0.15; % 1:1 plot params
  % correct SSS shift
  dSSS = 1.5; X(yrs==2018) = X(yrs==2018)+dSSS;
  udwy.nams{udwy.yrs==2018} = [udwy.nams{udwy.yrs==2018} ' (+' num2str(dSSS) ')'];
  dSSS = 2.8; X(yrs==2020) = X(yrs==2020)+dSSS;
  udwy.nams{udwy.yrs==2020} = [udwy.nams{udwy.yrs==2020} ' (+' num2str(dSSS) ')'];
  case{'SST'}
  X = obs.iSST; Y = obs.SST;
  vlabel = 'OISST'; vunit = '^oC';
  ylims = [-6 18]; yticks = [-4:6:20];
  vlims = [-4 15]; vticks = [-2:3:13]; dbin = 0.20;
end

% calculate stats
[r,p] = corr(X,Y);                        % linear correlation
rmsd = sqrt(sum((X-Y).^2)./length(X));    % root mean squared diff
std_obs = std(X);                         % standard deviation of obs

% data density
bins = [vlims(1):dbin:vlims(end)];        % bins for data density plot
[XI,YI,DENS] = fun_diag11_dens(X,Y,bins); % count data density per bin
DENS(DENS==0) = NaN; DENS = log10(DENS);

%############################
%## (a-g) plot time series ##
%############################
ic = 1;   % cruise index of underway measurements
for ky = 1:length(af15)
   yr = af15(ky); yref = datenum(yr,1,1)-1;
   tlims = time(yrs==yr);
   tlims = floor(([min(tlims) max(tlims)-1]-yref)./8)+[1 2];
   tlims = tticks(tlims)+yref+[-1 1];
   axes('pos',[fgx+floor((ky-1)/3)*fgdw fgy-mod(ky-1,3)*fgdh-2*(ky==7)*fgdh fgw fgh]);
   hold on; grid on; box on
   p1 = plot(time,X,'color',cmap(50,:));
   p2 = plot(time,Y,'color','k');
   % settings 
   set(gca,'xticklabelrotation',0,'fontsize',fsize,...
       'xlim',tlims,'xtick',tticks+yref,'xticklabel',tticklabels(:,2:end),...
       'ylim',ylims,'ytick',yticks)
   text(tlims(1)+diff(tlims)*0.02,ylims(2)-0.05*diff(ylims),...
       [plabels{ky},' ',num2str(yr)],...     % panel label
       'horiz','left','vert','top','fontsize',fsize+1,'fontweight','bold')
   text(tlims(2)-diff(tlims)*0.05,ylims(1)+0.02*diff(ylims),...
       ['n = ' num2str(sum(yrs==yr))],...    % number of data
       'horiz','right','vert','bot','fontsize',fsize)
   if ky==2
     ylabel([var vunit],'fontsize',fsize+1)
     hl = legend([p1 p2],{'underway',vlabel},...
       'position',[fgx+fgdw fgy+fgdh-0.02 0.25 0.03],...
       'box','off','orientation','hori','fontsize',fsize+1);
   end
   if ky>3; set(gca,'yticklabel',''); end
   % add cruise name
   text(tlims(2)-0.02*diff(tlims),ylims(2)-0.02*diff(ylims),udwy.nams{ic},...
	  'color',cmap(50,:),'fontsize',fsize-1,...
	  'horiz','right','vert','top'); ic=ic+1;
   if yr==2017
   text(tlims(2)-0.02*diff(tlims),ylims(1)+0.45*diff(ylims),udwy.nams{ic},...
          'color',cmap(50,:),'fontsize',fsize-1,...
          'horiz','right','vert','bot'); ic=ic+1;
   end
end

%###############################
%## (h) 1:1 data density plot ##
%###############################
axes('pos',[fgx+2*fgdw fgy-fgdh fgw fgh+fgdh]); hold on
pcolor(XI,YI,DENS); shading flat
plot(vlims,vlims,'-k','linewidth',0.5)         % 1:1 line
plot(vlims,vlims+std_obs,':k','linewidth',0.3) % +1*std
plot(vlims,vlims-std_obs,':k','linewidth',0.3) % -1*std
text(vlims(2)-0.05*diff(vlims),vlims(1)+0.05*diff(vlims),...
       {['n = ' num2str(length(X))],...        % stats
        ['RMSD = ' num2str(rmsd,'%.2f')],...
        ['R = ' num2str(r,'%.2f')]},...
         'fontsize',fsize,'horiz','right','vert','bot')
text(vlims(1)+diff(vlims)*0.02,vlims(2)-0.05*diff(vlims),...
        [plabels{ky+1},' ',var,' comparison'],... % panel label
         'horiz','left','vert','top','fontsize',fsize+1,'fontweight','bold')
set(gca,'fontsize',fsize,...
        'xlim',vlims,'xtick',vticks,'xticklabelrot',0,...
        'ylim',vlims,'ytick',vticks,'yaxisloc','right'); grid on; box on
xlabel('Underway','fontsize',fsize-0.3,'pos',[mean(vlims),vlims(1)-0.07*diff(vlims)])
ylabel(vlabel,'fontsize',fsize-0.3);
% colorbar settings
colormap(cmap); caxis(log10(cticklabels([1 end])))
c = colorbar('horiz','position',[fgx+2*fgdw fgy+fgdh-0.02 fgw 0.025]);
set(c,'xtick',log10(cticklabels),'xticklabel',cticklabels)
text(vlims(1),vlims(2)+0.25*diff(vlims),...     % colorbar title
	['Number of data in ',num2str(dbin),' x ',num2str(dbin),vunit,' bin'],...
        'fontsize',fsize,'horiz','left','vert','bot')

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
print('-dpng','-r500',ffig)
