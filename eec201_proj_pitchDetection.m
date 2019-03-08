%% Cepstrum Pitch Detection
% finds quefrencies of a user input audio file

clear;

[x,fs] = audioread('yes_are.wav');
ts = 1/fs;
%x1 = x(0.5*fs:0.6*fs);
n = 0:length(x)-1;
seconds = ts*n;
%plot(t*ts,x1)

L = fs*0.01; % length of frame in seconds
windowShift = fs*0.008;
length_x = length(x);
windowCenter = L/2; 
nfft = 1024; % size of fft

% initializing peak & quefrency table, and count
peakTable = zeros(1,fs/windowShift); % stores peak values
quefrencyTable = zeros(1,fs/windowShift); % stores quefrencies
pitchTable = zeros(1,fs/windowShift);
count = 1; % indexing while loop

% While loop shifts 10 ms window every iteration, creating a quefrency
% table.

while (windowCenter+L/2 <= length_x) % repeat until we reach end of audio recording
        window=x(max(windowCenter-L/2,1):windowCenter+L/2);
        windowLength=length(window);

% create window 
        window = window.*hamming(windowLength);
        window(windowLength+1:nfft)=0; % zero padding beyond length of the frame
        
% compute real cepstrum        
        X_HAT = log(abs(fft(window,nfft)))'; % real cepstrum for one frame length
        x_hat = ifft(X_HAT,nfft); % cepstrum for one frame length
   
% defines range for male speech
        ppdMaleLow=round(fs/300); % lower threshold of male voice
        ppdMaleHigh=round(fs/60); % upper threshold of male voice
        indexlow=ppdMaleLow+1;
        indexhigh=ppdMaleHigh+1;
        x_hat_Male = x_hat(indexlow:indexhigh);

% finding pmax and quefrency
        [pmax,quefrency]= max(x_hat_Male);

        if(quefrency > 500) % male voice will not be below 95 Hz
            quefrency = 0; % so cut out <95
        end
        
       % ploc=peakLocation +ppdlow-1; % changes male to female

% constructing quefrency and peak arrays        
        peakTable(count) = pmax; % stores all peak values as vector each time through loop
        quefrencyTable(count) =  quefrency; % stores all peak locations as a vector each time through loop
        
        if(quefrency < 500) && (quefrency > 250)
            pitch = fs/quefrency;
        else
            pitch = 0;
        end
        pitchTable(count) = pitch;
        
        
% shifting window and increasing count        
        windowCenter = windowCenter + windowShift; % slides window over
        count = count + 1;
end

subplot(2,1,1)
stem(quefrencyTable)
title('Quefrencies')
subplot(2,1,2)
stem(pitchTable)
title('Pitches')
ylabel('frequency [Hz]')


