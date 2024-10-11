function [Group_1, Group_2, Group_3, Group_4, Group_5, Group_6] = P1C_UpdateSx_V3(Sx)

%Implements the piecewise continuous definition relating Sx with the spring
%stiffness groups
if Sx > 1 %Sx varies between 1 and 2
    Sx = Sx - 1; %Shift so that Sx = 1 is now 0 for convenience 
    Group_1 = -9*Sx + 9;
    Group_2 = -5*Sx + 5;
    Group_3 = -4*Sx + 4;
    Group_4 = -3*Sx + 3;
    Group_5 = -5*Sx + 5;
    Group_6 = -Sx + 1;
else %Sx varies between 0 and 1
    Group_1 = 2*Sx^2 -5*Sx + 12;
    Group_2 = 6*Sx^2 - 11*Sx + 10;
    Group_3 = 4*Sx^2 - 10*Sx + 10;
    Group_4 = 6*Sx^2 - 13*Sx + 10;
    Group_5 = -4*Sx + 9;
    Group_6 = 0;
end