
function relative_resistance_barChart(app)

[stepNum,cells,numCells,cyc_length] = Capacity_plot_Panel_contrl(app);
app.Panel.Visible ='on';
app.Panel.Title = 'Relative Resistance Plots';
app.UIAxes.BackgroundColor ='w';
app.UIAxes.Visible='off';
pos = app.UIAxes.Position;


linewidth = app.DVA_plot_line_width;

switch app.Cell_cluster_plot
    
    case 'False'
        [col,~,ax1]=multiAxes(app,numCells,pos);
        app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
        if col==0
            return
        end
        for iicell = 1: numCells
            res=[];
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
                
                switch app.data_source
                    case 'Basytec'
                        Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber == stepNum);
                        if isempty( Data_range)
                            uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                            return
                        end
                        
                        res = [res; app.Cells(icell).data(ifille).Data.R_ac(Data_range(end))];
                        
                        
                    case 'Novonix'
                       
                        res_step = app.Cells(icell).Discharge_Resistance_Step{ifille};
                        data_range = find(app.Cells(icell).data(ifille).Data.StepNumber==res_step);
                        res1 =  app.Cells(icell).data(ifille).Data.R_ac(data_range(end));
                        res = [res; res1];
                        
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
            cap = res/ res(1)*100;
            
            switch  app.Test_type
                case 'Check-Up'
                    x= 0 : length(res)-1;
                    x= x*cyc_length;
                    
                    bar(ax1(iicell),x,res,0.8)
                    ylabel(ax1(iicell),'Relative Resistance (%)')
                    xlabel(ax1(iicell),'Cycles')
                    
                case 'Cycle-Continous'
                    bar(ax1(iicell),cyc(2:end),res,0.8)
                    ylabel(ax1(iicell),'Relative Resistance (%)')
                    xlabel(ax1(iicell),'Cycles')
                    
                case 'Cycle-FEC'
                    bar(ax1(iicell),FEC(2:end),res,0.8)
                    ylabel(ax1(iicell),'Relative Resistance (%)')
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
        Res = {};
        legend_text={};
        
        for iicell = 1: numCells
            res=[];
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
                        switch app.data_source
                            
                            case 'Basytec'
             
                                Data_range = find(app.Cells(icell).data(ifile).Data.StepNumber == stepNum);
                                if isempty( Data_range)
                                    uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                                    return
                                end
                                res = [res; app.Cells(icell).data(ifile).Data.R_ac(Data_range(end))];
                                
                            case 'Novonix'
                                res_step = app.Cells(icell).Discharge_Resistance_Step{ifile};
                                data_range = find(app.Cells(icell).data(ifile).Data.StepNumber==res_step);
                                %res1 =  app.Cells(icell).data(ifile).Data.R_ac(data_range(end));
                                %res1 =  app.Cells(icell).data(ifile).Data.IR(data_range(end));
                                res1 =  app.Cells(icell).data(ifile).Data.IR2(data_range(end));
                                res = [res; res1];
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
                    
                    switch app.data_source
                        case 'Basytec'
                            Data_range = find(app.Cells(icell).data(1).Data.StepNumber == stepNum);
                            res = [res; app.Cells(icell).data(1).Data.R_Ac(Data_range(end))];
                        case 'Novonix'
                            res_step = app.Cells(icell).Discharge_Resistance_Step{1};
                            data_range = find(app.Cells(icell).data(1).Data.StepNumber==res_step);
                            res1 =  app.Cells(icell).data(1).Data.R_ac(data_range(end));
                            res = [res; res1];
                    end
                    
                    
                    for ifille = 1:size( app.getfiles ,2)
                        ifile = app.getfiles(ifille);
                        switch app.data_source
                            case 'Basytec'
                                Data_range = find(app.Cells(icell).data(ifile).Data.StepNumber == stepNum);
                                if isempty( Data_range)
                                    uialert(app.BatteryAnalyticUIFigure,['Invalid StepNumber'],"StepNumber","Icon",'error')
                                    return
                                end
                                res = [res; app.Cells(icell).data(ifile).Data.R_ac(Data_range(end))];
                                
                            case 'Novonix'
                                
                                res_step = app.Cells(icell).Discharge_Resistance_Step{ifile};
                                data_range = find(app.Cells(icell).data(ifile).Data.StepNumber==res_step);
                                res1 =  app.Cells(icell).data(ifile).Data.R_ac(data_range(end));
                                res = [res; res1];
                                
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
            res = res/ res(1)*100;
            if app.fileOption_status ==0
                res = res(2:end);
            end
            Res = [Res;res'];
        end
        
        nn = max(cellfun(@length,Res));
        f = @(xx) [xx,zeros(1,nn-length(xx))];
        Res = cellfun(f,Res,'UniformOutput',false);
        Res =cat(1,Res{:});
        
        
        switch  app.Test_type
            case 'Check-Up'
                if app.fileOption_status ==1
                    x= 0 : nn-1;
                    x= x*cyc_length;
                else
                    x = app.getfiles*cyc_length;
                    
                    
                end
                
                bar( app.UIAxes,x,Res',0.8,'group')
                ylabel(app.UIAxes,'Relative Resistance (%)')
                xlabel(app.UIAxes,'Cycles')
                
            case 'Cycle-Continous'
                bar(app.UIAxes,cyc(2:end),Res,0.8,'DisplayName',legend_text)
                ylabel(app.UIAxes,'Relative Resistance (%)')
                xlabel(app.UIAxes,'Cycles')
                
            case 'Cycle-FEC'
                bar(app.UIAxes,FEC(2:end),Res,0.8,'DisplayName',legend_text)
                ylabel(app.UIAxes,'Relative Resistance (%)')
                xlabel(app.UIAxes,'Full Equivalent Cycles')
                
        end
        % hold(app.UIAxes,'on')
        legend(app.UIAxes,legend_text,'Location','northwest')
        
end



end


