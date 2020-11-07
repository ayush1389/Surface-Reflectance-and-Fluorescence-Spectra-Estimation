function res = GetFluorophoreData(fl, field)

res = [];

switch field
    case 'emission'
        if isfield(fl, 'emission')
           res = fl.emission;
        end
        
    case 'normalised emission'
        if isfield(fl, 'emission')
            res = fl.emission/max(fl.emission);
        end
        
    case 'peak emission'
        if isfield(fl, 'emission')
            [val, idx] = max(fl.emission);
            res = fl.wave(idx);
        end
       
    case 'excitation'
        if isfield(fl, 'excitation')
            res = fl.excitation;
        end
        
    case 'normalised excitation'
        if isfield(fl, 'excitation')
            res = fl.excitation/max(fl.excitation);
        end
        
    case 'peak excitation'
        if isfield(fl, 'excitation')
            [~, idx] = max(fl.excitation);
            res = fl.wave(idx);
        end
    
    case 'name'
        if isfield(fl, 'name')
            res = fl.name;
        end
    
    case 'solvent'
        if isfield(fl, 'solvent')
            res = fl.solvent;
        end
        
    case 'wave'
        if isfield(fl, 'wave')
            res = fl.wave;
            res = res(:);
        end
    case 'deltawave'
        if isfield(fl, 'wave')
           wave = GetFluorophoreData(fl, 'wave');
           res = wave(2) - wave(1);
        end
        
end
end