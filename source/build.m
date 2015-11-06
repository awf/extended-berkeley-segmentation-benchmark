%mex CXXFLAGS="\$CXXFLAGS -O3 -DNOBLAS" correspondPixels.cc csa.cc kofn.cc match.cc Exception.cc Matrix.cc Random.cc String.cc Timer.cc drand48.c

% 2014b at least offers "-D"
mex -v -g -O -DNOBLAS correspondPixels.cc csa.cc kofn.cc match.cc Exception.cc Matrix.cc Random.cc String.cc Timer.cc

!move correspondPixels.mexw64* ..\benchmarks
