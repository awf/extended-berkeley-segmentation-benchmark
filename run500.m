%addpath benchmarks

% clear all;
% close all;
% 
% clc;

f = @(x) ['c:/img/BSD500/BSR/' x];

imgDir = f('BSDS500/data/images/val');
gtDir = f('BSDS500/data/groundTruth/val');
inDir = f('voronoi/val');
outDir = f('voronoi/val_eval');
mkdir(outDir);

% running all the benchmarks can take several hours.
tic;
allBench(imgDir, gtDir, inDir, outDir)
toc;

plot_eval(outDir);
