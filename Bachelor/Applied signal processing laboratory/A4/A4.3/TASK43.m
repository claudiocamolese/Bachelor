%% PART3 
%RECORD OF MY VOICE
fs = 44100; % sampling frequency in Hz
T = 3; % recording time in seconds
myVoice = audiorecorder(fs, 24, 1); % create audiorecorder object
disp('Say my name......');
recordblocking(myVoice, T); % record audio for T seconds
s = getaudiodata(myVoice); % retrieve the audio data
Ts=1/fs;
%PLOT
t = 0:Ts:T-Ts; % create time vector
figure
plot(t, s); % plot the signal
xlabel('Time (s)');
ylabel('Amplitude');
title('Recorded Voice Signal');

N= T/Ts;
fres = fs/N;

S = fft(s); % compute the Fourier transform
S_shifted = fftshift(S); % shift the zero-frequency component to the center
f=-fs/2:fres:fs/2-fres; % frequency vector for centered FFT
figure
plot(f, abs(S_shifted)/max(abs(S_shifted))); % normalize and plot magnitude
xlabel('Frequency (Hz)');
ylabel('|S(f)|');
title('Centered Fourier Transform of Recorded Voice Signal');

% Creating the signal with 0.5
echo_delay = 2 * fs; % delay in samples
attenuation = 0.5; % attenuation factor
s2 = [s; zeros(echo_delay, 1)] + [zeros(echo_delay, 1); attenuation * s]; 
s3 = shiftPitch(s, 4); % use a pitch shifting function

S2 = fft(s2); % compute the Fourier transform for echoed signal
S2_shifted = fftshift(abs(S2)); % shift the zero-frequency component to the center
S3 = fft(s3); % compute the Fourier transform for pitch-shifted signal
S3_shifted = fftshift(abs(S3)); % shift the zero-frequency component to the center

% Determine the maximum length among the signals
max_len = max([length(s), length(s2), length(s3)]);

% Zero-pad the signals to have the same length
s1_padded = [s; zeros(max_len - length(s), 1)];
s2_padded = [s2; zeros(max_len - length(s2), 1)];
s3_padded = [s3; zeros(max_len - length(s3), 1)];
S1 = fft(s1_padded); % compute the Fourier transform for padded original signal
S1_shifted = fftshift(S1); % shift the zero-frequency component to the center
S2 = fft(s2_padded); % compute the Fourier transform for padded echoed signal
S2_shifted = fftshift(S2); % shift the zero-frequency component to the center
S3 = fft(s3_padded); % compute the Fourier transform for padded pitch-shifted signal
S3_shifted = fftshift(S3); % shift the zero-frequency component to the center

% Frequency vector for centered FFT
f = linspace(-fs/2, fs/2, max_len);

% Plotting
figure;
subplot(3, 1, 1);
plot(f, abs(S1_shifted)/max(abs(S1_shifted)));
xlabel('Frequency (Hz)');
ylabel('|S1(f)|');
title('Centered Fourier Transform of Original Signal');

subplot(3, 1, 2);
plot(f, abs(S2_shifted)/max(abs(S2_shifted)));
xlabel('Frequency (Hz)');
ylabel('|S2(f)|');
title('Centered Fourier Transform of Echoed Signal');

subplot(3, 1, 3);
plot(f, abs(S3_shifted)/max(abs(S3_shifted)));
xlabel('Frequency (Hz)');
ylabel('|S3(f)|');
title('Centered Fourier Transform of Pitch-Shifted Signal');



%%S
% Play original signal
disp('Playing original signal:');
sound(s1_padded, fs);
pause(T + 2); % wait until playback finishes

% Play echoed signal
disp('Playing echoed signal:');
sound(s2_padded, fs);
pause(T + 2); % wait until playback finishes

% Play pitch-shifted signal
disp('Playing pitch-shifted signal:');
sound(s3_padded, fs);
pause(T + 2); % wait until playback finishes

NFFT = 1024; % length of each segment
window = hamming(NFFT); % window function
noverlap = NFFT/2; % overlap between segments

% Original signal spectrogram
figure;
spectrogram(s, window, noverlap, NFFT, fs, 'yaxis');
title('Spectrogram of Original Signal');

% Echoed signal spectrogram
figure;
spectrogram(s2, window, noverlap, NFFT, fs, 'yaxis');
title('Spectrogram of Echoed Signal');

% Pitch-shifted signal spectrogram
figure;
spectrogram(s3, window, noverlap, NFFT, fs, 'yaxis');
title('Spectrogram of Pitch-Shifted Signal');
