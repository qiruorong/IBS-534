function output = convolveDataWithSTA(data,STA,dt)

    if nargin < 3 || isempty(dt)
        dt = .001;
    end

    N = length(data);
    L = ceil(length(STA) - 1)/2;
    
    A = zeros(2*N,1);
    A(N + (-L:L)) = STA;
    A = fftshift(A);
    
    q = zeros(2*N,1);
    q(N + round(-N/2:(N/2-1))) = data;
    
    output = ifft(fft(q).*conj(fft(A)));
    output = output((N/2)+1:(3*N/2));
    output = output*dt;