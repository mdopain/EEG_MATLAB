function [trigfile, cntfile, name, name_wth_nr,cases]=switchpatients3(persons, setting)

% 26 Fukking mag niet mee, 19 Broekhuis heet 'burst' maar staat uit
% cases 1: geen ICA,  2:tonisch ICA,  3: burst ICA,   4:beide ICA

switch persons

    case 12
        name='12 Kann';
        name_wth_nr='Kann';
        cases=1;
        switch setting
            case 1
                trigfile=1;
                cntfile=1;
            case 2
                trigfile=1;
                cntfile=1;
            case 3 
                trigfile = ['G:\MDO\Data\' name '\20111215_KannPain3.trg'];
                cntfile  = ['G:\MDO\Data\' name '\20111215_KannPain3.cnt'];
        end
    case 16
        name='16 Bargeman';
        name_wth_nr='Bargeman';
        cases=2;
        switch setting
            case 1
                trigfile = ['G:\MDO\Data\' name '\20111121_BargemanPain1.trg'];
                cntfile  = ['G:\MDO\Data\' name '\20111121_BargemanPain1.cnt'];
            case 2
                trigfile = ['G:\MDO\Data\' name '\20111205_BargemanPain2.trg']; 
                cntfile  = ['G:\MDO\Data\' name '\20111205_BargemanPain2.cnt']; 
            case 3
                trigfile=1;
                cntfile=1;
        end
    case 17
        name='17 ten Duis';
        name_wth_nr='TenDuis';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111121_tenDuisPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111121_tenDuisPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111205_tenDuisPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111205_tenDuisPain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 18
        name='18 Smits';
        name_wth_nr='Smits';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111121_SmitsPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111121_SmitsPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111205_SmitsPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111205_SmitsPain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 19
        name='19 Broekhuis';
        name_wth_nr='Broekhuis';
        cases=1;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111121_BroekhuisPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111121_BroekhuisPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120412_BroekhuisPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120412_BroekhuisPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20111205_BroekhuisPain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111205_BroekhuisPain3.cnt']; 
        end
    case 20
        name='20 ter Voert';
        name_wth_nr='TerVoert';
        cases=1;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111121_terVoertPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111121_terVoertPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111207_terVoertPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111207_terVoertPain2.cnt']; 
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120507_terVoertPain33.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120507_terVoertPain33.cnt']; 
        end
    case 21
        name='21 Bajema';
        name_wth_nr='Bajema';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111121_BajemaPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111121_BajemaPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111205_BajemaPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111205_BajemaPain2.cnt']; 
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120508_p21Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120508_p21Pain3.cnt']; 
        end    
    case 22
        name='22 Heidemans';
        name_wth_nr='Heidemans';
        cases=1;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111121_HeidemansPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111121_HeidemansPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111205_HeidemansPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111205_HeidemansPain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 23
        name='23 Mosman';
        name_wth_nr='Mosman';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111121_MosmanPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111121_MosmanPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111205_MosmanPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111205_MosmanPain2.cnt']; 
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120509_p23Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120509_p23Pain3.cnt']; 
        end    
    case 24
        name='24 Kleinsman';
        name_wth_nr='Kleinsman';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111122_KleinsmanPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111122_KleinsmanPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111206_KleinsmanPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111206_KleinsmanPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120507_p24Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120507_p24Pain3.cnt']; 
        end 
    case 25
        name='25 Rutgers';
        name_wth_nr='Rutgers';
        cases=2;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111122_RutgersPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111122_RutgersPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111206_RutgersPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111206_RutgersPain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end  
    case 26
        name='26 Fukking';
        name_wth_nr='Fukking';
        cases=1;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111122_FukkingPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111122_FukkingPain1.cnt'];
            case 2
        trigfile=1;
        cntfile=1;
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 27
        name='27 deJong';
        name_wth_nr='DeJong';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111122_deJongPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111122_deJongPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111206_deJongPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111206_deJongPain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 28
        name='28 Kole';
        name_wth_nr='Kole';
        cases=2;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111122_KolePain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111122_KolePain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111206_KolePain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111206_KolePain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 29
        name='29 teGrotenhuis';
        name_wth_nr='TeGrotenhuis';
        cases=1;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111122_teGrotenhuisPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111122_teGrotenhuisPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111206_teGrotenhuisPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111206_teGrotenhuisPain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 30
        name='30 Dannenberg';
        name_wth_nr='Dannenberg';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111122_DannenbergPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111122_DannenbergPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111206_DannenbergPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111206_DannenbergPain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 31
        name='31 Besselink';
        name_wth_nr='Besselink';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111123_BesselinkPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111123_BesselinkPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111215_BesselinkPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111215_BesselinkPain2.cnt']; 
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 32
        name='32 Elkink';
        name_wth_nr='Elkink';
        cases=2;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111123_ElkinkPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111123_ElkinkPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111207_ElkinkPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111207_ElkinkPain2.cnt']; 
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120514_p32Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120514_p32Pain3.cnt']; ;
        end
    case 33
        name='33 vandenHam';
        name_wth_nr='VandenHam';
        cases=1;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111123_vandenHamPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111123_vandenHamPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111207_vandenHamPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111207_vandenHamPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120511_p33Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120511_p33Pain3.cnt'];
        end
    case 34
        name='34 Vermonden';
        name_wth_nr='Vermonden';
        cases=4;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20111123_VermondenPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20111123_VermondenPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20111207_VermondenPain2.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20111207_VermondenPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120511_p34Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120511_p34Pain3.cnt']; 
        end
    case 35
        name='35 Huisman';
        name_wth_nr='Huisman';
        cases=1;
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120229_HuismanPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120229_HuismanPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120410_HuismanPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120410_HuismanPain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end
    case 36
        name='36 Bergink';
        name_wth_nr='Bergink';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120229_BerginkPainTonisch.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120229_BerginkPainTonisch.cnt'];
            case 2
        trigfile=1;
        cntfile=1;
            case 3
        trigfile=1;
        cntfile=1;
        end 
    case 37
        name='37 Kwekkeboom';
        name_wth_nr='Kwekkeboom';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120320_KwekkeboomPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120320_KwekkeboomPain1.cnt'];
            case 2
        trigfile=1;
        cntfile=1;
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120514_p37Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120514_p37Pain3.cnt'];
        end 
    case 38
        name='38 Meulenbroek';
        name_wth_nr='Meulenbroek';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120320_MeulenbroekPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120320_MeulenbroekPain1.cnt'];
            case 2
       trigfile = ['G:\MDO\Data\' name '\20120411_MeulenbroekPain2.trg'];
       cntfile  = ['G:\MDO\Data\' name '\20120411_MeulenbroekPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120514_p38Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120514_p38Pain3.cnt'];
        end 
    case 39
        name='39 Weikamp';
        name_wth_nr='Weikamp';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120320_WeikampPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120320_WeikampPain1.cnt'];
            case 2
        trigfile=1;
        cntfile=1;
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120508_p39Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120508_p39Pain3.cnt']; 
        end 
    case 40
        name='40 de Paauw';
        name_wth_nr='DePaauw';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120321_DePaauwPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120321_DePaauwPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120411_DePaauwPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120411_DePaauwPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120504_DePaauwPain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120504_DePaauwPain3.cnt']; 
        end 
    case 41
        name='41 Kroeze';
        name_wth_nr='Kroeze';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120321_KroezePain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120321_KroezePain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120410_KroezePain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120410_KroezePain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end 
    case 42
        name='42 Slot Pol';
        name_wth_nr='SlotPol';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120321_SlotPolPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120321_SlotPolPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120412_SlotPolPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120412_SlotPolPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120511_p42Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120511_p42Pain3.cnt']; 
        end 
    case 43
        name='43 Van der Sluijs';
        name_wth_nr='VanderSluijs';
        switch setting
            case 1
        trigfile=1;
        cntfile=1;
            case 4 %3 uur burst
        trigfile = ['G:\MDO\Data\' name '\20120327_VanderSluijsPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120327_VanderSluijsPain2.cnt'];                
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120321_VanderSluijsPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120321_VanderSluijsPain1.cnt'];
            case 2 %2 weken burst
        trigfile = ['G:\MDO\Data\' name '\20120411_VanderSluijsPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120411_VanderSluijsPain2.cnt'];                
        end 
    case 44
        name='44 De Gunst';
        name_wth_nr='DeGunst';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120326_DeGunstPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120326_DeGunstPain1.cnt'];
            case 2
        trigfile=1;
        cntfile=1;
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120516_p44Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120516_p44Pain3.cnt']; 
        end 
    case 45
        name='45 Tragter';
        name_wth_nr='Tragter';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120326_TragterPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120326_TragterPain1.cnt'];
            case 2
        trigfile=1;
        cntfile=1;
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120509_p45Pain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120509_p45Pain3.cnt']; 
        end 
    case 46
        name='46 Jansen';
        name_wth_nr='Jansen';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120326_JansenPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120326_JansenPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120410_JansenPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120410_JansenPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120507_JansenPain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120507_JansenPain3.cnt']; 
        end 
    case 47
        name='47 Sloot';
        name_wth_nr='Sloot';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120326_SlootPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120326_SlootPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120410_SlootPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120410_SlootPain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end 
    case 48
        name='48 PenningsScholten';
        name_wth_nr='Pennings';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120326_PenningsPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120326_PenningsPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120412_PenningsPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120412_PenningsPain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end 
    case 49
        name='49 Hoek';
        name_wth_nr='Hoek';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120326_HoekPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120326_HoekPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120410_HoekPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120410_HoekPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120503_HoekPain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120503_HoekPain3.cnt']; 
        end 
    case 50
        name='50 Horstman';
        name_wth_nr='Horstman';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120327_HorstmanPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120327_HorstmanPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120412_HorstmanPain22.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120412_HorstmanPain22.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end 
    case 51
        name='51 Breuker';
        name_wth_nr='Breuker';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120327_BreukerPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120327_BreukerPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120413_BreukerPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120413_BreukerPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120504_BreukerPain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120504_BreukerPain3.cnt']; 
        end 
    case 52
        name='52 Visscher';
        name_wth_nr='Visscher';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120327_VisscherPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120327_VisscherPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120412_VisscherPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120412_VisscherPain2.cnt'];
            case 3
        trigfile = ['G:\MDO\Data\' name '\20120504_VisscherPain3.trg']; 
        cntfile  = ['G:\MDO\Data\' name '\20120504_VisscherPain3.cnt']; 
        end 
    case 53
        name='53 Appelman';
        name_wth_nr='Appelman';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120327_AppelmanPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120327_AppelmanPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120411_AppelmanPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120411_AppelmanPain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end 
    case 54
        name='54 Goossen';
        name_wth_nr='Goossen';
        switch setting
            case 1
        trigfile = ['G:\MDO\Data\' name '\20120327_GoossenPain1.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120327_GoossenPain1.cnt'];
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120410_GoossenPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120410_GoossenPain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end 
   case 55
        name='55 Riepen';
        name_wth_nr='Riepen';
        switch setting
            case 1
        trigfile = 1;
        cntfile  = 1;
            case 2
        trigfile = ['G:\MDO\Data\' name '\20120412_RiepenPain2.trg'];
        cntfile  = ['G:\MDO\Data\' name '\20120412_RiepenPain2.cnt'];
            case 3
        trigfile=1;
        cntfile=1;
        end      
end   
