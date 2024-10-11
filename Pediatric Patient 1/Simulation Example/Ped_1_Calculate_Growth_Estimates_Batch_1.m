close all
clear
clc


%% Read in information about the skin nodes from the part file including which nodes are in the top layer APEX GROWTH CUTOUT
%Ped_1_Top_Layer_skin_nodes = linspace(1, 23775, 11888); %These are the full
%top layer nodes, but we just want the apex nodes which are read in below

Ped_1_Top_Layer_skin_nodes = readmatrix("Ped_1_GROWTH_cutout_Apex_nodeset.txt");



Ped_1_AllSkinNodalCoords = readmatrix("Ped_1_INPUT_Skin_Nodes_V1.txt");
Ped_1_All_Skin_elements = readmatrix("Ped_1_INPUT_Skin_Elements_V1.txt");

%Determine top layer skin nodal coordinates for the APEX
Ped_1_Top_Layer_Apex_nodal_indices = readmatrix("Ped_1_GROWTH_cutout_Apex_nodeset.txt");
Ped_1_Top_Layer_skin_nodal_coords = Ped_1_AllSkinNodalCoords(Ped_1_Top_Layer_Apex_nodal_indices, :);

%Copy all skin elements twice, one to modify throughout the program and one
%to display the result
Ped_1_Top_Layer_Skin_elements_identifier = Ped_1_All_Skin_elements;
Ped_1_TopLayerSkinElemsAndNodes = Ped_1_All_Skin_elements;



%% Determine the element set for all the top layer elements and record it for later use extracting growth data from Abaqus


%Loop over all top layer skin nodes

%Replace all instances of top layer skin nodes in the top elements variable with zeros
for i = 1:length(Ped_1_Top_Layer_skin_nodes)
   Ped_1_Top_Layer_Skin_elements_identifier(Ped_1_Top_Layer_Skin_elements_identifier == Ped_1_Top_Layer_skin_nodes(i)) = 0;
end
 

%ensure that the element index column is correct
Ped_1_Top_Layer_Skin_elements_identifier(:,1) = Ped_1_All_Skin_elements(:,1);


%Identify and Remove all element rows which have less than 4 top nodes (4 zeros)
numZerosPerRow = sum(Ped_1_Top_Layer_Skin_elements_identifier == 0, 2);
rowsWithLessThan4Zeros = numZerosPerRow < 4;
Ped_1_Top_Layer_Skin_elements_identifier(rowsWithLessThan4Zeros,:) = [];


Ped_1_TopLayerSkinElemsAndNodes(rowsWithLessThan4Zeros,:) = [];



%Write variable that contains the top layer element set

Ped1TopLayerElemSet = Ped_1_TopLayerSkinElemsAndNodes(:,1);


%Remove node columns 6-9 of the top element nodal definition matrix because no top nodes show up here
Ped_1_TopLayerSkinElemsAndNodes(:,6:9) = [];


%Iterate through each element in the top layer
Ped_1_SkinElemAreas(:,1) = Ped1TopLayerElemSet;

for i = 1:length(Ped_1_TopLayerSkinElemsAndNodes(:,1))
    %Calculate the coordinates of each of the four vertices in the element
    A = Ped_1_AllSkinNodalCoords(Ped_1_AllSkinNodalCoords(:,1) == Ped_1_TopLayerSkinElemsAndNodes(i,2), 2:4);
    B = Ped_1_AllSkinNodalCoords(Ped_1_AllSkinNodalCoords(:,1) == Ped_1_TopLayerSkinElemsAndNodes(i,3), 2:4);
    C = Ped_1_AllSkinNodalCoords(Ped_1_AllSkinNodalCoords(:,1) == Ped_1_TopLayerSkinElemsAndNodes(i,4), 2:4);
    D = Ped_1_AllSkinNodalCoords(Ped_1_AllSkinNodalCoords(:,1) == Ped_1_TopLayerSkinElemsAndNodes(i,5), 2:4);
    
    %Calculate vectors to compute areas
    AB = A-B;
    AD = A-D;
    BC = B-C;
    BD = B-D;
    %Calculate the area of each quadrilateral and store it in an array
    tri_1_area = 0.5*norm(cross(AB,AD));
    tri_2_area = 0.5*norm(cross(BC,BD));
    quad_area = tri_1_area + tri_2_area;
    
    Ped_1_SkinElemAreas(i,2) = quad_area;
end

Ped_1_APEX_Skin_Elems = Ped_1_TopLayerSkinElemsAndNodes(:,1);
writematrix(Ped_1_APEX_Skin_Elems, "Ped_1_APEX_Skin_Elems.txt")

%% Calculate the area of the top surface of each element in the top skin layer

%Read in the growth for the top skin layer from all simulation results
%files

for i = 41:41
     if i ~= 1000
        Elem_growth_data(:,i) = readmatrix(['Ped_1_thg_elem_data_Sim_', num2str(i) , '_MAP_V4.txt']);
    else
        i = i;
    end
end

%Calculate initial surface area
Initial_area = sum(Ped_1_SkinElemAreas(:,2));


%Remove all growth values for elements that aren't in the apex

Elem_growth_data = Elem_growth_data(Ped_1_APEX_Skin_Elems,:);
%Calculate final surface area for all simulations
for i = 41:41
    if i ~= 1000
        FinalSimGrowthEstimate(i) = dot(transpose(Ped_1_SkinElemAreas(:,2)), Elem_growth_data(:,i)) - Initial_area;
    end
end
%Final Sim Growth Estimate
FinalSimGrowthEstimate = transpose(FinalSimGrowthEstimate);

%Calculate new total area
Final_Apex_Area_Estimate = FinalSimGrowthEstimate + Initial_area;

