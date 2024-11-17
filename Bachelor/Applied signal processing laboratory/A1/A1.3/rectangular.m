%% the function return a rectangular signal with A=1 if the t valus is in between -T and T, 0 otherwise. 
%% It helps us to create the filter isolating the frequencies around f0
function [x] = rect_function(t,T)
%N samples consistent to the domain extension
N=length(t);
x=zeros(1,N); 
for i=1:N
    if t(i)>=-T && t(i)<=T
        x(i)=1;
    end
end