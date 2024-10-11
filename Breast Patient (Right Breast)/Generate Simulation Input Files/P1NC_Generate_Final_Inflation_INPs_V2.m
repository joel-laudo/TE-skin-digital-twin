clc
clear
close all;

%% Load Base INP file
fileID = fopen('P1NC_Final_Protocol_Needs_Edit_V2.inp','r');
Incomplete = textscan( fileID, '%s', 'Delimiter','\n' );
Incomplete = Incomplete{1};
fclose(fileID);

%% Mark out the where additional information needs to be added
% AddRowPara=11; %adds k information
AddRowExpNodes=73791; %adds shifted and rotated expander nodes
AddRowNode9999 = 81408; %adds the new node 9999 after shifting
AddRowSpringStiffness = 81559; %adds spring stiffness information
AddRowFixed=82563; %adds fixed skin nodes



%% Load Skin Nodes and Skin Elements
Skin_Nodes = readmatrix("P1NC_INPUT_Skin_Nodes_V2.txt");
Skin_Elements = readmatrix("P1NC_INPUT_Skin_Elements_V2.txt");

%% Load original mesh points and mesh elements
original_mesh_nodes = readmatrix("P1NC_Expander_mesh_nodes_V1.txt");
original_mesh_elements = readmatrix("P1NC_Expander_mesh_elements_V1.txt");
expd_pts_and_normals = readmatrix("P1NC_ExpanderSkin_points_with_normals.xyz", "FileType","text");
%% Load mu, k, distance of expander
designs=load('P1NC_tol_h_gamma_Sx_50T.txt');

%% Job 1-100,
for JobNum=1:50
    tol = designs(JobNum,2);
    offset = designs(JobNum, 3);
    gamma = designs(JobNum, 4);
    Sx = designs(JobNum, 5);
    fname='FINAL_P1NC_Job'+string(JobNum)+'V4.inp';
    fid = fopen(fname, 'w' );

    for ii = 1 : AddRowExpNodes
        fprintf(fid, '%s\n', Incomplete{ii} );
    end

    % Add shifted Expander Node Coords
    [new_node_9999, NewExpNodes] = P1NC_UpdateExpanderNodes_V1(original_mesh_nodes, original_mesh_elements, expd_pts_and_normals, offset, gamma);
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
    
     
    [Group_1, Group_2, Group_3, Group_4, Group_5, Group_6] = P1NC_UpdateSx_V1(Sx);

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
    Fixed_Skin_Nodes=P1NC_FixSkinNodes_V1(tol, Skin_Nodes, Skin_Elements, NewExpNodes);
    fprintf(fid,'%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n',Fixed_Skin_Nodes);
    fprintf(fid, '\n');
    
    for ii = AddRowFixed+1 : length(Incomplete)
        fprintf( fid, '%s\n', Incomplete{ii} );
    end
    fclose( fid );
end

