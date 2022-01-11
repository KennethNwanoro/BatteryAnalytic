function relative_resistance_SOC_plot(app)
[stepNum,cells,numCells,~] =Capacity_plot_Panel_contrl(app);
linewidth = app.DVA_plot_line_width;
app.Panel.Title ='Relative Capacity Plot';
app.UIAxes.FontWeight ='B';
storage_period=  {'0 month', '1 month','2 months', '3 months','4 months',...
    '5 months','6 months','7 months', '12 months','18 months', '23 months'};
AH = [];

count =3;
% count =1: 10% SOC,ount =2: 30% SOC, % count =3 :50% SOC % count =4 :70%
% SOC, count =5 :90% SOC
for iicell = 1: numCells
    icell = cells(iicell );
%     cell_serial_No = storage_period(iicell);
%     cell_serial_No =char(cell_serial_No);
    Res_discharg =[];    
    Res_charg =[]; 
    
    for ifille = 1:size(app.Cells(icell).data,2)
        stepNum2 =stepNum;
        
        Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber ==  stepNum2);
%         if isempty( Data_range) 
%             uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
%             return
%         end
   if ~isempty( Data_range) 
        Ah0 =  app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end));
   else
        Ah0 = 0;
   end
        
        if Ah0 ==0
             res_disch =0;
            res_charg =0;
        else
            
        Data_range_discharge = find(app.Cells(icell).data(ifille).Data.StepNumber == 29 ...
        & app.Cells(icell).data(ifille).Data.Count ==count );
        Data_range_charge = find(app.Cells(icell).data(ifille).Data.StepNumber == 31 ...
            & app.Cells(icell).data(ifille).Data.Count ==count );        
       
        discharge_volt = app.Cells(icell).data(ifille).Data.Potential(Data_range_discharge);
        charge_volt= app.Cells(icell).data(ifille).Data.Potential(Data_range_charge);
        discharge_current = app.Cells(icell).data(ifille).Data.Current(Data_range_discharge);
        charge_current= app.Cells(icell).data(ifille).Data.Current(Data_range_charge);
        res_disch = (discharge_volt(end) -discharge_volt(1))/(discharge_current(end) - discharge_current(1));
        res_charg = (charge_volt(end) -charge_volt(1))/(charge_current(end) - charge_current(1));
        
        if discharge_current(2:end)==0
          Data_range_discharge = find(app.Cells(icell).data(ifille).Data.StepNumber == 28 ...
          & app.Cells(icell).data(ifille).Data.Count ==count );
        Data_range_charge = find(app.Cells(icell).data(ifille).Data.StepNumber == 30 ...
            & app.Cells(icell).data(ifille).Data.Count ==count );        
      
        discharge_volt = app.Cells(icell).data(ifille).Data.Potential(Data_range_discharge);
        charge_volt= app.Cells(icell).data(ifille).Data.Potential(Data_range_charge);
        
        if ~isempty (discharge_volt)
        discharge_current = app.Cells(icell).data(ifille).Data.Current(Data_range_discharge);
        charge_current= app.Cells(icell).data(ifille).Data.Current(Data_range_charge);
        res_disch = (discharge_volt(end) -discharge_volt(1))/(discharge_current(end) - discharge_current(1));
        res_charg = (charge_volt(end) -charge_volt(1))/(charge_current(end) - charge_current(1)); 
        
        
        else
        Data_range_discharge = find(app.Cells(icell).data(ifille).Data.StepNumber == 30 ...
          & app.Cells(icell).data(ifille).Data.Count ==count );
        Data_range_charge = find(app.Cells(icell).data(ifille).Data.StepNumber == 32 ...
            & app.Cells(icell).data(ifille).Data.Count ==count );   
        discharge_volt = app.Cells(icell).data(ifille).Data.Potential(Data_range_discharge);
        charge_volt= app.Cells(icell).data(ifille).Data.Potential(Data_range_charge);
        discharge_current = app.Cells(icell).data(ifille).Data.Current(Data_range_discharge);
        charge_current= app.Cells(icell).data(ifille).Data.Current(Data_range_charge);
        res_disch = (discharge_volt(end) -discharge_volt(1))/(discharge_current(end) - discharge_current(1));
        res_charg = (charge_volt(end) -charge_volt(1))/(charge_current(end) - charge_current(1));  
        end
        
        end
        end
        
        
        Res_discharg = [Res_discharg;res_disch];
        Res_charg = [Res_charg;res_charg];
    end
    Res_discharg = Res_discharg/Res_discharg(1);
    Res_charg = Res_charg/Res_charg(1);
    %AH = [AH Ah];
   % AH = flip(AH,2);
end
end