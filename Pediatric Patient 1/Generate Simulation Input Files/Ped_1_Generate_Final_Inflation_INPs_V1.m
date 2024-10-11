clc
clear
close all;

%% Load Base INP file
fileID = fopen('Ped_1_Final_Protocol_Needs_Edit_V1.inp','r');
Incomplete = textscan(fileID, '%s', 'Delimiter','\n');
Incomplete = Incomplete{1};
fclose(fileID);

%% Mark out the where additional information needs to be added
% AddRowPara=11; %adds k information
AddRowExpNodes = 58979; %adds shifted and rotated expander nodes
AddRowNode9999 = 69388; %adds the new node 9999 after shifting
AddRowSpringStiffness = 69583; %adds spring stiffness information
AddRowFixed=69584; %adds fixed skin nodes



%% Load Skin Nodes and Skin Elements
Skin_Nodes = readmatrix("Ped_1_INPUT_Skin_Nodes_V1.txt");
Skin_Elements = readmatrix("Ped_1_INPUT_Skin_Elements_V1.txt");

%% Load original mesh points and mesh elements
original_mesh_nodes = readmatrix("Ped_Expander_mesh_nodes_V1.txt");
original_mesh_elements = readmatrix("Ped_Expander_mesh_elements_V1.txt");
expd_pts_and_normals = readmatrix("Ped_1_ExpanderSkin_points_with_normals.xyz", "FileType","text");
%% Load mu, k, distance of expander
designs=load('Ped_1_MAP_design.txt');

%% Job 1-100,
for JobNum=1:1
    tol = designs(JobNum,2);
    offset = designs(JobNum, 3) +3.6; %Adjust for the skin model thickness
    mu = designs(JobNum, 4);
    tcrit = designs(JobNum, 5);
    kk = designs(JobNum, 6);
    gamma = 0; %No expander rotation
    fname='FINAL_Ped_1_Job'+string(JobNum)+'_MAP_4NEW.inp';
    fid = fopen(fname, 'w' );
    
    for ii = 1 : 12
        fprintf(fid, '%s\n', Incomplete{ii} );
    end

    fprintf(fid, "mu = %4.2f\n", mu);
    
    for ii = 14 : 16
        fprintf(fid, '%s\n', Incomplete{ii} );
    end

    fprintf(fid, "kk = %4.2f\n", kk);
    fprintf(fid, "tcrt = %4.3f\n", tcrit);

    for ii = 19 : AddRowExpNodes
        fprintf(fid, '%s\n', Incomplete{ii} );
    end

    % Add shifted Expander Node Coords
    [new_node_9999, NewExpNodes] = Ped_1_UpdateExpanderNodes_V1(original_mesh_nodes, original_mesh_elements, expd_pts_and_normals, offset, gamma);
    fprintf(fid,'%d, %6.12f, %6.12f, %6.12f\n',NewExpNodes');

    for ii = AddRowExpNodes+1 : AddRowNode9999
        fprintf( fid, '%s\n', Incomplete{ii} );
    end

    %Add new node 9999 location
    new_node_9999(2:4) = new_node_9999(1:3);
    new_node_9999(1) = 9999;
    fprintf(fid, "%d, %4.6f, %4.6f, %4.6f\n", new_node_9999(1), new_node_9999(2), new_node_9999(3), new_node_9999(4));
   

    for ii = AddRowNode9999+1 : AddRowSpringStiffness
        fprintf( fid, '%s\n', Incomplete{ii} );
    end

    for ii = AddRowSpringStiffness+1 : AddRowFixed
        fprintf( fid, '%s\n', Incomplete{ii} );
    end
    

    % Add BC
    Fixed_Skin_Nodes=Ped_1_FixSkinNodes_V1(tol, Skin_Nodes, Skin_Elements, NewExpNodes);
    fprintf(fid,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n',Fixed_Skin_Nodes);
    fprintf(fid, '\n');
    
    for ii = AddRowFixed+1 : length(Incomplete)
        fprintf( fid, '%s\n', Incomplete{ii} );
    end
    fclose( fid );
end

