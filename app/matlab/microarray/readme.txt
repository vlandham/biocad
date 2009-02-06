1. The file tstoweb.m is for the pooling method and the file kstoweb.m is for the KS-test.
2. Type "mcc -m  tstoweb.m" or "mcc -m  kstoweb.m" in MATLAB to generate the executable file.
3. Call the above executable file by "system("tstoweb inputfile1 inputfile2 outputfile")" or similar sentence.
4. The inputfile1 is for data from normal samples and the inputfile2 is for data from tumor samples.
5. There are two columns in the outputfile. The first column store the differential gene number in the whole gene list and the second column store the corresponding p-value.