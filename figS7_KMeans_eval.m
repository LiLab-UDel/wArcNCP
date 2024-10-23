% Create Figures S7 of 
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of 1 panel: 
%   - Elbow and Silhouette curves for different clusters
%
%         Author: Tianyu Zhou, UDel, Aug/25/2024
%         Modified by: Yun Li, UDel, Aug/25/2024

clear; clc; close all; info_params
%===============================================
% edit the following based on user's needs
ffig = [ffig_dir 'figS7_KMeans_eval'];
%===============================================
%###############
%## Load data ##
%###############
load(fKMs);
ik_max = size(KM.cluster,3);         % number of clusters tested
idd = find(~isnan(KM.dista(:,:,1))); % non-land pixels
NCP = KM.NCP_clm;                    % climatological 8-day NCP
[NX,NY,NT] = size(NCP);
NCP = reshape(NCP,[NX*NY NT]); NCP = NCP(idd,:);

%#######################
%## KMeans evaluation ##
%#######################
for ik = 1:ik_max
    a = KM.dista(:,:,ik); a = a(idd); % distance to cluster centriod
    b = KM.distb(:,:,ik); b = b(idd); % distance to neighbor centriod
    cls = KM.cluster(:,:,ik); cls = cls(idd); % cluster label
    for icls = unique(cls)'
        NCP_ct_tmp = median(NCP(cls==icls,:),1);
        NCP_ct(cls==icls,:) = repmat(NCP_ct_tmp,[sum(cls==icls) 1]);
    end
    silh_tmp = (b-a)./max([b,a],[],2);
    silh(ik) = median(silh_tmp);
    var_uep(ik) = sum((NCP - NCP_ct).^2,'all');  % unexplained variance
end
var_pct = 100*(var_uep(1)-var_uep)...
	    ./(var_uep(1)-var_uep(end));         % relative contribution 

%###############################
%## elbow and Silhouette plot ##
%###############################
yyaxis left
colors = lines(2);
plot(1:ik_max,var_pct,'-o','markerfacecolor',[0 0.447 0.741],'linewidth',2)
xlabel('Number of clusters')
ylabel('Relative contribution to variance (%)')
set(gca,'fontsize',12,...
	'xlim',[2 ik_max],'xtick',1:ik_max,...
	'ylim',[65 100])
yyaxis right
plot(1:ik_max,silh,'-o','markerfacecolor',[0.85 0.325 0.098],'linewidth',2)
ylabel('Median Silhouette Coefficient')
set(gca,'fontsize',12,...
	'xlim',[2 ik_max],'xtick',1:ik_max)

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
%print('-dpng','-r500',ffig)
