function relative_capacity_plot(app)

%All_cycle_data_capacity(app)
%Couloumbic_charge_slippage(app)

%return

[stepNum,cells,numCells,cyc_length] =Capacity_plot_Panel_contrl(app);
linewidth = app.DVA_plot_line_width;
app.Panel.Title ='Relative Capacity Plot';
app.UIAxes.FontWeight ='B';
for iicell = 1: numCells
    icell = cells(iicell );
    cell_serial_No = app.UniqSerial(icell);
    cell_serial_No = char(cell_serial_No);
    Ah=[];
    FEC =0;
    cyc = 0;
   
            
            for ifille = 1:size(app.Cells(icell).data,2)
                
                Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber ==  stepNum);
                if isempty( Data_range)
                    uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                    return
                end
                Ah = [Ah; app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end))];
                
                
                switch  app.Test_type
                    case 'Cycle-Continous'
              %Last Ah_step data point of the last discharge step is used
                   
                        
                        cyc = [cyc; cyc(end) + app.Cells(icell).data(ifille).Data.CycleNumber(Data_range(end))];
                    case 'Cycle-FEC'
                        hhh = app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end));
                        FEC_tmp = cumsum(-hhh);
                        FEC =[FEC;FEC(end) + (FEC_tmp(:)/3.4)];
                end
            end
                      
             
    legend_text = ['Cell:', ' ', cell_serial_No];
    
    switch  app.Test_type
        case 'Check-Up'
            x= 0 : length(Ah)-1;
            x= x*cyc_length;
            plot(app.UIAxes,x, Ah/ Ah(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10)
           
           % edit here for line width and marker size and type
%             plot(x,Ah/Ah(1)*100,'LineWidth',1.5,'Marker','o','MarkerSize', 4)
%             set(gcf,'color','w')
%             box on
%             grid on
%             hold on
            
            
            xlabel(app.UIAxes,'Cycles'); ylabel(app.UIAxes,'Relative Capacity (%)')
            
        case 'Cycle-Continous'
            plot(app.UIAxes,cyc(2:end), Ah/ Ah(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10)
            xlabel(app.UIAxes,'Cycles'); ylabel(app.UIAxes,'Relative Capacity (%)')
        
        case 'Cycle-FEC'
            plot(app.UIAxes,FEC(2:end),Ah/ Ah(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10)
            xlabel(app.UIAxes,'Full Equivalent Cycles'); ylabel(app.UIAxes,'Relative Capacity (%)')
    end
    
    hold(app.UIAxes,'on')
    legend(app.UIAxes,'Location','northeast')
    app.UIAxes.XGrid = 'on';
    app.UIAxes.YGrid = 'on';
    minlimX = min(x);
    maxlimX = max(x);
    app.UIAxes.XLim = ([(minlimX-(cyc_length/10))  (maxlimX + (cyc_length/10))]);
    
    % change legend here
    legend(legend_text,'Location','best')
    
    %change xlim and ylim here
   % xlim([-1 1600])
    %ylim([])
end


end