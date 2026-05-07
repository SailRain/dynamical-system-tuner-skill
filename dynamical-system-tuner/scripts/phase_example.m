clear; clc;
close all;
format long

%% ------ simulation settings ------ %%
tic
tspan = 0:1e-6:1;   %tspan = tstart:step:tend
% tspan = [0 0.004];
start = 1;  start1 = 1;     %tspan = tstart:step:tend
% Y0=[2e-2; -5];  %initial conditions
Y0=[1 1];  %initial conditions
[t,y]=ode45Ps(@sys4,tspan,Y0); %ODE solver
param_sys4 = evalin('base','param_sys4');
param_text = sprintf(['Current params: Y0=[%.4g %.4g], t=[%.4g %.4g], dt=%.4g, ', ...
    '%s'],Y0(1),Y0(2),tspan(1),tspan(end),tspan(2)-tspan(1),param_sys4);
toc;

%% ------ 3D and 2D phase portraits ------ %%
% figure()
% plot3(y(2450000:end,1),y(2450000:end,2),y(2450000:end,3),'b'); %3D phase portrait

figure()
plot(y(1e5:end,1),y(1e5:end,2),'b');%2D phase portrait
sgtitle(param_text,'Interpreter','none');

%% ------ time responses of all state variables ------ %%
figure()
  subplot(2, 1, 1); 
 plot(t(1:end,1), y(1:end,1),'b');
  xlabel('t'); ylabel('X');
  title('i vs Time');
    %  xlim([t(start1), t(end)]);      


  subplot(2, 1, 2); 
 plot(t(1:end,1), y(1:end,2),'b');
  xlabel('t'); ylabel('Y');
  title('x vs Time');
    %  xlim([t(start1), t(end)]);       
 
sgtitle(param_text,'Interpreter','none');

%% --------- system equation and parameters ----------%%
 function dy=sys4(t,y)
     dy=zeros(2,1);
     persistent flag

     A = 1.5e-4;      F = 400;  RM = 1500;
     C = 100e-9;
     R0 = 2500; C0 = 200e-9; m = 1;
     eps1 = 0.4; eps2 = 1; eps3 = 0.2; 
    %  Iext = 1.3e-3;
     Iext = A*cos(F*t);

     E = 0.5;
T = 2*pi/F;              % 对应周期
B = 0.7;                 % 占空比：正电平持续 B*T（可调 0~1）
% tau = mod(t, T);
% if tau < B*T
%     Iext =  A;
% else
%     Iext = -A;
% end

if isempty(flag)
    assignin('base','param_sys4',sprintf(['A=%.4g, F=%.4g, B=%.4g, RM=%.4g, ', ...
        'C=%.4g, R0=%.4g, C0=%.4g, m=%.4g, eps=[%.4g %.4g %.4g], E=%.4g'], ...
        A,F,B,RM,C,R0,C0,m,eps1,eps2,eps3,E));
    flag = 1;
end

% tau = mod(t, T);
% if tau < B*T
%     Iext =  A;
% else
%     Iext = -A;
% end



     dy(1) = (Iext-(y(2)^2-m)*(y(1)-E)/RM)/C;   %u
     dy(2) = (y(2)*(y(1)-E)^2-eps1*sin(eps2*y(2))-eps3*(y(1)-E))/(R0*C0);   %x

 end

%% ---------- DO NOT MODIFY!!!  ode45Ps: ordinary differential equation solver -------%%
function varargout = ode45Ps(fx,tspan,y0)
    % options=odeset('MaxStep',1e-9,'RelTol',1e-9);,options
    y0 = y0(:);
    nn = length(y0);
    
    h = tspan(2)-tspan(1);
    N = length(tspan);
    t = ones(N,1)*nan;
    y = ones(N,nn)*nan;
    
    t(1) = tspan(1);
    y(1,:) = y0;
    
    for i=1:N
        
        if isnan(y(i,1))
            break
        end
        
        t0 = t(i);
        y0 = transpose(y(i,:));
        
        k1 = fx(t0,y0);
        k2 = fx(t0+h/2,y0+h*k1/2);
        k3 = fx(t0+h/2,y0+h*k2/2);
        k4 = fx(t0+h,y0+h*k3);
        
        y0 = y0+h*(k1+2*k2+2*k3+k4)/6;
        
        t(i+1) = t0+h;
        y(i+1,:) = reshape(y0,1,nn);    
    end
    
    if nargout == 1
        varargout = {y};
    elseif nargout == 2
        varargout = {t,y};
    else
        error('error');
    end

end
