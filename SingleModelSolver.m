function [estRefl, weightsRefl, estEm, weightsEm, estEx, weightsEx, predRefl, predFl] = SingleModelSolver(pixelVal, cameraMat, cameraGain, illuminant, basisRefl, basisEm, basisEx, alpha, beta, gamma, maxIter)

%% Count variables according to paper
% Number of spectral bins  : nWaves    <--> d
% Number of camera filters : nFilters  <--> i
% Number of illuminants    : nChannels <--> j

%% Corresponding notations of the input variables as per the paper
% pixelVal    <--> M  --> nFilters * nChannels
% cameraMat   <--> C  --> nWaves * nFilters
% cameraGain  <--> G  --> nFilters * nChannels
% illuminant  <--> L  --> nWaves * nChannels
% basisRefl   <--> Br --> nWaves * nBasisRefl
% basisEx     <--> Bx --> nWaves * nBasisEx
% BasisEm     <--> Bm --> nWaves * nBasisEm

%% Corresponding notations of the output variables as per the paper and their order
% estRefl     <--> r  --> nWaves * 1
% weightsRefl <--> wr --> nBasisRefl * 1
% estEm       <--> em --> nWaves * 1
% weightsEm   <--> wm --> nBasisEm * 1
% estEx       <--> ex --> nWaves * 1
% weightsEx   <--> wx --> nBasisEx * 1
% predRefl    <--> mr --> nFilters * nChannels (not mentioned in the paper explicitly)
% predFl      <--> mf --> nFilters * nChannels (not mentioned in the paper explicitly)

%% Initialising the count variables
nWaves =  size(cameraMat, 1);
nFilters = size(pixelVal, 1);
nChannels = size(pixelVal, 2);
nBasisRefl = size(basisRefl, 2);
nBasisEx = size(basisEx, 2);
nBasisEm = size(basisEm, 2);

%% Normalising camera gain values
maxVal = max(cameraGain(:));
cameraGain = cameraGain/maxVal;
illuminant = illuminant*maxVal;

%% Difference operator
posPart = [eye(nWaves-1) zeros(nWaves-1,1)];
negPart = [zeros(nWaves-1,1) eye(nWaves-1)];
nabla = posPart - megPart;
nablaRefl = nabla * basisRefl;
nablaEx = nabla * basisEx;
nablaEm = nabla * basisEm;

%% Initial guess of weights
weightsEx = ones(nBasisEx, 1)/nBasisEx;

%% Convex optimisation
for it = 1 : maxIter

	cvx_begin quiet
        cvx_precision default
        variables weightsRefl(nBasisRefl, 1) weightsEm(nBasisEm, 1)
        minimize sum(sum_square_abs(pixelVal - cameraGain.*(cameraMat'*diag(basisRefl*weightsRefl)*illuminant) - cameraGain.*(cameraMat'*tril((basisEm*weightsEm)*(basisEx*weightsEx)',-1)*illuminant))) + alpha*norm(nablaRefl*weightsRefl,2) + beta*norm(nablaEm*weightsEm,2) + gamma*norm(nablaEx*weightsEx,2)
        subject to
            1 >= basisRefl*weightsRefl >= 0
            basisEm*weightsEm >= 0
    cvx_end

    cvx_begin quiet
        cvx_precision default
        variables weightsRefl(nBasisRefl,1) weightsEx(nBasisEx, 1)
        minimize sum(sum_square_abs(pixelVal - cameraGain.*(cameraMat'*diag(basisRefl*weightsRefl)*illuminant) - cameraGain.*(cameraMat'*tril((basisEm*weightsEm)*(basisEx*weightsEx)',-1)*illuminant))) + alpha*norm(nablaRefl*weightsRefl,2) + beta*norm(nablaEm*weightsEm,2) + gamma*norm(nablaEx*weightsEx,2)
        subject to
            1 >= basisRefl*weightsRefl >= 0
            basisEx*weightsEx >= 0
    cvx_end

end

%% Estimating Reflectance
estRefl = basisRefl * weightsRefl;

%% Estimating Fluorescence

% Using defintion
estEx = basisEx * weightsEx;
estEm = basisEm * weightsEm;

% Calculating Donaldson matrix and decomposing it
Donaldson = tril(estEm * estEx', -1);
[U, S, V] = svd(Donaldson);

estEm = U(:,1)*sign(min(U(:,1)));
estEx = S(1,1)*V(:,1)*sign(min(V(:,1)));

% Rescaling according to excitation values
maxEx = max(estEx);
estEx = estEx/maxEx;
estEm = estEm/maxEx;

%% Compute pixel intensities predictions
predRefl = cameraGain.*(cameraMat' * diag(estRefl) * illuminant);
predFl = cameraGain.*(cameraMat' * Donaldson * illuminant);

end
