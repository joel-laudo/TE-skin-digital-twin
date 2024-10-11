clc
clear
close all;

%% Load Base INP file
fileID = fopen('P1C_Final_Protocol_Needs_Edit_V4.inp','r');
Incomplete = textscan( fileID, '%s', 'Delimiter','\n' );
Incomplete = Incomplete{1};
fclose(fileID);

%% Mark out the where additional information needs to be added
% AddRowPara=11; %adds k information
AddRowExpNodes=117932; %adds shifted and rotated expander nodes
AddRowNode9999 = 125549; %adds the new node 9999 after shifting
AddRowSpringStiffness = 125700; %adds spring stiffness information
AddRowFixed=126704; %adds fixed skin nodes



%% Load Skin Nodes and Skin Elements
Skin_Nodes = readmatrix("INPUT_Skin_Nodes_V3.txt");
Skin_Elements = readmatrix("INPUT_Skin_Elements_V3.txt");

%% Load original mesh points and mesh elements
original_mesh_nodes = readmatrix("Expander_Job_1_mesh_nodes_V3.txt");
original_mesh_elements = readmatrix("Expander_Job_1_mesh_elements_V3.txt");
expd_pts_and_normals = readmatrix("1C_Radial_grid_expander_points_with_normals_V3.xyz", "FileType","text");
%% Load mu, k, distance of expander
designs=load('tol_h_gamma_Sx_25T_V4.txt');

%% Job 1-100,
for JobNum=1:25
    tol = designs(JobNum,2);
    offset = designs(JobNum, 3);
    gamma = designs(JobNum, 4);
    Sx = designs(JobNum, 5);
    fname='FINAL_P1C_Job'+string(JobNum)+'V4.inp';
    fid = fopen(fname, 'w' );

    for ii = 1 : AddRowExpNodes
        fprintf(fid, '%s\n', Incomplete{ii} );
    end

    % Add shifted Expander Node Coords
    [new_node_9999, NewExpNodes] = P1C_UpdateExpanderNodes_V3(original_mesh_nodes, original_mesh_elements, expd_pts_and_normals, offset, gamma);
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
    
     
    [Group_1, Group_2, Group_3, Group_4, Group_5, Group_6] = P1C_UpdateSx_V3(Sx);

    fprintf(fid, "*Spring, elset=SpringElements4\n");
    fprintf(fid, "\n");
    fprintf(fid, "%4.6f\n", Group_4);
    fprintf(fid, "*Spring, elset=SpringElements3\n");
    fprintf(fid, "\n");
    fprintf(fid, "%4.6f\n", Group_3);
    fprintf(fid, "*Spring, elset=SpringElements6\n");
    fprintf(fid, "\n");
    fprintf(fid, "%4.6f\n", Group_6);
    fprintf(fid, "*Spring, elset=SpringElements2\n");
    fprintf(fid, "\n");
    fprintf(fid, "%4.6f\n", Group_2);
    fprintf(fid, "*Spring, elset=SpringElements5\n");
    fprintf(fid, "\n");
    fprintf(fid, "%4.6f\n", Group_5);
    fprintf(fid, "*Spring, elset=SpringElements1\n");
    fprintf(fid, "\n");
    fprintf(fid, "%4.6f\n", Group_1);


    for ii = AddRowSpringStiffness+1 : AddRowFixed
        fprintf( fid, '%s\n', Incomplete{ii} );
    end
    

    % Add BC
    Fixed_Skin_Nodes=P1C_FixSkinNodes_V3(tol, Skin_Nodes, Skin_Elements, NewExpNodes);
    fprintf(fid,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n',Fixed_Skin_Nodes);
    fprintf(fid, '\n');
    
    for ii = AddRowFixed+1 : length(Incomplete)
        fprintf( fid, '%s\n', Incomplete{ii} );
    end
    fclose( fid );
end

