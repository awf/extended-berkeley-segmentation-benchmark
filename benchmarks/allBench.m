function allBench(imgDir, gtDir, inDir, outDir, nthresh, maxDist, thinpb)
% function allBench(imgDir, gtDir, inDir, outDir, nthresh, maxDist, thinpb)
%
% Run boundary and region benchmarks on dataset. This does not include
% superpixel benchmarks (ASA, UE, superpixel count, EV, SSE).
%
% INPUT
%   imgDir: folder containing original images
%   gtDir:  folder containing ground truth data.
%   inDir:  folder containing segmentation results for all the images in imgDir.
%           Format can be one of the following:
%             - a collection of segmentations in a cell 'segs' stored in a mat file
%             - an ultrametric contour map in 'doubleSize' format, 'ucm2' stored in a mat file with values in [0 1].
%           Note that the superpixel benchmarks will not work suing an
%           ultrametrix contour map.
%   outDir: folder where evaluation results will be stored
%	nthresh	: Number of points in precision/recall curve.
%   MaxDist : For computing Precision / Recall.
%   thinpb  : option to apply morphological thinning on segmentation
%             boundaries before benchmarking.
%
%
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
% Updated by David Stutz <david.stutz@rwth-aachen.de>

if nargin < 7
  thinpb = true;
end;
if nargin < 6
  maxDist = 0.0075;
end;
if nargin < 5
  nthresh = 99;
end;

nmats = 0;

iids = dir(fullfile(imgDir,'*.jpg'));

for i = 1:numel(iids),
  au_progressbar_ascii(sprintf('allBench_%d', numel(iids)), i/numel(iids))
  name = iids(i).name(1:end-4);

  evFile1 = fullfile(outDir, strcat(name,'_ev1.txt'));
  evFile2 = fullfile(outDir, strcat(name, '_ev2.txt'));
  evFile3 = fullfile(outDir, strcat(name, '_ev3.txt'));
  evFile4 = fullfile(outDir, [name, '_ev4.txt']);
  evFile5 = fullfile(outDir, strcat(name, '_ev5.txt'));
  evFile6 = fullfile(outDir, strcat(name, '_ev6.txt'));
  evFile7 = fullfile(outDir, strcat(name, '_ev7.txt'));
  evFile8 = fullfile(outDir, strcat(name, '_ev8.txt'));
  if ~isempty(dir(evFile8))
    fprintf('Already did %s\n', name);
    continue;
  end;

  if exist(fullfile(inDir, name), 'dir')
    inDir_i = fullfile(fullfile(inDir, name));
  else
    inDir_i = inDir;
  end
    
  for in_ext = {'mat','bmp','png'}
    inFile = fullfile(inDir_i, [name, '.', in_ext{1}]);
    if exist(inFile, 'file')
      break
    end
  end
  gtFile = fullfile(gtDir, strcat(name, '.mat'));
  
  disp(inFile);
  if ~exist(inFile, 'file')
    warning('Skipping [%s]', inFile);
    continue
  end
  
  evaluation_bdry_image(inFile,gtFile, evFile1, nthresh, maxDist, thinpb);
  if strcmp(in_ext, 'mat')
    nmats = nmats + 1;
    evaluation_compactness_image(inFile, gtFile, evFile6);
    evaluation_asa_image(inFile, gtFile, evFile8);
    evaluation_undersegmentation_image(inFile, gtFile, evFile5);
    evaluation_reg_image(inFile, gtFile, evFile2, evFile3, evFile4, nthresh);
    evaluation_superpixels_image(inFile, gtFile, evFile7);
  end
end

collect_eval_bdry(outDir);
if nmats < 10
  warning('No superpixel eval -- only %d mats', nmats);
  return
end
  
collect_eval_compactness(outDir);
collect_eval_asa(outDir);
collect_eval_undersegmentation(outDir);
collect_eval_reg(outDir);
collect_eval_superpixels(outDir);

%
delete(sprintf('%s/*_ev1.txt', outDir));
delete(sprintf('%s/*_ev2.txt', outDir));
delete(sprintf('%s/*_ev3.txt', outDir));
delete(sprintf('%s/*_ev4.txt', outDir));
delete(sprintf('%s/*_ev5.txt', outDir));
delete(sprintf('%s/*_ev6.txt', outDir));
delete(sprintf('%s/*_ev7.txt', outDir));
delete(sprintf('%s/*_ev8.txt', outDir));
