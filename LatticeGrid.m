
close all; clear; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

step=20;

    Xmin=-180;
    Xmax=+180;
    
        Xi=(Xmin:1/step:Xmax)';
    
    Ymin=-90;
    Ymax=+90;

        Yi=(Ymin:0.5/step:Ymax)';

string=length(Yi);
newOne=ones(string,1);
totalVector=string^2;
latticeX=zeros(totalVector,1);
latticeY=zeros(totalVector,1);

for i=1:string
    b=mod(i,100);
    if b==0
    disp(i);
    end
    latticeX(i*string-string+1:i*string,1)=newOne.*Xi(i,1);
    latticeY(i*string-string+1:i*string,1)=Yi;
end

Lattice=cat(2,latticeX,latticeY);

save('Lattice.mat','Lattice','-v7.3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[120,60,1420,780],'Color','w'); hold on;
scatter(Lattice(:,1),Lattice(:,2),0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
