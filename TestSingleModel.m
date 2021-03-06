clc;
clear all;

%% Loading the dataset
filename = 'McNamara-Boswell_4x6x1_qe_0.10.mat';
filename = fullfile('data', filename);
load(filename);
nSamples = size(measVals, 3);
fprintf('Dataset loaded.\n');

%% Wavelength information
nWaves = length(wave);
deltaWave = wave(2) - wave(1);

%% Loading camera filter data
filename = fullfile('camera', 'filters');
filters = ReadSpectra(filename, wave);

filename = fullfile('camera', 'qe');
qe = ReadSpectra(filename, wave);

cameraMat = diag(qe) * filters;
nFilters = size(cameraMat, 2);
fprintf('Camera data loaded.\n');

%% Loading illuminant data
filename = fullfile('camera', 'illuminants');
illuminant = ReadSpectra(filename, wave);
illuminant = Energy2Quanta(wave, illuminant);
nChannels = size(illuminant, 2);
fprintf('Illuminant data loaded.\n');

%% Extending camera parameters for all samples
% cameraGain = repmat(cameraGain,[1 1 nSamples]);
% cameraOffset = repmat(cameraOffset,[1 1 nSamples]);

%% Adding Gaussian noise
measValsNoise = max(measVals + 0.01*randn(size(measVals)),0);
        
localCameraGain = repmat(cameraGain,[1 1 nSamples]);
localCameraOffset = repmat(cameraOffset,[1 1 nSamples]);
        
nF = max(max(measValsNoise,[],1),[],2);
localCameraGain = localCameraGain./repmat(nF,[nFilters nChannels 1]);
measValsNoise = measValsNoise./repmat(nF,[nFilters nChannels 1]);

%% Estimation parameters
alpha = 0.1;
beta = 0.1;
gamma = 0.1;

%% Loading the basis functions
nBasisRefl = 5;
nBasisEx = 12;
nBasisEm = 12;

basisRefl = BasisFunctions('reflectance', wave, nBasisRefl);
basisEm = BasisFunctions('emission', wave, nBasisEm);
basisEx = BasisFunctions('excitation', wave, nBasisEx);

fprintf('Basis functions generated.\n');

%% Estimation
fprintf('Beginning estimation ...\n');
maxIter = 20;
[estRefl, weightsRefl, estEm, weightsEm, estEx, weightsEx, predRefl, predFl] = ...
    SingleModel(measValsNoise, cameraMat, localCameraGain*deltaWave, localCameraOffset, illuminant, basisRefl, basisEm, basisEx, alpha, beta, gamma, maxIter);

predMeasVals = predRefl + predFl;

%% Plotting the results
figure;
plot(predMeasVals(:), measVals(:), '.');
xlabel('Predicted pixel value');
ylabel('Measured pixel value');
