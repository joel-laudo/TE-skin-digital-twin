clear
close all
clc

old_skin_nodes = readmatrix("All_Skin_Nodes_Coords.txt");

old_exp_coords_and_normals = readmatrix("P1NC_ExpanderSkin_points_with_normals.xyz", "FileType","text");

same_normals = old_exp_coords_and_normals(:,4:6);

old_ExpSkin_x_s = old_exp_coords_and_normals(:,1);
old_ExpSkin_y_s = old_exp_coords_and_normals(:,2);
old_ExpSkin_z_s = old_exp_coords_and_normals(:,3);

original_x_s = old_skin_nodes(:,1);
original_y_s = old_skin_nodes(:,2);
original_z_s = old_skin_nodes(:,3); 

new_x_s = original_x_s - 150;
new_y_s = original_y_s - 80;
new_z_s = original_z_s;

new_exp_x_s = old_ExpSkin_x_s - 150;
new_exp_y_s = old_ExpSkin_y_s - 80;
new_exp_z_s = old_ExpSkin_z_s;

new_skin_nodes = [new_x_s new_y_s new_z_s];

new_ExpSkin_coords = [new_exp_x_s new_exp_y_s new_exp_z_s same_normals];

writematrix(new_skin_nodes, "All_Skin_Nodes_Coords_V2.txt")
writematrix(new_ExpSkin_coords, "P1NC_ExpanderSkin_points_with_normals_V2.xyz", "FileType","text")

figure(1)
plot3(old_ExpSkin_x_s, old_ExpSkin_y_s, old_ExpSkin_z_s, "rx")
plot3(original_x_s, original_y_s, original_z_s, "rx")

figure(2)
plot3(new_exp_x_s, new_exp_y_s, new_exp_z_s,"bx")
plot3(new_x_s, new_y_s, new_z_s, "bx")