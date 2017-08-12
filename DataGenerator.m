% clc;
% clear;
disp(sprintf('Generating snapshots'));

%% Parameters
NumberOfSensors=3;
% ImagePaths={'Linux.jpg','Apple.jpg','Android.jpg','FreeBSD.jpg','2Face.jpg','Windows.jpg'};
ImagePaths={'Arrow.jpg','Arrow.jpg','Arrow.jpg','Arrow.jpg','Arrow.jpg','Arrow.jpg'};

% Set arrows Colors
ImageColors={[1,0,0],[0,1,0],[0,0,1],[1,0.6,0],[0.5,0,0.9],[0.8,0.8,0.8]}; %R, G, B, orange, purple, gray

% Set random angles
NumberOfAngles=1e3;
Angles=mod(180*(rand(length(ImagePaths),NumberOfAngles)),360); %random angles ~U[0,Pi]
%figure(); hist(Angles(:),1e2)
SnapshotsFolder=sprintf('CamerasSnapshotsFolder');

%% Load images
NumbeOfImages=length(ImagePaths);
resize_fac=1;
ImagesCell=cell(1,NumbeOfImages);
for ind=1:NumbeOfImages
    ImagesCell{ind}=imresize(imread(ImagePaths{ind}),resize_fac);
end

%% Color images
for ind=1:NumbeOfImages
    NonWhiteInds=unique([...
        find(ImagesCell{ind}(:,:,1)<=200);...
        find(ImagesCell{ind}(:,:,2)<=200);...
        find(ImagesCell{ind}(:,:,3)<=200)]);
    
    tmpImageR=ImagesCell{ind}(:,:,1);tmpImageR(NonWhiteInds)=255*ImageColors{ind}(1);
    tmpImageG=ImagesCell{ind}(:,:,2);tmpImageG(NonWhiteInds)=255*ImageColors{ind}(2);
    tmpImageB=ImagesCell{ind}(:,:,3);tmpImageB(NonWhiteInds)=255*ImageColors{ind}(3);
    
    ImagesCell{ind}=cat(3, tmpImageR, tmpImageG, tmpImageB);%figure();image(ImagesCell{ind});
end

%% Rotate and save to snapshots folder
if ~exist(SnapshotsFolder,'dir')
%     delete(SnapshotsFolder);
    mkdir(SnapshotsFolder);
end


for AngleInd = 1 : NumberOfAngles
    CurrSnapshotsCell=cell(size(ImagesCell));
    for ImageInd=1:NumbeOfImages
        CurrImage=ImagesCell{ImageInd};
        [m, n, ~] = size(CurrImage);
        RotatedImage=imrotate(CurrImage,Angles(ImageInd,AngleInd),'crop');
        Mask = ones(size(CurrImage)) * 255;
        RotatedMask = imrotate(Mask,Angles(ImageInd,AngleInd),'crop');
        Ind = find(RotatedMask(:,:,1) == 0 & RotatedMask(:,:,2) == 0 & RotatedMask(:,:,3) == 0);
        RotatedImage(Ind) = 255;
        RotatedImage(Ind+ m*n) = 255;
        RotatedImage(Ind+ 2*m*n) = 255;
        CurrSnapshotsCell{ImageInd}=RotatedImage;
    end
  
    Sensor1 = [CurrSnapshotsCell{1}, CurrSnapshotsCell{2},CurrSnapshotsCell{4}];
    Sensor2 = [CurrSnapshotsCell{2},CurrSnapshotsCell{3},CurrSnapshotsCell{5}];
    Sensor3 = [CurrSnapshotsCell{3},CurrSnapshotsCell{1},CurrSnapshotsCell{6}];
    
    
    for sensor_inds=1:NumberOfSensors
        str=[pwd,'\',SnapshotsFolder,'\',sprintf('s%d_%d.jpg',sensor_inds,AngleInd)];
        eval(sprintf('imwrite(Sensor%g,str,''jpg'')',sensor_inds));
    end
end
save([pwd,'\',SnapshotsFolder,'\Angles.mat'],'Angles');
disp(sprintf('Finished generating snapshots. Snapshots were saved to ''%s''',[pwd,'\',SnapshotsFolder]));

