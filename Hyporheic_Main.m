clc;clear all;close all;
%% 2D
data=load('Jessan_v2.txt');
M=220; % y
N=400; % x
[Hyporheic_area,HZ_Location,Hyporheiczone_depth] = Hyporheic_zone_volumecalculate(data,N,M);
%% 3D
data=load('C:\Users\GD\Desktop\3Dvelocity_u.txt');
M = 320; % x
N = 180; % y
O = 212; % z
[Hyporheic_Volume,HZ_Location] = Hyporheic_zone_volumecalculate3D(data,M,N,O);

