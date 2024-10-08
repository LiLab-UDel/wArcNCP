% Create Figures S3 of 
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of 1 panel:
%   - sensitivity experiments of training-testing 
%     splitting ratio
%
%         Author: Tianyu Zhou, UDel, Aug/25/2024
%         Modified by: Yun Li, UDel, Aug/25/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'figS3_RF_split_tuning'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx = 0.18; fgw = 0.7;
fgy = 0.15; fgh = 0.7;
fsize = 12;
xticks = 0.1:0.2:0.9;

%####################################
%## load training and testing data ##
%####################################
load(fspl);
frac = spltest.frac;  % training data fraction
tr_mean = spltest.tr_mean; tr_std = spltest.tr_std; % training scores
ts_mean = spltest.ts_mean; ts_std = spltest.ts_std; % testing scores

%###############################
%## score vs split ratio plot ##
%###############################
xticklables_tr = [num2str(   xticks' *100) repmat('%',[length(xticks) 1])];
xticklables_ts = [num2str((1-xticks)'*100) repmat('%',[length(xticks) 1])];
% testing
ax1 = axes('Position',[fgx fgy fgw fgh]); hold on; grid on
plot(frac,ts_mean,'-o','LineWidth',2,'Color',[0 0.5 0],'markerfacecolor',[0 0.5 0])
patch([frac flip(frac)],[ts_mean+ts_std flip(ts_mean-ts_std)],...
    [0 0.5 0],'facealpha',0.15,'linestyle','none')
xlabel('Testing data (% of total data pairs)','color',[0 0.5 0],'FontWeight','bold')
ylabel('Score','FontWeight','bold')
set(gca,'fontsize',fsize,'xcolor',[0 0.5 0],...
	'xlim',[0   1],'XTick',xticks,'Xticklabel',xticklables_ts,...
	'ylim',[0.6 1],'YTick',0.6:0.05:1)
% training
ax2 = axes('Position',[fgx fgy fgw fgh]); hold on
plot(frac,tr_mean,'-o','LineWidth',2,'Color','b','markerfacecolor','b')
patch([frac flip(frac)],[tr_mean+tr_std flip(tr_mean-tr_std)],...
   'b','facealpha',0.15,'linestyle','none')
xlabel('Training data (% of total data pairs)','color','b','FontWeight','bold')
set(gca,'XAxisLoc','top','YAxisLoc','right','Color','none','fontsize',fsize,...
        'xlim',[0   1],'xtick',xticks,'Xticklabel',xticklables_tr,'xcolor','b',...
        'ylim',[0.6 1],'YTick',0.6:0.05:1,'YTicklabel','')

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
%print('-dpng','-r500',ffig)
