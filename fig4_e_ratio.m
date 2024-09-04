% Create Figure 4 of
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of
%   - 1 subpanel  of the e-ratio vs NPP diagram 
%   - 2 subpanels of yearly area extent above threshholds
%
%         Author: Tianyu Zhou, UDel, Apr/22/2024
%         Modified by: Yun Li, UDel, Apr/24/2024

clc; clear all; close all; info_params;
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'fig04_e_ratio_contrast'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx = 0.06; fgw = 0.38; fgdw = 0.45;
fgy = 0.30; fgh = 0.51; fgdh = 0.60;
fs = 7;

%##################
%##  Load data   ##
%##################
load(fmap);
NCP = reshape(maps.NCP,[411*411 Nally]); NCP(NCP<-1E6) = 0;
NPP = reshape(maps.NPP,[411*411 Nally]); NPP(NPP<-1E6) = 0;
owa = reshape(maps.owa,[411*411 Nally]); 

%##############################
%## Annual mean of NPP & NCP ##
%##############################
clear NCP_yr NPP_yr
for kc = 1:4
  gid = find(maps.cluster==kc); cnum = length(gid);
  NCP_yr(kc,:) = sum(NCP(gid,:))*cff_NCP2intNCP;
  NPP_yr(kc,:) = sum(NPP(gid,:))*cff_NCP2intNCP;
  owa_yr(kc,:) = sum(owa(gid,:))/1e6/1e4;  % 10^6 m^2=1 km^2; 10^4 order of magnitude
end
e_ratio = NCP_yr./NPP_yr;

%#####################
%## e-ratio vs NPP  ##
%#####################
%--------------------
% frame of the diagram 
%    x-axis: intNPP    y-axis: e-ratio    contours: intNCP
%--------------------
axes('Position',[fgx fgy fgw fgh]); hold on; box on;
set(gca,'fontsize',fs,...
        'yaxisloc','left','ylim',[0.07 0.5],'ytick',0.1:0.1:0.5,...
        'xaxisloc','bot' ,'xlim',[-1 22]);
xlabel('Net primary production _{int}NPP (Tg C)','fontsize',fs,'fontweight','bold');
ylabel('e-ratio','fontsize',fs,'fontweight','bold');
xx = 0.01:0.1:30; ee = 0:0.03:0.6; [xx,ee] = meshgrid(xx,ee);
NCP_cts = [0.1  0.4  1     2      3      5      7      9];
NCP_ctx = [1.1  4.9  9.5  15.1   19.5   20     20.2   20.5];
NCP_cty = [0.10 0.1  0.12  0.14  0.16   0.26   0.36  0.45];
NCP_ctr = [-80  -46  -30  -26    -22    -30    -35    -44];
[cc,hh] = contour(xx,ee,xx.*ee,NCP_cts,'color',[1 1 1]*0.8,'linewidth',0.5);
for kct = 1:length(NCP_cts)
  text(NCP_ctx(kct),NCP_cty(kct),[num2str(NCP_cts(kct),'%3.1f') ' Tg C'],...
       'fontsize',fs-2,'color',ldpatch,'rot',NCP_ctr(kct),'vert','mid','hori','cen');
end
text(3.8,0.36,'Export production _{int}NCP',...
       'fontsize',fs-1,'color',ldpatch,'rot',-82,'vert','mid','hori','cen');
text(-0.5,0.49,plabels{1},'FontSize',fs+1,'fontweight','bold','vert','top','hori','left');
%--------------------
% yearly data points 
%--------------------
for kc = 1:4   % sensitivty run 2003-2014
  plot(NPP_yr(kc,ally<2015),e_ratio(kc,ally<2015),'x',...
          'MarkerSize',fs-3,'MarkerEdgeColor',clscolor(kc,:),...
	  'MarkerFaceColor','none','linewidth',1.5)  % years before 2015
end
idaf15 = find(ally>=2015);
for kc = 1:4   % baseline run 2015-2021
  plot(NPP_yr(kc,idaf15),e_ratio(kc,idaf15),'o',...
          'MarkerSize',fs+1,'MarkerEdgeColor',[1 1 1]*0.5,...
	  'MarkerFaceColor',clscolor(kc,:))          % years after 2015
  text(NPP_yr(kc,idaf15),e_ratio(kc,idaf15),af15_yy,'fontsize',fs-2,...
          'FontWeight','norm','Hori','cen','Vert','mid','Color','w')
end

%##########################
%## area above threshold ##
%##########################
p = [0.5 0.75 0.9];   % threshold of quantiles
for kK=1:2
  if kK==1;
    wrk = NCP; desc = 'based on _{int}NCP';
    ref = quantile(wrk(:,idaf15)',p);
  elseif kK==2;
    wrk = NCP./NPP; desc = 'based on e-ratio';
    ref = quantile(NCP(:,idaf15)',p)./quantile(NPP(:,idaf15)',p);
  end
  for kp = 1:length(p);  % compute the total area above threshold
    tmp = (wrk>repmat(ref(kp,:)',[1 Nally])).*1.;
    tmp(maps.mask==0,:) = NaN; qua(:,kp) = squeeze(nansum(tmp))*36/1e4;
  end

  axes('Position',[fgx+fgdw fgy+fgdh*0.45*(2-kK) fgw+0.1 fgh*0.48]); hold on
  set(gca,'fontsize',fs,...
          'xlim',[2002.8 2021.2],'xtick',ally,'xticklabel','',...
          'ylim',[-5 100],'ytick',0:20:130); box on;  
  text(2003.3,96,plabels{kK+1},'FontSize',fs+1,'fontweight','bold','vert','top','hori','left');
  text(2004.8,94.9,desc,'FontSize',fs,'fontweight','bold','vert','top','hori','left');
  hp = patch([ally ally(end:-1:1)],[qua(:,1);qua(end:-1:1,3)]','k'); hold on;
  set(hp,'facecolor',[1 1 1]*0.95,'edgecolor','none');
  plot([bf15 2015],qua(1:13,2),'k--','linewidth',1.)
  plot(af15,qua(idaf15,2),'k-','linewidth',1.2)
end
ylabel('Area extent above threshold (10^4 km^2)',...
       'pos',[2001.5 100 1],'fontsize',fs,'fontweight','bold');
xlabel('year','fontsize',fs,'fontweight','bold');
set(gca,'xticklabel',ally_yy,'XTickLabelRotation',0);

%#################
%## save figure ##
%#################
%print('-dpng','-r500',ffig)
