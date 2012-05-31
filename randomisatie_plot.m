% Test van randomheid

%initialisatie
d = [2,1,6,3,4,5];
j = [4,1,6,3,2,5];
p = [2,3,6,1,4,5];
r = [3,2,4,1,6,5];

t=1:6;
%% Plot
% Dit is een test
hold on
scatter(t,d,'b');
scatter(t,r,'g');
scatter(t,p,'r');
scatter(t,j,'c');

axis([0 7 0 7]);

