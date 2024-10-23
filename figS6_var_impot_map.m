% Create Figures S6 of
%    "Enhanced Net Community Production with Sea Ice Loss
%     in the Western Arctic Ocean Uncovered by
%     Machine-learning-based Mapping"
% by Zhou et al. The figure consists of 2 subpanels:
%   - Relative importance of predictors ranked by RF
%   - Map of dominant predictors from perturbation analysis
%  
%         Author: Tianyu Zhou, UDel, Aug/25/2024
%         Modified by: Yun Li, UDel, Aug/25/2024

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
ffig = [ffig_dir 'figS6_var_impot_map'];
%==========================================================
%#######################
%## figure properties ##
%#######################
fgx = 0.13; fgw = 0.37; fgdw = 0.42;
fgy = 0.25; fgh = 0.41;
fsize = 8;
% colors
cmap(1,:) = clscolor(1,:);     % green
cmap(2,:) = [178 223 138]/256; % bright green
cmap(3,:) = clscolor(3,:);     % orange
cmap(4,:) = clscolor(2,:);     % purple
cmap(5,:) = [254 255 153]/256; % yellow
cmap(6,:) = clscolor(4,:);     % blue
cmap(7,:) = [114 163 254]/256; % light pink

%###############
%## load data ##
%###############
% file info and predictor names
load(fmap); load(fobs);
xticklabels = out.ML.names; NP = length(xticklabels);
% find the most important predictor
wrk= abs(out.ML.pert_NCPstd(:,:,2:end) - out.ML.pert_NCPstd(:,:,1));
[~,idx] = max(wrk,[],3); idx = idx+1; % shift with baseline as 1
var_map = out.ML.pert_idpred(idx); var_map(maps.mask==0) = nan;
% evaluate the effects on the non-seasonal NCP changes
[NX,NY] = size(var_map);
for kv=1:length(out.ML.predictors)
  tmp(:,:,1  ) = out.ML.pert_NCPstd_nonsea(:,:,1);
  tmp(:,:,2:3) = out.ML.pert_NCPstd_nonsea(:,:,out.ML.pert_idpred==kv); % select runs
  tmp = reshape(tmp,[NX*NY,3]);       % reshape for spatial extraction
  tmp = mean(tmp(var_map==kv,:));     % regionally averaged std
  disp([out.ML.predictors{kv}, ...
	'  +20% => pertb ' num2str((tmp(2)./tmp(1)-1)*100,'%3.2f%%') ...
	', -20% => pertb ' num2str((tmp(3)./tmp(1)-1)*100,'%3.2f%%')]);
  clear tmp
end

%##################################
%## (a) RF predictor importance  ##
%##################################
axes('Position',[fgx+fgw*0.1 fgy+0.01 fgw*0.9 fgh+0.005]); hold on
for kp = 1:NP
   hb = bar(kp,out.ML.RF_importance(kp),'facecolor',cmap(kp,:));
end
ylabel('Relative importance','FontSize',fsize+1)
text(0.74,0.37,plabels{1},'FontSize',fsize,'FontWeight','bold','hori','left','vert','top')
set(gca,'fontsize',fsize, ...
    'xlim',[0 NP]+0.5,'xtick',1:NP,'xticklabel',xticklabels,...
    'ylim',[0 0.38], 'ytick',0:0.05:0.4,'YGrid','on'); box on;
xtickangle(0); ytickformat('%.2f')

%##########################################
%## (b) map of most important predictors ##
%##########################################
axes('position',[fgx+fgdw fgy fgw fgh])
m_proj('lambert','lon',[lon_str lon_end],'lat',[lat_str lat_end])
m_pcolor(maps.lon_ful,maps.lat_ful,var_map); shading flat; colormap(cmap); caxis([1 NP+1])
m_gshhs_l('patch',ldpatch,'linestyle','none');
m_grid('linest',':','linewidth',0.1,'Fontsize',fsize-2,'xtick',lonticks,'ytick',latticks)
text(-0.16,0.13,plabels{2},'FontSize',fsize,'FontWeight','bold','hori','left','vert','top')

%###################
%##  save figure  ##
%###################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
%print('-dpng','-r500',ffig)

