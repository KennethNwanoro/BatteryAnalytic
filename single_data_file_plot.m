function [status]= single_data_file_plot(app)
cla(app.UIAxes,'reset')
app.Barplot.Visible= 'off';
if size(app.Cells,2) > 1 || size(app.Cells(1).data,2)>1
    
    func(app)
    status =0;
else
    status =1;
    datas = app.Cells.data;
    func2(app)
    
    switch app.plot_type
        
        case 'full_test_time_plot'
            
            
            plot_x_val=  datas.Data.RunTime;
            xlab = 'RunTime (hr)';
            switch app.plotVal
                
                case 1
                    plot_y_val =  datas.Data.Potential;
                    
                    strl = 'Test Voltage Profile';
                    ylab = 'Voltage (V)';
                    
                case 2
                    plot_y_val =  datas.Data.Current;
                    strl = 'Test Current Profile';
                    ylab = 'Current (A)';
                    
                case 3
                    plot_y_val =  datas.Data.Ah_step;
                    strl = 'Test Capacity Profile';
                    ylab = 'Capacity (Ah)';
                    
                case 4
                    plot_y_val =  datas.Data.Temperature;
                    strl = 'Test Temperature Profile';
                    ylab =['Temperature'  (char(176)) 'C'];
                    
                case 5
                    cap_rated  = inputdlg('Rated Capacity Value:', 'Rated Capacity', [1 50]);
                    if isempty( cap_rated)
                        return
                    end
                    cap_rated  = str2double(cap_rated);
                    current_val= datas.Data.Current;
                    plot_y_val = current_val/cap_rated;
                    ylab = 'C-rate (1/hr)';
                    strl = 'Test C-rate Profile';
                    
                case 6 
                     plot_y_val =  datas.Data.R_ac;
                    strl = 'Test Temperature Profile';
            end
            plot( app.UIAxes,plot_x_val,plot_y_val, 'LineWidth',1.5)
            hold(app.UIAxes,'on')
            app.UIAxes.FontWeight ='B';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            xlabel(app.UIAxes,xlab)
            ylabel(app.UIAxes,ylab)
            app.UIAxes.Title.String = strl;
            hold(app.UIAxes,'off')
            
            
            if isdeployed == 0
                plot(plot_x_val,plot_y_val, 'LineWidth',2)
                 grid on
                 box on
                 set(gcf,'color','w')
                 xlabel(xlab)
                 ylabel(ylab)
            %Uncoment Enter limits values here
                 %xlim([])
                 %ylim([])
            end
            
            
            
            
        case 'StepNumber plot'
            
%             filecount = app.File_count;
%             filecount = str2double(filecount);

            cells=1;numCells=1;
            StepPlots(app,cells,numCells)
            
    end
end
end