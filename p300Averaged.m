clear; 

%% Constants (Data measurement parameters)
TONE_LENGTH = 0.2;
REST_LENGTH = 1;
Fs = 1000; 
DATA_OFFSET = 1000;
ODD_FREQ = 500;

ISI = TONE_LENGTH + REST_LENGTH;
time = [0:1/Fs:ISI] - TONE_LENGTH;

%% Data Import 
% import EEG data file
[filename, pathname] = uigetfile({'*.csv','Comma Seperated Values (*.csv)'; ...s
   '*.*',  'All Files (*.*)'}, 'Select a file');
data = readtable([pathname, filename]); 
data = data(:, 1:end-2);

%import audio sequence information
[filename, pathname] = uigetfile({'*.mat','MATLAB Data (*.mat)'; ...
   '*.*',  'All Files (*.*)'}, 'Select Audio Sequence Data', pathname);
s = load([pathname, filename]);
p300Events = find(s.sequence == ODD_FREQ);
nEvents = length(s.sequence);

headings = data.Properties.VariableNames;

%% detrending data
for i = 2:size(data,2)
    data.(i) = detrend(data.(i));
end 

%% Data Extraction, Segmentation and Averaging
for i = 2:size(data, 2)
    segmentedData(i-1,:,:) = reshape(data.(i)(DATA_OFFSET+1:Fs*ISI*nEvents+DATA_OFFSET), Fs*ISI, [])';
    for j = 1:length(p300Events)
        P300(i-1, j, :) = segmentedData(i-1, p300Events(j), :);
    end 
    
    averagedData(i-1, :) = mean(P300(i-1, :, :));
    
    %plot
    figure(i-1)
    plot(time(1:end-1), averagedData(i-1, :));
    title(headings{i});
    xlabel('Time (s)');
end 