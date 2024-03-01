clear;
Fs = 4e6;
L = 4e5;
T = 1 / Fs;
t = (0:L - 1) * T;
fl = 300; %最低有效信号频率
fh = 3e3; %最高有效信号频率
fa = 1e3; %带内信号
fg = fh + fl;
f0 = fg / 2; %weaver基带第一次混频频率

Sig = cos(2 * pi * fa * t) + cos(2 * pi * fl * t) + cos(2 * pi * fh * t); %三频信号

Wc = 2 * fg / Fs;
[b, a] = butter(4, Wc);
Sig_Filter = filter(b, a, Sig);

figure(1) %基带频谱展示
Y = fft(Sig_Filter);
P1 = fftshift(abs(Y / L));
f = linspace(-Fs / 2, Fs / 2, L);
plot(f, 20 * log10(P1))
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])

Sig0_I = Sig .* cos(2 * pi * f0 * t); %带内正交混频，产生IQ信号
Sig0_Q = Sig .* sin(2 * pi * f0 * t);

Wc = 2 * f0 / Fs;
[b, a] = butter(4, Wc);
Sig0_I = filter(b, a, Sig0_I);
Sig0_Q = filter(b, a, Sig0_Q); %四阶滤波滤掉一半边带频谱，由于在基带内操作，边带可以获得较高的抑制比
%                              %同时滤波器实现简单，可以用数字滤波

figure(2) %混频滤波后基带频谱展示，边带应该已被抑制
subplot(2, 1, 1)
Y = fft(Sig0_I);
P1 = fftshift(abs(Y / L));
f = linspace(-Fs / 2, Fs / 2, L);
plot(f, 20 * log10(P1))
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])

subplot(2, 1, 2)
Y = fft(Sig0_Q);
P1 = fftshift(abs(Y / L));
f = linspace(-Fs / 2, Fs / 2, L);
plot(f, 20 * log10(P1))
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])

f1 = 1e6 + f0;
USB = Sig0_I .* cos(2 * pi * f1 * t) + Sig0_Q .* sin(2 * pi * f1 * t); %USB调制
f1 = 1e6 - f0;
LSB = Sig0_I .* cos(2 * pi * f1 * t) - Sig0_Q .* sin(2 * pi * f1 * t); %LSB调制

figure(3) %可看到USB与LSB图像
subplot(2, 1, 1)
Y = fft(USB);
P1 = fftshift(abs(Y / L));
f = linspace(-Fs / 2, Fs / 2, L);
plot(f, 20 * log10(P1))
title("Single-Sided Amplitude Spectrum of USB")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])
xlim([f1 -1e4 f1 +1e4])
subplot(2, 1, 2)
Y = fft(LSB);
P1 = fftshift(abs(Y / L));
f = linspace(-Fs / 2, Fs / 2, L);
plot(f, 20 * log10(P1))
title("Single-Sided Amplitude Spectrum of LSB")
xlabel("f (Hz)")
ylabel("|P1(f)|")
ylim([-60 0])
xlim([f1 -1e4 f1 +1e4])
