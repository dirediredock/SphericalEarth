
% By Matias I. Bofarull Oddo - June 12th, 2021

close all; clear; clc; radiusEarth=6371;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   COLLECTION      MODIS/Terra+Aqua Photosynthetically Active Radiation
%                   Daily/3-Hour L3 Global 0.05Deg CMG V061
%
%   FILE            MCD18C2.A2021120.061.2021140165555.hdf
%
%   START           2021-04-30 00:00:00
%   END2            021-04-30 23:59:59

info=hdfinfo('MCD18C2.A2021120.061.2021140165555.hdf');
info.Vgroup.Vgroup(1).SDS.Name;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A00=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_0000_PAR');
A03=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_0300_PAR');
A06=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_0600_PAR');
A09=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_0900_PAR');
A12=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_1200_PAR');
A15=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_1500_PAR');
A18=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_1800_PAR');
A21=hdfread('MCD18C2.A2021120.061.2021140165555.hdf','GMT_2100_PAR');

XYZ1=vectorizeArray(A00);
XYZ2=vectorizeArray(A03);
XYZ3=vectorizeArray(A06);
XYZ4=vectorizeArray(A09);
XYZ5=vectorizeArray(A12);
XYZ6=vectorizeArray(A15);
XYZ7=vectorizeArray(A18);
XYZ8=vectorizeArray(A21);

XYZ=cat(3,XYZ1,XYZ2,XYZ3,XYZ4,XYZ5,XYZ6,XYZ7,XYZ8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load Lattice.mat;

        index=1:length(Lattice);
        index=randsample(index,999999);
        Lattice=Lattice(index,:);

load borderdata.mat

        Lines=[];

        for k=1:246

            lon=borderdata.lon{k};
            lat=borderdata.lat{k};

            lon=cat(2,lon,NaN);
            lat=cat(2,lat,NaN);
            line=cat(2,lon',lat');

            Lines=cat(1,Lines,line);
        end
        
ArcLine=(-180:1:180)';
ArcLine=cat(2,ArcLine,zeros(length(ArcLine),1));
        
        radX=deg2rad(Lines(:,1));
        radY=deg2rad(Lines(:,2));
        [iX,iY,iZ]=sph2cart(radX,radY,radiusEarth);

        radX=deg2rad(ArcLine(:,1));
        radY=deg2rad(ArcLine(:,2));
        [arcX,arcY,arcZ]=sph2cart(radX,radY,8000);
        
        radX=deg2rad(Lattice(:,1));
        radY=deg2rad(Lattice(:,2));
        [Xdark,Ydark,Zdark]=sph2cart(radX,radY,6300);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frames=1:1:361;
nImages=length(frames);

count=1;

fig=figure('Position',[120,60,800,800]); hold on;

for idx=1:nImages
    
    for i=idx
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START OF IMAGE PLOTTING
        
        

            n=(i-1)*-1
            
            set(gca,'CameraViewAngleMode','manual'); hold on;
           
            view(n,30); colormap(inferno);

            plot3(iX,iY,iZ,'w');
            scatter3(Xdark,Ydark,Zdark,0.2,'k');

            plot3(arcX,arcY,arcZ,'c');
            plot3(arcY,arcZ,arcX,'c');

                if mod(i,8)==0
                    count=0;
                end
                
                count=count+1;
                disp(count);

                    V=squeeze(XYZ(:,:,count));
                    V(any(isnan(V),2),:)=[];
                    colorspace=V(:,3);
                    radX=deg2rad(V(:,1));
                    radY=deg2rad(V(:,2));
                    [Vx,Vy,Vz]=sph2cart(radX,radY,radiusEarth);
                    V=cat(2,Vx,Vy,Vz);

                    scatter3(V(:,1),V(:,2),V(:,3),1,colorspace,'filled');
            
            axis off; axis tight;
            set(gcf,'Color','k');
            

            
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF IMAGE PLOTTING
    
    end
    
    drawnow
    
    frame=getframe(fig);
    im{idx}=frame2im(frame);
    
    clf;
    clf(fig,'reset');
    
end

close;

filename='SphericalSpinPAR.gif';

for GIFidx=1:nImages-1
    
    [A,map]=rgb2ind(im{GIFidx},256);
    
    if GIFidx==1
        imwrite(A,map,filename,'gif','LoopCount',Inf, ...
            'DelayTime',0.09);
    else
        imwrite(A,map,filename,'gif','WriteMode','append', ...
            'DelayTime',0.09);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Vector=vectorizeArray(Array)
    
    Array=flipud(Array);

    [height,width]=size(Array);
    [x,y]=meshgrid(1:width,1:height);
    cloud=[x(:),y(:),Array(:)];

    X=(cloud(:,1)/20)-180;
    Y=(cloud(:,2)/20)-90;
    N=cloud(:,3);
    N(N<=0)=NaN;

    Vector=cat(2,X,Y,N);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
