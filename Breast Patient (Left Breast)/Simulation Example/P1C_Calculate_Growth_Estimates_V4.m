close all
clear
clc


%% Read in information about the skin nodes from the part file including which nodes are in the top layer
P1C_Top_Layer_skin_nodes = linspace(14841, 44519, 14840);



P1CAllSkinNodalCoords = readmatrix("INPUT_Skin_Nodes_V3.txt");
P1C_All_Skin_elements = readmatrix("INPUT_Skin_Elements_V3.txt");

%Determine top layer skin nodal coordinates
P1C_Top_Layer_skin_nodal_coords = P1CAllSkinNodalCoords(linspace(14841, 44519, 14840), :);

%Copy all skin elements twice, one to modify throughout the program and one
%to display the result
P1C_Top_Layer_Skin_elements_identifier = P1C_All_Skin_elements;
P1CTopLayerSkinElemsAndNodes = P1C_All_Skin_elements;



%% Determine the element set for all the top layer elements and record it for later use extracting growth data from Abaqus


%Loop over all top layer skin nodes

%Replace all instances of top layer skin nodes in the top elements variable with zeros
for i = 1:length(P1C_Top_Layer_skin_nodes)
   P1C_Top_Layer_Skin_elements_identifier(P1C_Top_Layer_Skin_elements_identifier == P1C_Top_Layer_skin_nodes(i)) = 0;
end
 

%ensure that the element index column is correct
P1C_Top_Layer_Skin_elements_identifier(:,1) = P1C_All_Skin_elements(:,1);


%Identify and Remove all element rows which have less than 4 top nodes (4 zeros)
numZerosPerRow = sum(P1C_Top_Layer_Skin_elements_identifier == 0, 2);
rowsWithLessThan4Zeros = numZerosPerRow < 4;
P1C_Top_Layer_Skin_elements_identifier(rowsWithLessThan4Zeros,:) = [];


P1CTopLayerSkinElemsAndNodes(rowsWithLessThan4Zeros,:) = [];



%Write variable that contains the top layer element set

P1CTopLayerElemSet = P1CTopLayerSkinElemsAndNodes(:,1);


%Remove node columns 6-9 of the top element nodal definition matrix because no top nodes show up here
P1CTopLayerSkinElemsAndNodes(:,6:9) = [];


%Iterate through each element in the top layer
P1CSkinElemAreas(:,1) = P1CTopLayerElemSet;

for i = 1:length(P1CTopLayerSkinElemsAndNodes(:,1))
    %Calculate the coordinates of each of the four vertices in the element
    A = P1CAllSkinNodalCoords(P1CAllSkinNodalCoords == P1CTopLayerSkinElemsAndNodes(i,2), 2:4);
    B = P1CAllSkinNodalCoords(P1CAllSkinNodalCoords == P1CTopLayerSkinElemsAndNodes(i,3), 2:4);
    C = P1CAllSkinNodalCoords(P1CAllSkinNodalCoords == P1CTopLayerSkinElemsAndNodes(i,4), 2:4);
    D = P1CAllSkinNodalCoords(P1CAllSkinNodalCoords == P1CTopLayerSkinElemsAndNodes(i,5), 2:4);
    
    %Calculate vectors to compute areas
    AB = A-B;
    AD = A-D;
    BC = B-C;
    BD = B-D;
    %Calculate the area of each quadrilateral and store it in an array
    tri_1_area = 0.5*norm(cross(AB,AD));
    tri_2_area = 0.5*norm(cross(BC,BD));
    quad_area = tri_1_area + tri_2_area;
    
    P1CSkinElemAreas(i,2) = quad_area;
end



%% Calculate the area of the top surface of each element in the top skin layer

%Read in the growth for the top skin layer from all simulation results
%files

for i = 1:20
    if i == 1 || i == 4 || i == 9 || i == 11 || i == 12 || i == 15 || i == 16 || i == 18 || i == 19 || i == 20
        Elem_growth_data(:,i) = readmatrix(['P1C_thg_elem_data_Sim_', num2str(i) , 'V4.txt']);
    else
        i = i;
    end
end

%Calculate initial surface area
Initial_area = sum(P1CSkinElemAreas(:,2));

%Calculate final surface area for all simulations
for i = 1:20
    if i == 1 || i == 4 || i == 9 || i == 11 || i == 12 || i == 15 || i == 16 || i == 18 || i == 19 || i == 20
        FinalSimGrowthEstimate(i) = dot(transpose(P1CSkinElemAreas(:,2)), Elem_growth_data(:,i)) - Initial_area;
    end
end
FinalSimGrowthEstimate = transpose(FinalSimGrowthEstimate);
