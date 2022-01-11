function [capvolt,diffa,val] = DifferenFun(app,ifile,icell)               % DVA and ICA
%Function for DVA and ICA
if strcmp(app.data_source, 'Arbin')==0
MA = 25;

% g = gausswin(100); % this value determines the width of the smoothing window.
%  In the absence of signal processing tool box, here using the fitted value of
%  gausswin for 100 sample size, for different sample size, fit and change
%  the value of alpha.
N=100;
M= (N-1)/2;
alpha=2.5;
n= (-(N-1)/2:(N-1)/2)';
g= exp((-0.5)*((alpha^2 *n.^2)/(M^2)));
g = g/sum(g);


switch app.StepSource
    
    case     'App_detected_Discharge'
        val= app.Cells(icell).Discharge_DVAstep{ifile}; % stored step file
        Data_range =  app.Cells(icell).data(ifile).Data.StepNumber==val;
        
    case 'App_detected_Charge'
        val= app.Cells(icell).Charge_DVAstep{ifile}; % stored stepNumber file
        Data_range =  app.Cells(icell).data(ifile).Data.StepNumber==val;
    case 'user'
        val = app.User_step;  %  CHECK THIS AGAIN
        Data_range =  find(app.Cells(icell).data(ifile).Data.StepNumber==val);
        if isempty(Data_range)
            txt = ['There is no StepNumber', ' ', app.User_step, ' ',' in the file'];
            uialert(app.BatteryAnalyticUIFigure,txt,"StepNumber","Icon",'warning')
            return
        end
end


voltage= app.Cells(icell).data(ifile).Data.Potential(Data_range);
capacity= app.Cells(icell).data(ifile).Data.Ah_step(Data_range);

% volt=smoothdata(voltage,'gaussian',2000);
% cap=smoothdata(capacity,'gaussian',2000);

volt=smooth(voltage,MA);
cap=smooth(capacity,MA);

diffcap=diff(cap);
diffvolt=diff(volt);
dQdV=diffcap./diffvolt;
dVdQ=diffvolt./diffcap;
IC= conv(dQdV, g, 'same');
DV= conv(dVdQ, g, 'same');
else
  DV  = app.Cells(icell).data(ifile).Data.DVA;
  IC =  app.Cells(icell).data(ifile).Data.ICA;
  cap = app.Cells(icell).data(ifile).Data.Ah_step;
  cap(end+1) = cap(end);
  voltage = app.Cells(icell).data(ifile).Data.Potential;
  val = 1;
    
end 

%DV = smoothdata(DV,'sgolay');
%DV= dVdQ;



switch app.Diff_analysis
    
    case 'DVA'
        diffa =  DV;
        capvolt =cap;
        
        
    case 'ICA'
        
        diffa =  IC;
        capvolt = voltage;
        
end



end % end DVA and ICA