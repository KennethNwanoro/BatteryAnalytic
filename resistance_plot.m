function resistance_plot(app)
% Check-up discharge Resistance callback
% Ask user to put in the cycle length: 50, 100 etc
% All_cycle_data_resistance(app)
% return


[stepNum,cells,numCells,cyc_length] =Capacity_plot_Panel_contrl(app);
linewidth = app.DVA_plot_line_width;
app.Panel.Title ='Relative Resistance Plot';

for iicell = 1: numCells
    icell = cells(iicell );
    cell_serial_No = app.UniqSerial(icell);
    cell_serial_No = char(cell_serial_No);
    res=[];
    FEC =0;
    cyc = 0;
    
    switch app.data_source
        
        case 'Basytec'
            
            for ifille = 1:size(app.Cells(icell).data,2)
                
                Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber ==  stepNum) ;%& ...
%                     app.Cells(icell).data(ifille).Data.State == 2 &...
%                     app.Cells(icell).data(ifille).Data.Count == 1);
                if isempty( Data_range)
                    uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                    return
                end
                
                
                %res = [res; app.Cells(icell).data(ifille).Data.R_ac(Data_range)];
                
                switch  app.Test_type
                    case 'Check-Up'
                     % resistance is calculated using pulse test
                     %res = [res; app.Cells(icell).data(ifille).Data.IR2(Data_range(end))];
                     curr = app.Cells(icell).data(ifille).Data.Current(Data_range(end));
                     volt1 = app.Cells(icell).data(ifille).Data.Potential(Data_range(1));
                     volt2 = app.Cells(icell).data(ifille).Data.Potential(Data_range(end));
                     res1 = abs((volt2-volt1)/curr);
                     res = [res;res1];
%                      res = [res; app.Cells(icell).data(ifille).Data.R_ac(Data_range)];
                
                    case 'Cycle-Continous'
                        res = [res; app.Cells(icell).data(ifille).Data.R_ac(Data_range(end))];
                        cyc = [cyc; cyc(end) + app.Cells(icell).data(ifille).Data.CycleNumber(Data_range)];
                    case 'Cycle-FEC'
                        res = [res; app.Cells(icell).data(ifille).Data.R_ac(Data_range(end))];
                        hhh = app.Cells(icell).data(ifille).Data.Ah_step(Data_range);
                        FEC_tmp = cumsum(-hhh);
                        FEC =[FEC;FEC(end) + (FEC_tmp(:)/3.4)];
                end
            end
            
            
            
            
        case 'Novonix'
            for ifille = 1:size(app.Cells(icell).data,2)
               
                
                switch  app.Test_type
                case 'Check-Up'
                 res_step = app.Cells(icell).Discharge_Resistance_Step{ifille};
                data_range = find(app.Cells(icell).data(ifille).Data.StepNumber==res_step);
                %res1 =  app.Cells(icell).data(ifille).Data.R_ac(data_range(end));
                %res1 =  app.Cells(icell).data(ifille).Data.IR(data_range(end));
                res1 =  app.Cells(icell).data(ifille).Data.IR2(data_range(end));
                res = [res; res1];
               
                    case 'Cycle-Continous'
                data_range = find(app.Cells(icell).data(ifille).Data.StepNumber==stepNum);
                res1 =  app.Cells(icell).data(ifille).Data.R_ac(data_range(end));
                res = [res; res1];
                cyc = [cyc; cyc(end) + app.Cells(icell).data(ifille).Data.CycleNumber(data_range(end))];
                        
                    case 'Cycle-FEC'
                data_range = find(app.Cells(icell).data(ifille).Data.StepNumber==stepNum);
                res1 =  app.Cells(icell).data(ifille).Data.R_ac(data_range(end));
                res = [res; res1];
                        hhh = app.Cells(icell).data(ifille).Data.Ah_step(data_range(end));
                        FEC_tmp = cumsum(-hhh);
                        FEC =[FEC;FEC(end) + (FEC_tmp(:)/3.4)];
                end
            end
    end
    
    legend_text = ['Cell:', ' ', cell_serial_No];
    
    switch  app.Test_type
        case 'Check-Up'
            x= 0 : length(res)-1;
            x= x*cyc_length;
            plot(app.UIAxes,x,  res/ res(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",12)
            xlabel(app.UIAxes,'Cycles'); ylabel(app.UIAxes,'Relative Resistance (%)')
            
        case 'Cycle-Continous'
            plot(app.UIAxes,cyc(2:end), res/ res(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",12)
            xlabel(app.UIAxes,'Cycles'); ylabel(app.UIAxes,'Relative Resistance (%)')
            
        case 'Cycle-FEC'
            plot(app.UIAxes,FEC(2:end), res/ res(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",12)
            xlabel(app.UIAxes,'Full Equivalent Cycles'); ylabel(app.UIAxes,'Relative Resistance (%)')
    end
    
    hold(app.UIAxes,'on')
    legend(app.UIAxes,'Location','northwest')
    app.UIAxes.XGrid = 'on';
    app.UIAxes.YGrid = 'on';
    minlimX = min(x);
    maxlimX = max(x);
    app.UIAxes.XLim = ([(minlimX-(cyc_length/10))  (maxlimX + (cyc_length/10))]);
    
end


end