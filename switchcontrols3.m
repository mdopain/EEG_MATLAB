function [trigfile, cntfile, name, name_wth_nr,cases, choice1, choice2, choice3, choice4]=switchcontrols3(persons, setting)

% 26 Fukking mag niet mee, 19 Broekhuis heet 'burst' maar staat uit
% cases 1: geen ICA,  2:tonisch ICA,  3: burst ICA,   4:beide ICA

switch persons

    case 1
            name='s1 Ter Voert';
            name_wth_nr='dhr Ter Voert';
            cases=1;
            switch setting
                case 4
                    trigfile = ['E:\Afstuderen\Data\Controles\s1\20120507_TerVoertPain4.trg'];
                    cntfile  = ['E:\Afstuderen\Data\Controles\s1\20120507_TerVoertPain4.cnt'];
            end
        case 2
            name='s2 Jeffrey';
            name_wth_nr='Jeffrey';
            cases=1;
            switch setting
                case 4
                    trigfile = ['E:\Afstuderen\Data\Controles\s2\20120515_s2Pain4.trg'];
                    cntfile  = ['E:\Afstuderen\Data\Controles\s2\20120515_s2Pain4.cnt'];
            end
end
