function [FixedSkinNodes] = P1C_FixSkinNodes_V3(tol, skin_nodes, skin_elements, mesh_pts)

%Generate a list of the skin elements to fix within a certain radius R
skin_nodes(:,5) = zeros(length(skin_nodes(:,1)),1);
skin_elements(:,10) = zeros(length(skin_elements(:,1)),1);
skin_node_coords = skin_nodes(:,2:4);



for i = 1:length(skin_node_coords(:,1))
    skin_node_distances = zeros(length(mesh_pts), 1);
    for j = 1:length(mesh_pts(:,1))
        skin_node_r_vector = skin_node_coords(i, 1:3) - mesh_pts(j, 2:4);
        skin_node_distance = norm(skin_node_r_vector);
        skin_node_distances(j) = skin_node_distance;
    end

    if min(skin_node_distances) > tol
            skin_nodes(i, 5) = 1;
    end
    
end

% Remove zero rows from the skin nodes matrix to only include nodes that
% should be fixed
skin_nodes(all(~skin_nodes(:,5),2), :) = [];

%Generate a list of elements to fix in place

skin_node_list = reshape(skin_nodes(:,1),1,[]);
FixedSkinNodes = skin_node_list;
% fixed_skin_elements = [skin_elements(:,1) ismember(skin_elements(:,2:9), skin_nodes)];
% fixed_skin_elements(all(~fixed_skin_elements(:,2:9),2), :) = [];
% 
% fixed_skin_elements = reshape(fixed_skin_elements(:,1),1,[]);

% %Export the elements to fix as a CSV to fix in Abaqus
% shortened_fixed_elements = transpose(fixed_skin_elements((1:(16*floor(length(fixed_skin_elements)/16)))));
% FixedSkinElements = transpose(reshape(shortened_fixed_elements, 16, []));
% last_row_fixed_elements = zeros([1,16]);
% last_row_fixed_elems = shortened_fixed_elements(16*length(FixedSkinElements(:,1))+1:end);
% last_row_fixed_elements(1:length(last_row_fixed_elems)) = last_row_fixed_elems;

end