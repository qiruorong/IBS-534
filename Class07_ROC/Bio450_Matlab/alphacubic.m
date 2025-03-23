function y = alphacubic(t,ypeak,tau,bkg,tpeak);

y = nan(1,numel(t));
taurate = 1/tau;
tzero = tpeak - 3/taurate;

t = t - tzero;
a = (ypeak-bkg)/27*exp(3)*taurate^3;
y = a * t.^3 .* exp(-taurate*t) + bkg;
i = find(t<0);
if ~isempty(i)
    y(i) = bkg;
end
