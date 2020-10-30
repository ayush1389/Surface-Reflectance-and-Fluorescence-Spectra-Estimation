function photons = Energy2Quanta(wavelength, energy)
% Convert energy (watts) to number of photons
wavelength = wavelength(:); % convert into column matrix

h = 6.626176e-034; % Planck's constant
c = 2.99792458e+8; % Speed of light

if ndims(energy) == 3
    [n,m,w] = size(energy);
    if w ~= length(wavelength)
        error('Energy2Quanta:  energy must have third dimension length equal to numWave');
    end
    energy = reshape(energy,n*m,w)';
    photons = (energy/(h*c)) .* (1e-9 * wavelength(:,ones(1,n*m)));
    photons = reshape(photons',n,m,w);
else
    [n,m] = size(energy);
    if n ~= length(wavelength)
        error('Energy2Quanta:  energy must have row length equal to numWave');
    end
    photons = (energy/(h*c)) .* (1e-9 * wavelength(:,ones(1,m)));
end

