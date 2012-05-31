%montage64largelaplacian()
%   expects input from read_eep_cnt()
%
%   Large Laplacian Montage definition of the ANT WaveGuard Cap, 10-5 system.
%   Reference electrode = Mean of M1 & M2
%
%   Written by: Rens Verhagen 2010

function [EEG]=EEGmontageFZ(eeg)
% define electrodes
FP1=eeg(1,:);
FPZ=eeg(2,:);
FP2=eeg(3,:);
F7=eeg(4,:);
F3=eeg(5,:);
FZ=eeg(6,:);
F4=eeg(7,:);
F8=eeg(8,:);
FC5=eeg(9,:);
FC1=eeg(10,:);
FC2=eeg(11,:);
FC6=eeg(12,:);
M1=eeg(13,:);
T7=eeg(14,:);
C3=eeg(15,:);
CZ=eeg(16,:);
C4=eeg(17,:);
T8=eeg(18,:);
M2=eeg(19,:);
CP5=eeg(20,:);
CP1=eeg(21,:);
CP2=eeg(22,:);
CP6=eeg(23,:);
P7=eeg(24,:);
P3=eeg(25,:);
PZ=eeg(26,:);
P4=eeg(27,:);
P8=eeg(28,:);
POZ=eeg(29,:);
O1=eeg(30,:);
OZ=eeg(31,:);
O2=eeg(32,:);
AF7=eeg(33,:);
AF3=eeg(34,:);
AF4=eeg(35,:);
AF8=eeg(36,:);
F5=eeg(37,:);
F1=eeg(38,:);
F2=eeg(39,:);
F6=eeg(40,:);
FC3=eeg(41,:);
FCZ=eeg(42,:);
FC4=eeg(43,:);
C5=eeg(44,:);
C1=eeg(45,:);
C2=eeg(46,:);
C6=eeg(47,:);
CP3=eeg(48,:);
CPZ=eeg(49,:);
CP4=eeg(50,:);
P5=eeg(51,:);
P1=eeg(52,:);
P2=eeg(53,:);
P6=eeg(54,:);
PO5=eeg(55,:);
PO3=eeg(56,:);
PO4=eeg(57,:);
PO6=eeg(58,:);
FT7=eeg(59,:);
FT8=eeg(60,:);
% TP7=eeg(61,:);
% TP8=eeg(62,:);
% PO7=eeg(63,:);
% PO8=eeg(64,:);
TP7=eeg(61,:);
TP8=eeg(62,:).*0;
PO7=eeg(63,:).*0;
PO8=eeg(64,:).*0;

clear eeg

%meanM1M2 = (1/2)*(M1+M2);

% source 64 channels
fp2 = FP2 - FZ;
fpz = FPZ - FZ;
fp1 = FP1 - FZ;
af8 = AF8 - FZ;
af7 = AF7 - FZ;
af4 = AF4 - FZ;
af3 = AF3 - FZ;
f8 = F8 - FZ;
f6 = F6 - FZ;
f4 = F4 - FZ;
f2 = F2 - FZ;
fz = FZ - FZ;
f1 = F1 - FZ;
f3 = F3 - FZ;
f5 = F5 - FZ;
f7 = F7 - FZ;
ft8 = FT8 - FZ;
fc6 = FC6 - FZ;
fc4 = FC4 - FZ;
fc2 = FC2 - FZ;
fcz = FCZ - FZ;
fc1 = FC1 - FZ;
fc3 = FC3 - FZ;
fc5 = FC5 - FZ;
ft7 = FT7 - FZ;
t8 = T8 - FZ;
c6 = C6 - FZ;
c4 = C4 - FZ;
c2 = C2 - FZ;
cz = CZ - FZ;
c1 = C1 - FZ;
c3 = C3 - FZ;
c5 = C5 - FZ;
t7 = T7 - FZ;
tp8 = TP8 - FZ;
cp6 = CP6 - FZ;
cp4 = CP4 - FZ;
cp2 = CP2 - FZ;
cpz = CPZ - FZ;
cp1 = CP1 - FZ;
cp3 = CP3 - FZ;

cp5 = CP5 - FZ;
tp7 = TP7 - FZ;
p8 = P8 - FZ;
p6 = P6 - FZ;
p4 = P4 - FZ;
p2 = P2 - FZ;
pz = PZ - FZ;
p1 = P1 - FZ;
p3 = P3 - FZ;
p5 = P5 - FZ;
p7 = P7 - FZ;
po8 = PO8 - FZ;
po6 = PO6 - FZ;
po4 = PO4 - FZ;
poz = POZ - FZ;
po3 = PO3 - FZ;
po5 = PO5 - FZ;
po7 = PO7 - FZ;
o2 = O2 - FZ;
oz = OZ - FZ;
o1 = O1 - FZ;
m2 = M2 - FZ;
m1 = M1 - FZ;
C3_FZ=C3-FZ;
C4_FZ=C4-FZ;
CP3_FZ=CP3-FZ;
CP4_FZ=CP4-FZ;

clear Fp1 Fpz Fp2 F7 F3 Fz F4 F8 FC5 FC1 FC2 FC6 M1 T7 C3 Cz C4 T8 M2 CP5 CP1 CP2 CP6 P7 P3 Pz P4 P8 POz O1 Oz O2 AF7 AF3 AF4 AF8 F5 F1 F2 F6 FC3 FCz FC4 C5 C1 C2 C6 CP3 CPz CP4 P5 P1 P2 P6 PO5 PO3 PO4 PO6 FT7 FT8 TP7 TP8 PO7 PO8

EEG=[fp1; fpz; fp2; f7; f3; fz; f4; f8; fc5;...
fc1; fc2; fc6; m1; t7; c3; cz; c4; t8; m2;...
cp5; cp1; cp2; cp6; p7; p3; pz; p4; p8; poz; o1; oz; o2; ...
af7; af3; af4; af8; f5; f1; f2; f6; fc3; fcz; fc4; c5; c1; c2; c6; cp3; cpz;...
cp4; p5; p1; p2; p6; po5; po3; po4; po6; ft7; ft8; tp7; tp8; po7; po8;];