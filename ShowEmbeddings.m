%% Standard DM

figure();
subplot(3,3,1); scatter(s1_MapEmbd(:,2),s1_MapEmbd(:,3),20,mod(Angles(1,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor1 \n (colored according to angle1)'));
subplot(3,3,2); scatter(s1_MapEmbd(:,2),s1_MapEmbd(:,3),20,mod(Angles(2,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor1 \n (colored according to angle2)'));
subplot(3,3,3); scatter(s1_MapEmbd(:,2),s1_MapEmbd(:,3),20,mod(Angles(3,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor1 \n (colored according to angle3)'));
subplot(3,3,4); scatter(s2_MapEmbd(:,2),s2_MapEmbd(:,3),20,mod(Angles(1,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor2 \n (colored according to angle1)'));
subplot(3,3,5); scatter(s2_MapEmbd(:,2),s2_MapEmbd(:,3),20,mod(Angles(2,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor2 \n (colored according to angle2)'));
subplot(3,3,6); scatter(s2_MapEmbd(:,2),s2_MapEmbd(:,3),20,mod(Angles(3,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor2 \n (colored according to angle3)'));
subplot(3,3,7); scatter(s3_MapEmbd(:,2),s3_MapEmbd(:,3),20,mod(Angles(1,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor3 \n (colored according to angle1)'));
subplot(3,3,8); scatter(s3_MapEmbd(:,2),s3_MapEmbd(:,3),20,mod(Angles(2,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor3 \n (colored according to angle2)'));
subplot(3,3,9); scatter(s3_MapEmbd(:,2),s3_MapEmbd(:,3),20,mod(Angles(3,1:N_images),180),'filled'); axis equal;
title(sprintf('Standard DM according to sensor3 \n (colored according to angle3)'));

%% Alternating DM between sensor2 and sensor3
figure();
subplot(1,3,1);scatter3(ADM_MapEmbd(:,2),ADM_MapEmbd(:,3),ADM_MapEmbd(:,4),20,mod(Angles(1,1:N_images),180),'filled');
title(sprintf('Alternating DM between sensor2 and sensor3 \n (colored according to angle1)'));
subplot(1,3,2);scatter3(ADM_MapEmbd(:,2),ADM_MapEmbd(:,3),ADM_MapEmbd(:,4),20,mod(Angles(2,1:N_images),180),'filled');
title(sprintf('Alternating DM between sensor2 and sensor3 \n (colored according to angle2)'));
subplot(1,3,3);scatter3(ADM_MapEmbd(:,2),ADM_MapEmbd(:,3),ADM_MapEmbd(:,4),20,mod(Angles(3,1:N_images),180),'filled');
title(sprintf('Alternating DM between sensor2 and sensor3 \n (colored according to angle3)'));


%% Common Graph

figure();
for SubInd=1:6
    subplot(2,3,SubInd);
    scatter3(CG_MapEmbd(:,IX_s(2)),CG_MapEmbd(:,IX_s(3)),CG_MapEmbd(:,IX_s(4)),20,mod(Angles(SubInd,1:N_images),180),'filled');
    title(sprintf('Common Graph \n (colored according to angle%g)',SubInd));
    axis tight;
    grid off;
end
view(subplot(2,3,1,'Parent',gcf),[-43.5 -18.8]);
view(subplot(2,3,2,'Parent',gcf),[-5.9 57.2]);
view(subplot(2,3,3,'Parent',gcf),[14.1 54]);
