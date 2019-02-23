function m = mean_wo_nan(x)
% mean_wo_nan
% Calc the mean eliminating NaN

[nrows ncolumns] = size(x);
ndata = 0;
m = zeros(1, ncolumns);
for i = 1:nrows
    nanflag = false;
    for j = 1:ncolumns
        if isnan( x(i,j) )
            nanflag = true;
            break;
        end
    end
    if ~nanflag
       m = m + x(i,:);
       ndata = ndata + 1;
    end
end

m = m / ndata;