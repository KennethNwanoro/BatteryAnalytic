
function relative_capacity_barChart(app)

[stepNum,cells,numCells,cyc_length] = Capacity_plot_Panel_contrl(app);
app.Panel.Visible ='on';
app.Panel.Title = 'Relative Capacity Plots';
app.UIAxes.BackgroundColor ='w';
app.UIAxes.Visible='off';
pos = app.UIAxes.Position;
switch app.retention_type
    case 'Capacity'
        ylab= 'Relative Capacity (%)';
    case 'Power'
        ylab= 'Relative Power (%)';
end


linewidth = app.DVA_plot_line_width;

switch app.Cell_cluster_plot
    
    case 'False'
        [col,~,ax1]=multiAxes(app,numCells,pos);
        app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
        if col==0
            return
        end
        for iicell = 1: numCells
            Ah=[];
            FEC =0;
            cyc = 0;
            icell = cells(iicell );
            ax1(iicell).Box = 'on';
            ax1(iicell).LineWidth = linewidth;
            ax1(iicell).BackgroundColor='W';
            cell_serial_No = app.UniqSerial(icell);
            cell_serial_No = char(cell_serial_No);
            ax1(iicell).Title.String = cell_serial_No;
            ax1(iicell).FontWeight ='B';
            
            for  ifille = 1:size(app.Cells(icell).data,2)
                
                Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber == stepNum);
                if isempty( Data_range)
                    uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                    return
                end
                switch app.retention_type
                    case 'Capacity'
                        Ah = [Ah; app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end))];
                    case 'Power'
                        Ah = [Ah; app.Cells(icell).data(ifille).Data.Power_step(Data_range(end))];
                end
                
                switch  app.Test_type
                    case 'Cycle-Continous'
                        cyc = [cyc; cyc(end) + app.Cells(icell).data(ifille).Data.CycleNumber(Data_range(end))];
                    case 'Cycle-FEC'
                        hhh = app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end));
                        FEC_tmp = cumsum(-hhh);
                        FEC =[FEC;FEC(end) + (FEC_tmp(:)/3.4)];
                end
            end
            
            
            
            legend_text = ['Cell:', ' ', cell_serial_No];
            cap = Ah/ Ah(1)*100;
            
            switch  app.Test_type
                case 'Check-Up'
                    x= 0 : length(Ah)-1;
                    x= x*cyc_length;
                    
                    bar(ax1(iicell),x,cap,0.8)
                    ylabel(ax1(iicell),ylab)
                    xlabel(ax1(iicell),'Cycles')
                    
                case 'Cycle-Continous'
                    bar(ax1(iicell),cyc(2:end),cap,0.8)
                    ylabel(ax1(iicell),'Relative Capacity (%)')
                    xlabel(ax1(iicell),'Cycles')
                    
                case 'Cycle-FEC'
                    bar(ax1(iicell),FEC(2:end),cap,0.8)
                    ylabel(ax1(iicell),ylab)
                    xlabel(ax1(iicell),'Full Equivalent Cycles')
                    
            end
            
            
            % legend(ax1(iicell))
        end
        
        
        
    case 'True'
        mesg = 'Bar Graph';
        app.Panel.Visible ='on';
        numfiles = str2double(app.File_count);
        file_selection_handle(app,cells,numfiles,mesg)
        app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
        app.UIAxes.BackgroundColor ='w';
        app.UIAxes.Visible = 'on';
        app.UIAxes.Box = 'on';
        app.UIAxes.LineWidth =0.7;
        app.UIAxes.FontWeight ='B';
        Cap = {};
        legend_text={};
        
        for iicell = 1: numCells
            Ah=[];
            FEC =0;
            cyc = 0;
            icell = cells(iicell);
            cell_serial_No = app.UniqSerial(icell);
            cell_serial_No = char(cell_serial_No);
            
            switch app.fileOption_status
                case 1
                    
                    app.getfiles = 1: app.files(iicell);
                    for ifille = 1:size( app.getfiles ,2)
                        ifile = app.getfiles(ifille);
                        %stepNum = app.Cells(icell).Discharge_Resistance_Step{ifille};
                        Data_range = find(app.Cells(icell).data(ifile).Data.StepNumber == stepNum);
                        if isempty( Data_range)
                            uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                            return
                        end
                        
                        switch app.retention_type
                            case 'Capacity'
                                Ah = [Ah; app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end))];
                            case 'Power'
                                %Ah = [Ah; app.Cells(icell).data(ifille).Data.Power_step(Data_range(end))];
                                Ah = [Ah; app.Cells(icell).data(ifille).Data.Power_step2(Data_range(end))];
                        end
                        
                        
                        switch  app.Test_type
                            case 'Cycle-Continous'
                                cyc = [cyc; cyc(end) + app.Cells(icell).data(ifile).Data.CycleNumber(Data_range(end))];
                            case 'Cycle-FEC'
                                hhh = app.Cells(icell).data(ifile).Data.Ah_step(Data_range(end));
                                FEC_tmp = cumsum(-hhh);
                                FEC =[FEC;FEC(end) + (FEC_tmp(:)/3.4)];
                        end
                    end
                    
                case 0
                    if ~iscell(app.files)
                        app.getfiles = app.files;
                    else
                        app.getfiles =  cell2mat(app.files(iicell));
                    end
                    Data_range = find(app.Cells(icell).data(1).Data.StepNumber == stepNum);
                    
                    switch app.retention_type
                        case 'Capacity'
                            Ah = [Ah; app.Cells(icell).data(1).Data.Ah_step(Data_range(end))];
                        case 'Power'
                            Ah = [Ah; app.Cells(icell).data(1).Data.Power_step(Data_range(end))];
                    end
                    
                    for ifille = 1:size( app.getfiles ,2)
                        ifile = app.getfiles(ifille);
                        Data_range = find(app.Cells(icell).data(ifile).Data.StepNumber == stepNum);
                        if isempty( Data_range)
                            uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                            return
                        end
                        switch app.retention_type
                            case 'Capacity'
                                Ah = [Ah; app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end))];
                            case 'Power'
                                Ah = [Ah; app.Cells(icell).data(ifille).Data.Power_step(Data_range(end))];
                        end
                        
                        
                        switch  app.Test_type
                            case 'Cycle-Continous'
                                cyc = [cyc; cyc(end) + app.Cells(icell).data(ifile).Data.CycleNumber(Data_range(end))];
                            case 'Cycle-FEC'
                                hhh = app.Cells(icell).data(ifile).Data.Ah_step(Data_range(end));
                                FEC_tmp = cumsum(-hhh);
                                FEC =[FEC;FEC(end) + (FEC_tmp(:)/3.4)];
                        end
                    end
                    
                    
            end
            legend_text{iicell}= [cell_serial_No];
            cap = Ah/ Ah(1)*100;
            if app.fileOption_status ==0
                cap = cap(2:end);
            end
            Cap = [Cap;cap'];
        end
        
        nn = max(cellfun(@length,Cap));
        f = @(xx) [xx,zeros(1,nn-length(xx))];
        Cap = cellfun(f,Cap,'UniformOutput',false);
        Cap =cat(1,Cap{:});
        
        
        switch  app.Test_type
            case 'Check-Up'
                if app.fileOption_status ==1
                    x= 0 : nn-1;
                    x= x*cyc_length;
                else
                    x = app.getfiles*cyc_length;
                    
                end
                bar( app.UIAxes,x,Cap',0.8,'group')
                ylim(app.UIAxes,[90 105])
                ylabel(app.UIAxes,ylab)
                xlabel(app.UIAxes,'Cycles')
                
            case 'Cycle-Continous'
                bar(app.UIAxes,cyc(2:end),abs(cap),0.8,'DisplayName',legend_text)
                ylabel(app.UIAxes,ylab)
                xlabel(app.UIAxes,'Cycles')
                
            case 'Cycle-FEC'
                bar(app.UIAxes,FEC(2:end),cap,0.8,'DisplayName',legend_text)
                ylabel(app.UIAxes,ylab)
                xlabel(app.UIAxes,'Full Equivalent Cycles')
                
        end
        % hold(app.UIAxes,'on')
        switch app.retention_type
            case 'Power'
                legend(app.UIAxes,legend_text,'Location','northwest')
            case 'Capacity'
                legend(app.UIAxes,legend_text,'Location','northeast')
        end
end



end


