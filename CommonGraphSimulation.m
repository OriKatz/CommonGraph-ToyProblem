% clc;
% clear;
% close all;
addpath('Utils');

%% Parameters
% Data retrieval params
SnapshotsFolder='CamerasSnapshotsFolder';

% Preprocessing params
MaxVectorLength=5e4;
UseRandomProjection=1;
ProjectionLength=1.6e3;


% Algorithm params - Diffusion map(DM)
DM_numNeighbors_inSensor1 =-1; %-1 indicates taking the median value of the distance spectrum as the scale parameter for DM
DM_numNeighbors_inSensor2 =-1;
DM_numNeighbors_inSensor3 =-1;
DM_t = 1;

% Algorithm params - Alternating diffusion map(DM)
ADM_numNeighbors_inSensor1=-1;
ADM_numNeighbors_inSensor2=-1;
ADM_numNeighbors_inSensor3=-1;
ADM_t_inSensor1=1;
ADM_t_inSensor2=1;
ADM_t_inSensor3=1;
ADM_t_alternates=1;
ADM_numNeighbors=4;
ADM_t=1;

% algorithm params - CommonGraph (CG)
CG_numNeighbors=-1;
CG_t_alternates=4;
CG_t=4;

%% Data retrieval
disp(sprintf('Loading the snapshots from the folder'));
SnapshotsSensor1 = regexprep([SnapshotsFolder,'\s1_%d.jpg'],'\\','\\\\');
SnapshotsSensor2 =  regexprep([SnapshotsFolder,'\s2_%d.jpg'],'\\','\\\\');
SnapshotsSensor3 =  regexprep([SnapshotsFolder,'\s3_%d.jpg'],'\\','\\\\');

% calculation of the resize factor
N_images=1e3;
TmpPath = sprintf(SnapshotsSensor1,1);
TmpImage = double(imread(TmpPath));
ResizeFactor=sqrt(MaxVectorLength/length(TmpImage(:)));
if ResizeFactor>1
    ResizeFactor=1;
end
TmpImage = imresize(TmpImage, ResizeFactor); % Reshape into a vector
m = size(TmpImage, 1)*size(TmpImage,2);

% read images
Sensor1=zeros(N_images,m);
Sensor2=zeros(N_images,m);
Sensor3=zeros(N_images,m);
for ImageInd=1:N_images
    Sensor1ImagePath = sprintf(SnapshotsSensor1,ImageInd);
    Sensor2ImagePath = sprintf(SnapshotsSensor2,ImageInd);
    Sensor3ImagePath = sprintf(SnapshotsSensor3,ImageInd);
    % ignore colors, just for the illustration
    I1 = im2double(imread(Sensor1ImagePath));I1(I1<0)=0;I1(I1>1)=1;I1=sum(I1,3);I1=I1<2.5; I1=imresize(I1, ResizeFactor);
    I2 = im2double(imread(Sensor2ImagePath));I2(I2<0)=0;I2(I2>1)=1;I2=sum(I2,3);I2=I2<2.5; I2=imresize(I2, ResizeFactor);
    I3 = im2double(imread(Sensor3ImagePath));I3(I3<0)=0;I3(I3>1)=1;I3=sum(I3,3);I3=I3<2.5; I3=imresize(I3, ResizeFactor);
        
    Sensor1(ImageInd,:)=I1(:);
    Sensor2(ImageInd,:)=I2(:);
    Sensor3(ImageInd,:)=I3(:);
end
load([SnapshotsFolder,'\Angles']);

%% Preprocess data
if UseRandomProjection
    RandomMatrix=randn(ProjectionLength,size(Sensor1,2));
    Sensor1=Sensor1*RandomMatrix';
    Sensor2=Sensor2*RandomMatrix';
    Sensor3=Sensor3*RandomMatrix';
end
%% Standard diffusion map
disp(sprintf('Performing standard DM'));

D1= pdist2(Sensor1,Sensor1,'euclidean');
D2= pdist2(Sensor2,Sensor2,'euclidean');
D3= pdist2(Sensor3,Sensor3,'euclidean');


[s1_MapEmbd,~,~,s1_singvals]=DiffusionMapsFromDistance(D1,DM_t,DM_numNeighbors_inSensor1);
[s2_MapEmbd,~,~,s2_singvals]=DiffusionMapsFromDistance(D2,DM_t,DM_numNeighbors_inSensor2);
[s3_MapEmbd,~,~,s3_singvals]=DiffusionMapsFromDistance(D3,DM_t,DM_numNeighbors_inSensor3);

% figure();
% subplot(3,3,1); scatter(s1_MapEmbd(:,2),s1_MapEmbd(:,3),20,mod(Angles(1,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor1 \n (colored according to angle1)'));
% subplot(3,3,2); scatter(s1_MapEmbd(:,2),s1_MapEmbd(:,3),20,mod(Angles(2,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor1 \n (colored according to angle2)'));
% subplot(3,3,3); scatter(s1_MapEmbd(:,2),s1_MapEmbd(:,3),20,mod(Angles(3,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor1 \n (colored according to angle3)'));
% subplot(3,3,4); scatter(s2_MapEmbd(:,2),s2_MapEmbd(:,3),20,mod(Angles(1,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor2 \n (colored according to angle1)'));
% subplot(3,3,5); scatter(s2_MapEmbd(:,2),s2_MapEmbd(:,3),20,mod(Angles(2,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor2 \n (colored according to angle2)'));
% subplot(3,3,6); scatter(s2_MapEmbd(:,2),s2_MapEmbd(:,3),20,mod(Angles(3,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor2 \n (colored according to angle3)'));
% subplot(3,3,7); scatter(s3_MapEmbd(:,2),s3_MapEmbd(:,3),20,mod(Angles(1,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor3 \n (colored according to angle1)'));
% subplot(3,3,8); scatter(s3_MapEmbd(:,2),s3_MapEmbd(:,3),20,mod(Angles(2,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor3 \n (colored according to angle2)'));
% subplot(3,3,9); scatter(s3_MapEmbd(:,2),s3_MapEmbd(:,3),20,mod(Angles(3,1:N_images),180),'filled'); axis equal;
% title(sprintf('Standard DM according to sensor3 \n (colored according to angle3)'));

%% Alternating DM
disp(sprintf('Performing Alternating DM'));

[~, ~, K1]=SimpleDiffusion(D1,ADM_t_inSensor1,ADM_numNeighbors_inSensor1);
[~, ~, K2]=SimpleDiffusion(D2,ADM_t_inSensor2,ADM_numNeighbors_inSensor2);
[~, ~, K3]=SimpleDiffusion(D3,ADM_t_inSensor3,ADM_numNeighbors_inSensor3);

K=K3*K2; 
Kt=K^ADM_t_alternates;
ADM_d_t=pdist2(Kt',Kt','euclidean');

[ADM_MapEmbd,~,~,ADM_singvals]=DiffusionMapsFromDistance(ADM_d_t,ADM_t,ADM_numNeighbors);
% figure();
% subplot(1,3,1);scatter3(ADM_MapEmbd(:,2),ADM_MapEmbd(:,3),ADM_MapEmbd(:,4),20,mod(Angles(1,1:N_images),180),'filled');
% title(sprintf('Alternating DM between sensor2 and sensor3 \n (colored according to angle1)'));
% subplot(1,3,2);scatter3(ADM_MapEmbd(:,2),ADM_MapEmbd(:,3),ADM_MapEmbd(:,4),20,mod(Angles(2,1:N_images),180),'filled');
% title(sprintf('Alternating DM between sensor2 and sensor3 \n (colored according to angle2)'));
% subplot(1,3,3);scatter3(ADM_MapEmbd(:,2),ADM_MapEmbd(:,3),ADM_MapEmbd(:,4),20,mod(Angles(3,1:N_images),180),'filled');
% title(sprintf('Alternating DM between sensor2 and sensor3 \n (colored according to angle3)'));

%% Common Graph
disp(sprintf('Performing Common grpah'));

K12t = (K2*K1)^CG_t_alternates;
K21t = (K1*K2)^CG_t_alternates;
K13t = (K3*K1)^CG_t_alternates;
K31t = (K1*K3)^CG_t_alternates;
K23t = (K3*K2)^CG_t_alternates;
K32t = (K2*K3)^CG_t_alternates;


     
% results with much better embedding
[MapEmbd_12, UWighted_12, d_tau_12, singvals_12] = DiffusionMapsFromKer(K12t,ADM_t);
[MapEmbd_21, UWighted_21, d_tau_21, singvals_21] = DiffusionMapsFromKer(K21t,ADM_t);
[MapEmbd_13, UWighted_13, d_tau_13, singvals_13] = DiffusionMapsFromKer(K13t,ADM_t);
[MapEmbd_31, UWighted_31, d_tau_31, singvals_31] = DiffusionMapsFromKer(K31t,ADM_t);
[MapEmbd_23, UWighted_23, d_tau_23, singvals_23] = DiffusionMapsFromKer(K23t,ADM_t);
[MapEmbd_32, UWighted_32, d_tau_32, singvals_32] = DiffusionMapsFromKer(K32t,ADM_t);

[~,IX_12] = sort(singvals_12,'descend');
[~,IX_21] = sort(singvals_21,'descend');
[~,IX_13] = sort(singvals_13,'descend');
[~,IX_31] = sort(singvals_31,'descend');
[~,IX_23] = sort(singvals_23,'descend');
[~,IX_32] = sort(singvals_32,'descend');

CombinedSensor = [...
    MapEmbd_12(:,IX_12),...
    MapEmbd_21(:,IX_21),...
    MapEmbd_13(:,IX_13),...
    MapEmbd_31(:,IX_31),...
    MapEmbd_23(:,IX_23),...
    MapEmbd_32(:,IX_32)];


d_CG = pdist2(CombinedSensor,CombinedSensor,'euclidean');
[CG_MapEmbd, CG_UWighted, CG_d_t, CG_singvals] = DiffusionMapsFromDistance(d_CG,CG_t,CG_numNeighbors);
[~,IX_s] = sort(CG_singvals,'descend');

% figure();
% for SubInd=1:6
%     subplot(2,3,SubInd);
%     scatter3(CG_MapEmbd(:,IX_s(2)),CG_MapEmbd(:,IX_s(3)),CG_MapEmbd(:,IX_s(4)),20,mod(Angles(SubInd,1:N_images),180),'filled');
%     title(sprintf('Common Graph \n (colored according to angle%g)',SubInd));
%     axis tight;
%     grid off;
% end
% view(subplot(2,3,1,'Parent',gcf),[-43.5 -18.8]);
% view(subplot(2,3,2,'Parent',gcf),[-5.9 57.2]);
% view(subplot(2,3,3,'Parent',gcf),[14.1 54]);


