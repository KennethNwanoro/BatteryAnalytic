function  Power_plot(app)


[stepNum,cells,numCells,cyc_length] =Capacity_plot_Panel_contrl(app);
linewidth = app.DVA_plot_line_width;
app.UIAxes.FontWeight ='B';
for iicell = 1: numCells
    icell = cells(iicell );
    cell_serial_No = app.UniqSerial(icell);
    cell_serial_No = char(cell_serial_No);
    Ah=[];
    FEC =0;
    cyc = 0;
    
    
    for ifille = 1:size(app.Cells(icell).data,2)
        %stepNum = app.Cells(icell).Discharge_Resistance_Step{ifille};
        switch app.data_source
            
            case 'Basytec'
                Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber ==  stepNum &...
                    app.Cells(icell).data(ifille).Data.Count == 2);
                if isempty( Data_range)
                    uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                    return
                end
                Ah = [Ah; app.Cells(icell).data(ifille).Data.Power_step2(Data_range(end))];
                
            case 'Novonix'
                
                %Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber ==  stepNum);
                res_step = app.Cells(icell).Discharge_Resistance_Step{ifille};
                Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber ==  res_step);
                if isempty( Data_range)
                    uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                    return
                end
                %Ah = [Ah; app.Cells(icell).data(ifille).Data.Power_step(Data_range(end))];
                
                
                Ah = [Ah; app.Cells(icell).data(ifille).Data.Power_step2(Data_range(end))];
        end
        
        switch  app.Test_type
            case 'Cycle-Continous'
                cyc = [cyc; cyc(end) + app.Cells(icell).data(ifille).Data.CycleNumber(Data_range(end))];
            case 'Cycle-FEC'
                hhh = app.Cells(icell).data(ifille).Data.Power_step(Data_range(end));
                FEC_tmp = cumsum(-hhh);
                FEC =[FEC;FEC(end) + (FEC_tmp(:)/3.4)];
        end
    end
    
    
    
    legend_text = ['Cell:', ' ', cell_serial_No];
    Ah = abs(Ah);
    
    switch  app.Test_type
        case 'Check-Up'
            x= 0 : length(Ah)-1;
            x= x*cyc_length;
            plot(app.UIAxes,x, Ah/ Ah(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10)
            xlabel(app.UIAxes,'Cycles'); ylabel(app.UIAxes,'Relative Power (%)')
            
        case 'Cycle-Continous'
            plot(app.UIAxes,cyc(2:end), Ah/ Ah(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10)
            xlabel(app.UIAxes,'Cycles'); ylabel(app.UIAxes,'Relative Power (%)')
            
        case 'Cycle-FEC'
            plot(app.UIAxes,FEC(2:end),Ah/ Ah(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10)
            xlabel(app.UIAxes,'Full Equivalent Cycles'); ylabel(app.UIAxes,'Relative Power (%)')
    end
    
    hold(app.UIAxes,'on')
    legend(app.UIAxes)
    app.UIAxes.XGrid = 'on';
    app.UIAxes.YGrid = 'on';
    minlimX = min(x);
    maxlimX = max(x);
    app.UIAxes.XLim = ([(minlimX-(cyc_length/10))  (maxlimX + (cyc_length/10))]);
    
end


end