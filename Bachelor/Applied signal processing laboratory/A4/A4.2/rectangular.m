%% a function generating a unitary amplitude, T width rectangular pulse
function [x] = rect_function(t,T)
%N samples consistent to the domain extension
N=length(t);
x=zeros(1,N); 
for i=1:N
    if t(i)>=-T && t(i)<=T
        x(i)=1;
    end
end