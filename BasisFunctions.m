function basis = BasisFunctions(type, wave, n)

switch type
    case 'reflectance'
        filename = 'macbethChart.mat';
        filename = fullfile('data', filename);
        data = ReadSpectra(filename, wave);
        
    case 'emission'
        filename = fullfile('data', 'McNamara-Boswell');
        flSet = ReadAllFluorophores(filename, [0 max(wave)], [min(wave) Inf], wave);
        nWaves = length(wave);
        nFluorophores = length(flSet);
        data = zeros(nWaves, nFluorophores);
        for i = 1:nFluorophores
            data(:,i) = GetFluorophoreData(flSet(i), 'normalised emission'); 
        end
        
    case 'excitation'
        filename = fullfile('data', 'McNamara-Boswell');
        flSet = ReadAllFluorophores(filename, [0 max(wave)], [min(wave) Inf], wave);
        nWaves = length(wave);
        nFluorophores = length(flSet);
        data = zeros(nWaves, nFluorophores);
        for i = 1:nFluorophores
            data(:,i) = GetFluorophoreData(flSet(i), 'normalised excitation'); 
        end
        
end

basis = pca(data','centered',false); 
basis = basis(:,1:n);

end