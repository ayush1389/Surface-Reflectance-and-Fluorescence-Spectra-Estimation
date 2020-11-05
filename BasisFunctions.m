function basis = BasisFunctions(type, wave, n)

switch type
    case 'reflectance'
        filename = 'macbethChart.mat';
        filename = fullfile('data', filename);
        data = ReadSpectra(filename, wave);
        
    case 'emission'
        
    case 'excitation'
        
end

basis = pca(data','centered',false); 
basis = basis(:,1:n);

end