% Create Figures S4 of 
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of two panels:
%   - learning curve plot
%   - sensitivity experiments of train-test splitting ratio
%
%         Author: Tianyu Zhou, UDel, Aug/25/2024
%         Modified by: Yun Li, UDel, Aug/25/2024
%                 Tianyu Zhou, UDel, Oct/17/2024
%                      Yun Li, UDel, Oct/19/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'figS4_RF_split_tuning'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx = 0.11; fgw = 0.39; fgdw = 0.41;
fgy = 0.25; fgh = 0.4;
fsize = 8;
xticks = 0.1:0.2:0.9; xlims = [0   1];
yticks = 0.6:0.05:1;  ylims = [0.6 1];
xticklables = [num2str(xticks'*100) repmat('%',[length(xticks) 1])];
c1 = 'b'; c2 = [0 0.5 0];  % curve color: 1=training; 2=validation

%####################################
%## load training and testing data ##
%####################################
load(fspl);
frac = spltest.frac;  % training data fraction
wrk_mean(1,:)=spltest.tr_mean; wrk_std(1,:)=spltest.tr_std; % training scores
wrk_mean(2,:)=spltest.ct_mean; wrk_std(2,:)=spltest.ct_std; % testing scores (testing = 10%)
wrk_mean(3,:)=spltest.ts_mean; wrk_std(3,:)=spltest.ts_std; % testing scores (testing can vary)

%####################################
%## training and validation curves ##
%####################################
for kp = 1:2 
  axes('Position',[fgx+(kp-1)*fgdw fgy fgw fgh]); hold on;
  p1=plot(frac,wrk_mean(1,:)   ,'-o','lineWidth',1.5,'color',c1,'markerfacecolor',c1,'markersize',4);  % training
  p2=plot(frac,wrk_mean(kp+1,:),'-o','lineWidth',1.5,'color',c2,'markerfacecolor',c2,'markersize',4);  % validation
  patch([frac flip(frac)],[wrk_mean(1,:)+wrk_std(1,:) flip(wrk_mean(1,:)-wrk_std(1,:))],...
        c1,'facealpha',0.15,'linestyle','none')
  patch([frac flip(frac)],[wrk_mean(kp+1,:)+wrk_std(kp+1,:) flip(wrk_mean(kp+1,:)-wrk_std(kp+1,:))],...
        c2,'facealpha',0.15,'linestyle','none')
  set(gca,'fontsize',fsize,'xaxislocation','top',...
        'xlim',xlims,'xtick',xticks,'xticklabel',xticklables,...
        'ylim',ylims,'ytick',yticks,'yticklabel',yticks); box on; grid on;
  ytickformat('%.2f');
  if kp==1; xlabel('Training data (% of total data pairs)','pos',[1.05 1.045 0],'fontsize',fsize+1);
            ylabel('Score','fontsize',fsize+1); 
  else;     set(gca,'yticklabel',''); end
  text(xlims(1)+0.05*diff(xlims),ylims(2)-0.05*diff(ylims),...
         plabels{kp},'fontweight','bold','fontsize',fsize,'horiz','left','vert','top')
end
legend([p1 p2],{'Training','Validation'},'position',[fgx+fgw-0.14 fgy+0.025 0.08 0.05])
% add a second horizontal axis for the testing data that can vary
ax = axes('Position',[fgx+(kp-1)*fgdw fgy fgw fgh]); 
set(gca,'color','none','fontsize',fsize,...
        'xlim',xlims,'xtick',xticks,'xticklabel',xticklables(end:-1:1,:),...
        'ylim',ylims,'ytick','')
xlabel('Testing data (% of total data pairs)','fontsize',fsize+1);

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
%print('-dpng','-r500',ffig)
