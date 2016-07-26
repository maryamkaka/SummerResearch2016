function [sound, sequence] = audioGen()
    %parameters8
    f1 = 250;                   %reg tone freq
    f2 = 500;                   %odd tone freq
    toneLength = 0.2;           %length of time tone is played (sec)
    restTime = 1;               %length of rest time (sec)
    count = 5;                  %number of odd tones 
    thresh = 0.2;               %freq of odd tone
    
    %other variables
    fs = 8192;                  
    t = [0:1/fs:toneLength];    
    blank = zeros(1, fs*restTime);
    tone = @(f) sin(2*pi*f*t);
    sound = [blank, tone(f1), blank];
    sequence = [f1];
    oddCount = 0; 
       
    while true
        if(random('unif', 0, 1) >= thresh)
            f = f1;
        else 
            f = f2; 
            oddCount = oddCount + 1; 
        end 
        
        sequence = [sequence f]; 
        sound = [sound tone(f) blank];
        
        if(oddCount == count) 
            break;
        end 
    end    
end 