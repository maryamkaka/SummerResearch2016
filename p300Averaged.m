clear; clc;

%variables
toneLength = 0.2;
restLength = 1; 
P300Events = [27, 29, 35, 39, 47];
numEvents = 47; 
fs = 1000; 
dataOffset = 1000;

ISI = toneLength + restLength;
time = [0:1/fs:ISI] - 0.2;

%select file
[filename, pathname] = uigetfile({'*.csv','Comma Seperated Values (*.csv)'; ...
   '*.*',  'All Files (*.*)'}, 'Select a file');
data = readtable([pathname, filename]); 
data = data(:, 1:end-2);

headings = data.Properties.VariableNames;

for i = 2:size(data, 2)
    segmentedData = reshape(data.(i)(dataOffset+1:fs*ISI*numEvents+dataOffset), fs*ISI, [])';
    for j = 1:length(P300Events)
        P300(j, :) = segmentedData(P300Events(j), :);
    end 
    
    averagedData(i-1, :) = mean(P300);
    
    %plot
    figure(i-1)
    plot(time(1:end-1), averagedData(i-1, :));
    title(headings{i});
    xlabel('Time (s)');
end 