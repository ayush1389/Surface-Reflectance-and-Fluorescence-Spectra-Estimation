clc;
clear all;

%% Loading the dataset
filename = 'McNamara-Boswell_4x6x1_qe_0.10.mat';
filename = fullfile('data', filename);
load(filename);
nSamples = size(measVals, 3);

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

%% Loading illuminant data
filename = fullfile('camera', 'illuminants');
illuminant = ReadSpectra(filename, wave);
illuminant = Energy2Quanta(wave, illuminant);
nChannels = size(illuminant, 2);

%% Extending camera parameters for all samples
cameraGain = repmat(cameraGain,[1 1 nSamples]);
cameraOffset = repmat(cameraOffset,[1 1 nSamples]);

%% Estimation parameters
alpha = 0.1;
beta = 0.1;
gamma = 0.1;

%% Loading the basis functions
nBasisRefl = 5;
nBasisEx = 12;
nBasisEm = 12;

