%addpath benchmarks

% clear all;
% close all;
% 
% clc;

f = @(varargin) ['c:/img/BSD500/BSR/' varargin{:}];

eval_set = 'test';

imgDir = f('BSDS500/data/images/', eval_set);
gtDir = f('BSDS500/data/groundTruth/val', eval_set);
inDir = ['c:/img/BSD500/voronoi/', eval_set];
outDir = ['c:/img/BSD500/voronoi/' , eval_set, 'val_eval'];
mkdir(outDir);

thinpb = true;
maxDist = 0.0075;
nthresh = 1;

% running all the benchmarks can take several hours.
tic;
boundaryBench(imgDir, gtDir, inDir, outDir, nthresh, maxDist, thinpb)
toc;

%%
plot_eval(outDir);
