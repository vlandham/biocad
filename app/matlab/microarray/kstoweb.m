function output_args = kstoweb( f1,f2,f3 )

normalD=importdata(f1);
tumorD=importdata(f2);

[genesize samplesize]=size(normalD);

for i=1:genesize
    [H(i),P(i),KSSTAT(i)] = kstest2(normalD(i,:),tumorD(i,:));
end

pvaluethreshold=0.0001;
IX = find(P<=pvaluethreshold);

x=IX'; y=P(x)';

outputMatrix=[x y];
output_args=outputMatrix;

dlmwrite(f3, outputMatrix, 'delimiter', '\t');