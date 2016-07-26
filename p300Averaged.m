clear; clc;

%Constants (Data measurement parameters)
TONE_LENGTH = 0.2;
REST_LENGTH = 1; 
P300_Events = [27, 29, 35, 39, 47];
nEVENTS = 47; 
Fs = 1000; 
DATA_OFFSET = 1000;

ISI = TONE_LENGTH + REST_LENGTH;
time = [0:1/Fs:ISI] - TONE_LENGTH;

%select file
[filename, pathname] = uigetfile({'*.csv','Comma Seperated Values (*.csv)'; ...
   '*.*',  'All Files (*.*)'}, 'Select a file');
data = readtable([pathname, filename]); 
data = data(:, 1:end-2);

headings = data.Properties.VariableNames;

%detrending data
for i = 2:size(data,2)
    data.(i) = detrend(data.(i));
end 

for i = 2:size(data, 2)
    segmentedData(i-1,:,:) = reshape(data.(i)(DATA_OFFSET+1:Fs*ISI*nEVENTS+DATA_OFFSET), Fs*ISI, [])';
    for j = 1:length(P300_Events)
        P300(i-1, j, :) = segmentedData(i-1, P300_Events(j), :);
    end 
    
    averagedData(i-1, :) = mean(P300(i-1, :, :));
    
    %plot
    figure(i-1)
    plot(time(1:end-1), averagedData(i-1, :));
    title(headings{i});
    xlabel('Time (s)');
end 