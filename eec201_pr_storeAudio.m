%% Importing audio

% enter audio file and seconds
prompt = 'Enter audio file title: ';
prompt2 = 'Enter number of seconds: ';

% store entries
x = input(prompt)
seconds = input(prompt2)

% audioread - store audio files
%answer = inputdlg(prompt)
[y, Fs] = audioread(x);
samples = [1 seconds*Fs]
[y2, Fs] = audioread(x, samples);

% plot fft

Y2 = fft(y2,54000);
subplot(2,1,1)
stem(abs(Y2))
subplot(2,1,2)
spectrogram(y2,54000,[],[], Fs,'yaxis')

