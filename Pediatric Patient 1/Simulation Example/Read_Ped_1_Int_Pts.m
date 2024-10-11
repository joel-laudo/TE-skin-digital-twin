clear
close all
clc

original_int_pts = readmatrix("Ped_1_int_pts_pre_processing.txt");
writematrix(original_int_pts(:,3:5), "Ped_1_Skin_Integration_points.txt");