function [estRefl, weightsRefl, estEm, weightsEm, estEx, weightsEx, predRefl, predFl] = SingleModel(pixelVal, cameraMat, cameraGain, cameraOffset, illuminant, basisRefl, basisEm, basisEx, alpha, beta, gamma, maxIter)

%% Count variables according to paper
% Number of spectral bins  : nWaves    <--> d
% Number of camera filters : nFilters  <--> i
% Number of illuminants    : nChannels <--> j

%% Corresponding notations of the input variables as per the paper
% pixelVal    <--> M  --> nFilters * nChannels * nSamples
% cameraMat   <--> C  --> nWaves * nFilters
% cameraGain  <--> G  --> nFilters * nChannels * nSamples
% illuminant  <--> L  --> nWaves * nChannels
% basisRefl   <--> Br --> nWaves * nBasisRefl
% basisEx     <--> Bx --> nWaves * nBasisEx
% BasisEm     <--> Bm --> nWaves * nBasisEm
% cameraOffset        --> nFilters * nChannels * nSamples (for practical purposes)

%% Corresponding notations of the output variables as per the paper and their order
% estRefl     <--> r  --> nWaves * nSamples
% weightsRefl <--> wr --> nBasisRefl * nSamples
% estEm       <--> em --> nWaves * nSamples
% weightsEm   <--> wm --> nBasisEm * nSamples
% estEx       <--> ex --> nWaves * nSamples
% weightsEx   <--> wx --> nBasisEx * nSamples
% predRefl    <--> mr --> nFilters * nChannels * nSamples (not mentioned in the paper explicitly)
% predFl      <--> mf --> nFilters * nChannels * nSamples (not mentioned in the paper explicitly)
 
%% Initialising the count variables
nWaves =  size(cameraMat, 1);
nFilters = size(pixelVal, 1);
nChannels = size(pixelVal, 2);
nBasisRefl = size(basisRefl, 2);
nBasisEx = size(basisEx, 2);
nBasisEm = size(basisEm, 2);
nSamples = size(pixelVal, 3);

%% Initialising output variables as zero
estRefl = zeros(nWaves, nSamples);
weightsRefl = zeros(nBasisRefl, nSamples);

estEm = zeros(nWaves, nSamples);
weightsEm = zeros(nBasisEm, nSamples);

estEx = zeros(nWaves, nSamples);
weightsEx = zeros(nBasisEx, nSamples);

predRefl = zeros([nFilters, nChannels, nSamples]);
predFl = zeros([nFilters, nChannels, nSamples]);

%% Processing each sample

for i = 1:nSamples
    fprintf('Processing Sample %d of %d ... ', i, nSamples); 
	correctPixelVal = pixelVal(:,:,i) - cameraOffset(:,:,i);
	[estRefl(:,i), weightsRefl(:,i), estEm(:,i), weightsEm(:,i), estEx(:,i), weightsEx(:,i), predRefl(:,:,i), predFl(:,:,i)] = ...
		SingleModelSolver(correctPixelVal, cameraMat, cameraGain(:,:,i), illuminant, basisRefl, basisEm, basisEx, alpha, beta, gamma, maxIter);
    fprintf('Done.\n');
end

fprintf('Finished processing all %d samples.\n', nSamples);

end
