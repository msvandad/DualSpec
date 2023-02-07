% 8/25/20
% Revised to Calculate Wavelength

clear all; 

%MASTER_CODE
set(0,'DefaultFigureWindowStyle','docked')
P = imread('Photo_8.jpg');
Gray = rgb2gray(P);
 
%Horizontal Boundaries of ROI's
start = 1800;
width = 600;
 
%Vertical Boundaries of ROI's 
sample_start = 1300;
%Distance between sample spectrum and blank spectrum
offset = 320;
blank_start = sample_start+offset;
height = 140;
 
figure(1);clf;
image(P);
 
slim = [sample_start  sample_start+height  start start+width];
blim = [blank_start blank_start+height start start+width];
  
Sample = Gray(slim(1):slim(2),slim(3):slim(4),:);
Blank = Gray(blim(1):blim(2),blim(3):blim(4),:);
 
figure(2);clf;
subplot(2,1,1);
image(Sample);
subplot(2,1,2);
image(Blank);
 
%Calculate Intensity vs Pixel and convert data to double
Isample = 0.95*im2double(mean(Sample));
Iblank = im2double(mean(Blank));
%create X-axis 
pxl = 1:length(Isample);

%Baseline Correction
slope = (Isample(end)-Isample(1))./(pxl(end)-pxl(1));
yinter = Isample(1);
bsamp = slope*pxl+yinter; %sample baseline corection


slope = (Iblank(end)-Iblank(1))./(pxl(end)-pxl(1));
yinter = Iblank(1);
bblank = slope*pxl+yinter;
 
figure(3);clf;
plot(pxl,Isample,'r');hold on;
plot(pxl,Iblank,'b');hold on;
title('Intensity vs. Pixel Number');
xlabel('Pixel Number');
ylabel('Intensity');
 
%Absorbance Calculations
S = Isample-bsamp;
B = Iblank-bblank;
Ab = -log10(S./B);
    %corrected 
SBdiff = S-B;
dscale = 1;
Sc = dscale*SBdiff-S;
Abc = -log10(Sc./B);

%Pixel to waveLength conversion (Fluorescence Calibration)
SWavelength = (pxl*0.442585242)+393.9378635;
BWavelength = (pxl*0.437931524)+403.4663786;

figure(4);clf;
plot(pxl,Ab,'r'); hold on;
plot(pxl,Abc,'b'); hold on;
title('Absorbance vs. Pixel Number');
xlabel('Pixel Number');
ylabel('Absorbance');

figure(5);clf;
plot(SWavelength,Isample,'r');hold on;
plot(BWavelength,Iblank,'b');hold on;
title('Intensity vs. Wavelength');
xlabel('Wavelength (nm)');
ylabel('Intensity');
xlim([390,675])
 
figure(6);clf;
plot(SWavelength,Ab,'r'); hold on;
plot(BWavelength,Abc,'b'); hold on;
title('Absorbance vs. Wavelength');
xlabel('Wavelength (nm)');
ylabel('Absorbance');
xlim([390,675]);

