function [res, wave] = ReadSpectra(filename, wave)
% Read in spectral data and interpolate to the specified wavelengths
temp = load(filename);
if isfield(temp, 'data')
    data = temp.data;
else
    data = []
end

if isfield(temp, 'wavelength')
    wavelength = temp.wavelength;
else
    wavelength = [];
end

if length(wavelength) ~= size(data,1)
    error('Mismatch between wavelength and data in %s', filename);
end

if exist('wave') ~= 1
    wave = wavelength;
end

res = interp1(wavelength(:), data, wave(:));

end
