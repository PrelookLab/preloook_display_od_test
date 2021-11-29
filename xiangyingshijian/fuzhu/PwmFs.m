function[s]=PwmFs(YuanShiShuJu,Fs)
%%输入数据和采样率，获得最大值一边的四分之一的fft前十的振幅，频率，建议平均样本数量

[l,~]=size(YuanShiShuJu); %获取大小
T = 1/Fs;             % 采样间隔
L1=floor(l/4);  % 长度
L=L1+mod(L1,2);
t = (0:L-1)*T;        % 时间长度

if mean(YuanShiShuJu(1:30))>mean(YuanShiShuJu(end-30,end))%判断前大还是后大
    fftYuanshi=YuanShiShuJu(1:L);%截取fft样本
else
    L2=L*3;
    L3=L2+mod(L2,2)+mod(l,2)+1;
    fftYuanshi=YuanShiShuJu(L3:end);%截取fft样本
end

    fftYuanshi=fftYuanshi-mean(fftYuanshi);
    Y = fft(fftYuanshi);
    %计算双侧频谱 P2。然后基于 P2 和偶数信号长度 L 计算单侧频谱 P1。

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    %定义频域 f 并绘制单侧幅值频谱 P1。与
    f = Fs*(0:(L/2))/L;

    [pks,locs]=findpeaks(P1,f,"SortStr","descend");
    s(:,1)=pks(1:10,1);
    s(:,2)=locs(1,1:10).';
    s(:,3)=Fs./s(:,2);
end
