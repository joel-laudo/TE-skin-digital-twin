function [Group_1, Group_2, Group_3, Group_4, Group_5, Group_6] = P1NC_UpdateSx_V1(Sx)
Sx = Sx/2; %Rescale Sx for compatibility with the stiffness group functions from 0 - 2 to 0 - 1 for convenience
Group_1 = -9*Sx + 9;
Group_2 = -5*Sx + 5;
Group_3 = -4*Sx + 4;
Group_4 = -3*Sx + 3;
Group_5 = -5*Sx + 5;
Group_6 = -Sx + 1;
end