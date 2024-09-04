% create a self-designed partial taylor diagram
%                       Yun Li, UDel, Apr-26-2024

%######################################
%## create STD, RMS and COR contours ##
%######################################
wrk = linspace(mSTD(1),mSTD(end),30);
[xx,yy] = meshgrid(wrk,wrk);
xySTD = abs(complex(xx,yy));
xyCOR = cos(angle(complex(xx,yy)));
xyRMS = abs(complex(xx-1,yy));
id = find(xySTD > mSTD(end)+eps | xyCOR<mCOR(1)-eps);
xx(id) = NaN; yy(id) = NaN;
contour(xx,yy,xySTD,mSTD,'color',talcolor,'linewidth',0.2); hold on;
contour(xx,yy,xyRMS,mRMS,'--','color',talcolor,'linewidth',0.2);
%contour(xx,yy,xyCOR,mCOR,'k','linewidth',0.5); % straight lines become curved
for kc = 2:length(mCOR)
  plot([0 mSTD(end)*mCOR(kc)],[0 mSTD(end)*sin(acos(mCOR(kc)))],'color',talcolor,'linewidth',0.2); 
end
axis equal; 

%#########################
%##  Outline the frame  ##
%#########################
plot(wrk,wrk*0,'k','linewidth',1.2); 
plot([0 mSTD(end)*mCOR(1)],[0 mSTD(end)*sin(acos(mCOR(1)))],'k','linewidth',1.2); 
theta = linspace(0,acos(mCOR(1)),30);
plot(cos(theta),sin(theta),'k','linewidth',1.2);
plot(mSTD(end).*cos(theta),mSTD(end).*sin(theta),'k','linewidth',0.5);
plot(1,0,'ko','markersize',2,'markerfacecolor','k');

%###################
%#   add labels   ##
%###################
text(0.35,0.44.*tan(acos(mCOR(1))),'Normalized Standard Deviation nSTD',...
	'fontsize',fs,'rot',45.7,'vert','bot','hori','cen')
text(0.97,0.97.*tan(acos(0.85)),'Correlation',...
	'fontsize',fs,'rot',-60,'vert','mid','hori','cen')
text(1.09,1.09.*tan(acos(0.955)),'Coefficient R',...
	'fontsize',fs,'rot',-72,'vert','mid','hori','cen')
text(0.65,0.8.*tan(acos(0.852)),'ncRMSD=0.6',...
        'fontsize',fs-2,'rot',38,'vert','bot','hori','cen','color',talcolor)
text(0.72,0.8.*tan(acos(0.89)),'ncRMSD=0.5',...
        'fontsize',fs-2,'rot',36,'vert','bot','hori','cen','color',talcolor)
text(0.76,0.8.*tan(acos(0.929)),'ncRMSD=0.4',...
        'fontsize',fs-2,'rot',35,'vert','bot','hori','cen','color',talcolor)
for kc = 1:length(mCOR)
  text(1.07*mCOR(kc),1.07.*sin(acos(mCOR(kc))),num2str(mCOR(kc)),...
	'fontsize',fs-1,'rot',acos(mCOR(kc))/pi*180-90,'vert','mid','hori','cen')
end
set(ax,'fontsize',fs-1,'box','off','xtick',mSTD(1:end-1),'ycolor','none');
wrk = get(ax,'xticklabel');
text(mSTD(2:end-2)*mCOR(1),mSTD(2:end-2).*sin(acos(mCOR(1))),wrk(2:end-1),...
        'fontsize',fs-1,'rot',acos(mCOR(1))/pi*180,'vert','bot','hori','cen')
wrk{end} =''; set(ax,'xticklabel',wrk)
text(1,-0.01,'ref','fontsize',fs+1,'fontweight','bold','horiz','cen','vert','top');



