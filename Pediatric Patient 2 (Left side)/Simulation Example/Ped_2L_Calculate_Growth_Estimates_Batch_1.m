close all
clear
clc


%% Read in information about the skin nodes from the part file including which nodes are in the top layer APEX GROWTH CUTOUT
%Read in the top layer skin nodes
Ped_2L_Top_Layer_skin_nodes = linspace(1,53179,26590);

Ped_2L_AllSkinNodalCoords = readmatrix("Ped_2L_INPUT_Skin_Nodes_REMESH_V2.txt");
Ped_2L_All_Skin_elements = readmatrix("Ped_2L_INPUT_Skin_Elements_REMESH_V2.txt");

%Determine top layer skin nodal coordinates
Ped_2L_Top_Layer_skin_nodal_coords = Ped_2L_AllSkinNodalCoords(Ped_2L_Top_Layer_skin_nodes, 2:4);

%Copy all skin elements twice, one to modify throughout the program and one
%to display the result
Ped_2L_Top_Layer_Skin_elements_identifier = Ped_2L_All_Skin_elements;
Ped_2L_TopLayerSkinElemsAndNodes = Ped_2L_All_Skin_elements;



%% Determine the element set for all the top layer elements and record it for later use extracting growth data from Abaqus


%Loop over all top layer skin nodes

%Replace all instances of top layer skin nodes in the top elements variable with zeros
for i = 1:length(Ped_2L_Top_Layer_skin_nodes)
   Ped_2L_Top_Layer_Skin_elements_identifier(Ped_2L_Top_Layer_Skin_elements_identifier == Ped_2L_Top_Layer_skin_nodes(i)) = 0;
end
 

%ensure that the element index column is correct
Ped_2L_Top_Layer_Skin_elements_identifier(:,1) = Ped_2L_All_Skin_elements(:,1);


%Identify and Remove all element rows which have less than 4 top nodes (4 zeros)
numZerosPerRow = sum(Ped_2L_Top_Layer_Skin_elements_identifier == 0, 2);
rowsWithLessThan4Zeros = numZerosPerRow < 4;
Ped_2L_Top_Layer_Skin_elements_identifier(rowsWithLessThan4Zeros,:) = [];


Ped_2L_TopLayerSkinElemsAndNodes(rowsWithLessThan4Zeros,:) = [];



%Write variable that contains the top layer element set

Ped2RTopLayerElemSet = Ped_2L_TopLayerSkinElemsAndNodes(:,1);


%Remove node columns 6-9 of the top element nodal definition matrix because no top nodes show up here
Ped_2L_TopLayerSkinElemsAndNodes(:,6:9) = [];


%Iterate through each element in the top layer
Ped_2L_SkinElemAreas(:,1) = Ped2RTopLayerElemSet;

for i = 1:length(Ped_2L_TopLayerSkinElemsAndNodes(:,1))
    %Calculate the coordinates of each of the four vertices in the element
    A = Ped_2L_AllSkinNodalCoords(Ped_2L_AllSkinNodalCoords(:,1) == Ped_2L_TopLayerSkinElemsAndNodes(i,2), 2:4);
    B = Ped_2L_AllSkinNodalCoords(Ped_2L_AllSkinNodalCoords(:,1) == Ped_2L_TopLayerSkinElemsAndNodes(i,3), 2:4);
    C = Ped_2L_AllSkinNodalCoords(Ped_2L_AllSkinNodalCoords(:,1) == Ped_2L_TopLayerSkinElemsAndNodes(i,4), 2:4);
    D = Ped_2L_AllSkinNodalCoords(Ped_2L_AllSkinNodalCoords(:,1) == Ped_2L_TopLayerSkinElemsAndNodes(i,5), 2:4);
    
    %Calculate vectors to compute areas
    AB = A-B;
    AD = A-D;
    BC = B-C;
    BD = B-D;
    %Calculate the area of each quadrilateral and store it in an array
    tri_1_area = 0.5*norm(cross(AB,AD));
    tri_2_area = 0.5*norm(cross(BC,BD));
    quad_area = tri_1_area + tri_2_area;
    
    Ped_2L_SkinElemAreas(i,2) = quad_area;
end


%% Calculate the area of the top surface of each element in the top skin layer

%Read in the growth for the top skin layer from all simulation results
%files

for i = 1:1
     if i ~= 1000
        i = 55;
        Elem_growth_data(:,i) = readmatrix(['Ped_2L_thg_elem_data_Sim_', num2str(i) , '_MAPV2.txt']);
    else
        i = i;
    end
end

%Calculate initial surface area
Initial_area = sum(Ped_2L_SkinElemAreas(:,2));

%Calculate final surface area for all simulations

for i = 1:1
    if i ~= 1000
        i = 55;
        FinalSimGrowthEstimate(i) = dot(transpose(Ped_2L_SkinElemAreas(:,2)), Elem_growth_data(:,i)) - Initial_area;
    end
end

%Final Sim Growth Estimate
FinalSimGrowthEstimate = transpose(FinalSimGrowthEstimate);



