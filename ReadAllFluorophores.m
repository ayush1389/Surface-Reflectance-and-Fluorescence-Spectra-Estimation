function flSet = ReadAllFluorophores(dirname, peakEmRange, peakExRange, wave)

files = dir(fullfile(dirname, '*.mat'));
nFiles = length(files);
flSet = [];

for i = 1:nFiles
   
    filename = fullfile(dirname, files(i).name);
    fl = ReadFluorophore(filename, wave);
    
    if GetFluorophoreData(fl, 'peak emission') < peakEmRange(1) || GetFluorophoreData(fl, 'peak emission') > peakEmRange(2)
        continue;
    end
    
    if GetFluorophoreData(fl, 'peak excitation') < peakExRange(1) || GetFluorophoreData(fl, 'peak excitation') > peakExRange(2)
        continue;
    end
    
    fl = SetFluorophoreData(fl, 'wave' ,wave);
    flSet = [flSet; fl];
    
end

end