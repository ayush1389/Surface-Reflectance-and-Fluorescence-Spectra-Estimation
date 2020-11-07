function fl = SetFluorophoreData(fl, field, val)

switch field
    case 'emission'
        val = max(val, 0);
        deltaWave = GetFluorophoreData(fl, 'deltawave');
        qe = 1/(sum(val)*deltaWave);
        val = val*qe;
        fl.emission = val(:);
        
    case 'excitation'
        val = max(val, 0);
        val = val/max(val);
        fl.excitation = val(:);
    
    case 'name'
        fl.name = val;
        
    case 'solvent'
        fl.solvent  = val;
        
    case 'wave'
        prevWave = GetFluorophoreData(fl, 'wave');
        wave = val(:);
        fl.wave = wave;
        
        newEmission = interp1(prevWave, GetFluorophoreData(fl, 'emission'), wave);
        fl = SetFluorophoreData(fl, 'emission', newEmission);
        
        newExcitation = interp1(prevWave, GetFluorophoreData(fl, 'excitation'), wave);
        fl = SetFluorophoreData(fl, 'excitation', newExcitation);
        
end
end