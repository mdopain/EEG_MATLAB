
function [epochs] = verwijderde_epochs( TrigNr, Meting, MetingDag )

MetingDag = num2str (Metingdag);
[num, txt] = xlsread('verwijderde_epochs.xlsx', MetingDag);
hoogte = length(num(:,1));
breedte = length(num(1,:));

for i=1:hoogte
    if num(i,1) == TrigNr
        if strcmp(txt(i,1),Meting)
            epochs = num(i, 3:breedte)
            x = find(~isnan(epochs));
            epochs = epochs(x)
        end
    end
end

end
