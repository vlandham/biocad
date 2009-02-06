function output_args = tstoweb( f1,f2,f3 )

normalD=importdata(f1);
tumorD=importdata(f2);
[genesize normalsize]=size(normalD);
[genesize tumorsize]=size(tumorD);
 samplesize=normalsize+tumorsize;

[h,significance,ci,stats] = ttest2(normalD(:,:)',tumorD(:,:)');
    pvalue=significance;tvalue=stats.tstat;
    R=mean(normalD(:,:)')-mean(tumorD(:,:)');
    S=R./tvalue;

r=R;s=S;
sprctile = prctile(s,[1:100]);  
for j=1:99
 sindex{j}=find(s>=sprctile(j)&s<sprctile(j+1));   
end
for alpha=1:100
  salpha=sprctile(alpha);
  for j=1:99
  tt=[];
tt=r(sindex{j})./(s(sindex{j})+salpha);
v(j)=mad(tt);
    end
 cv(alpha)=std(v)/mean(v);
end
s0=sprctile(find(cv==min(cv))); 
newtvalue=abs(R./(S+s0));
index1=find(pvalue>=0.1);

samplesize=normalsize+tumorsize;
wholeD=[normalD tumorD];
wholeD1=wholeD(index1,:);

permtimes=100;
 abstvalue3=[];
for j=1:permtimes
       permindex = randperm(samplesize);
       normalindex=permindex(1:normalsize);
       normalD1=wholeD1(:,normalindex);
       tumorindex=permindex(normalsize+1:samplesize);
       tumorD1=wholeD1(:,tumorindex);
       r=[];s=[];
       [h,significance,ci,stats] = ttest2(normalD1',tumorD1');
       r=mean(normalD1')-mean(tumorD1');s=r./stats.tstat;
       nanindex=isnan(s);s(find(nanindex==1))=0;
       tvalue1=r./(s+s0);
       abstvalue=abs(tvalue1);   
       abstvalue3=[abstvalue3 abstvalue];
end
      sortabstvalue=sort(abstvalue3,'descend');
      permarraysize=length(sortabstvalue);
      pvaluethreshold=0.0001;
      thresholdindex=round(permarraysize*pvaluethreshold);
      IX=find(newtvalue>sortabstvalue(thresholdindex));
          
      for i=1:length(IX)
          [rte,positionindex]=min(abs(sortabstvalue-newtvalue(IX(i)))); 
          newpvalue(i)=positionindex/permarraysize;   
      end
       
x=IX';y=newpvalue';
outputMatrix=[x y];
output_args=outputMatrix;
dlmwrite(f3, outputMatrix, 'delimiter', '\t');