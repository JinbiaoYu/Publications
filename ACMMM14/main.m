%
%% This is the main entry of the program.

% Auothr: Dihong Gong

% ============================Copyright=================================
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the
%    distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
% HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function main

load('morph2_young_faces','faces','age','id');

load('fgnet_faces','faces','age','id');
age4 = cat(2,age{:});
id4 = cat(2,id{:});
feat4 = [extract_feat(faces,'dsift')];


feat = feat4;
age = age4;
id = id4;
feat = log(1+0.1*feat);

[P M] = PCA(feat,0.99);
feat = P'*bsxfun(@minus,feat,M);


test_samples = 1:82;

% sigma = 1.30, mu = 5.00, rho = 2.00, accuracy = 5.1903
tic
parfor tid = 1:length(test_samples)
    mae = mtwgp_regression(feat,age,id,test_samples(tid));
    E{tid} = mae;
end
E = cat(2,E{:});
mean(E)
clear E;
toc
end

