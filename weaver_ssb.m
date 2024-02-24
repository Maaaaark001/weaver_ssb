clear;
Fs=4e6;
L=4e5;
T=1/Fs;
t = (0:L-1)*T;
fl=300;
fh=3e3;
fa=1e3;
fg=fh+fl;
f0=fg/2;


Sig=cos(2*pi*fa*t)+cos(2*pi*fl*t)+cos(2*pi*fh*t);

Wc=2*fg/Fs;
[b,a]=butter(4,Wc);
Sig_Filter=filter(b,a,Sig);

figure(1)
Y=fft(Sig_Filter);
P1 = fftshift(abs(Y/L));
f = linspace(-Fs/2,Fs/2,L);
plot(f,20*log10(P1)) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])


Sig0_I=Sig.*cos(2*pi*f0*t);
Sig0_Q=Sig.*sin(2*pi*f0*t);

Wc=2*f0/Fs;
[b,a]=butter(4,Wc);
Sig0_I=filter(b,a,Sig0_I);
Sig0_Q=filter(b,a,Sig0_Q);

figure(2)
subplot(2,1,1)
Y=fft(Sig0_I);
P1 = fftshift(abs(Y/L));
f = linspace(-Fs/2,Fs/2,L);
plot(f,20*log10(P1)) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])

subplot(2,1,2)
Y=fft(Sig0_Q);
P1 = fftshift(abs(Y/L));
f = linspace(-Fs/2,Fs/2,L);
plot(f,20*log10(P1)) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])


f1=1e6+f0;
USB=Sig0_I.*cos(2*pi*f1*t)+Sig0_Q.*sin(2*pi*f1*t);
f1=1e6-f0;
LSB=Sig0_I.*cos(2*pi*f1*t)-Sig0_Q.*sin(2*pi*f1*t);

figure(3)
subplot(2,1,1)
Y=fft(USB);
P1 = fftshift(abs(Y/L));
f = linspace(-Fs/2,Fs/2,L);
plot(f,20*log10(P1)) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])
xlim([f1-1e4 f1+1e4])
subplot(2,1,2)
Y=fft(LSB);
P1 = fftshift(abs(Y/L));
f = linspace(-Fs/2,Fs/2,L);
plot(f,20*log10(P1)) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])
xlim([f1-1e4 f1+1e4])
