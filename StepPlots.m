function StepPlots(app,cells,numCells)
cla(app.UIAxes,'reset')
linewidth = app.DVA_plot_line_width;
numaxes = size(app.Panel.Children,1);
if numaxes>1
    AxesControl(app,numaxes)
end
app.Panel.Visible = 'on';
app.uilbl.Visible ='off';
app.uidrp.Visible ='off';
app.remove_limits.Visible ='off';
app.Barplot.Visible ='off';
app.UIAxes.Box= 'on';
pos = [300,90,700,450];
app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];

app.UIAxes.BackgroundColor='W';

app.Panel.Title = 'Step plots';
app.UIAxes.Visible ='off';
app.remove_limits.Visible ='off';

userStep= inputdlg('Enter comma-separated values:',...
    'StepNumber', [1 50]);

if isempty(userStep)
    return
end
if ismember(userStep,app.DropDown.Items)
    app.DropDown.Value = userStep;
    app.AvailableStepnumbersLabel.Text = 'Current StepNumber';
end
val = str2num(userStep{1});

pos = app.UIAxes.Position;
[col,font,ax1]=multiAxes(app,numCells,pos);
if col==0
    return
end
xlab = 'StepTime (hr)';




for iicell = 1: numCells
    if numCells>1 || size(app.Cells(1).data,2)>1
    if app.fileOption_status==0
        if ~iscell(app.files)
            app.getfiles = app.files;
        else
            app.getfiles =  cell2mat(app.files(iicell));
        end
    elseif app.fileOption_status==1
        app.getfiles = 1: app.files(iicell);
    end
    end
    icell = cells(iicell );
    
    cell_serial_No = app.UniqSerial(icell);
    cell_serial_No = char(cell_serial_No);
    
    ax1(iicell).Box = 'on';
    ax1(iicell).BackgroundColor='W';
    if  numCells >1 || size(app.Cells(1).data,2)>1
    numFiles=size( app.getfiles,2);
    else
        numFiles = 1;
        app.getfiles =1;
    end
    cap = zeros(numFiles,1);
    ax1(iicell).FontWeight ='B';
    
    for ifille = 1:numFiles
        
        ifile = app.getfiles(ifille);
        
        for ii = 1: size(val,2)
            vall= val(ii);
            %                                   legend_text = ['RPT',num2str(ifile),' ', 'StepNumber', ' ', num2str(vall), ' ', 'Cell:',' ', cell_serial_No];
            legend_text = ['Test No',' ',num2str(ifile)];
            Data_range =  find(app.Cells(icell).data(ifile).Data.StepNumber==vall);
            
            if isempty(Data_range)
                txt = ['There is no StepNumber', ' ', num2str(vall), ' ',' in the file'];
                app.Panel.Visible ='off';
                uialert(app.BatteryAnalyticUIFigure,txt,"StepNumber","Icon",'warning')
                return
            end
            
            switch app.stepPlot_val
                case {1, 6}
                    
                    protocol_val_y= app.Cells(icell).data(ifile).Data.Potential(Data_range);
                    protocol_val_x= app.Cells(icell).data(ifile).Data.Ah_step(Data_range);
                    protocol_current = app.Cells(icell).data(ifile).Data.Current(Data_range);
                    if protocol_current(4:end)<0
                        protocol_val_x = protocol_val_x*(-1);
                    end
                    
                    cap(ifile) =  protocol_val_x(end) ;
                    if protocol_val_y == 0 | protocol_current== 0
                        uialert(app.BatteryAnalyticUIFigure,'Invalid Step Number', 'StepNumber','Icon','error')
                        return
                        
                    end
                    xlimit = [0 ; max(protocol_val_x)];
                    ylimit = [ min(protocol_val_y) ; max(protocol_val_y)+0.1];
                    xlab = 'Capacity (Ah)';
                    ylab = 'Voltage (V)';
                    
                case 2
                    protocol_val_y= app.Cells(icell).data(ifile).Data.Ah_step(Data_range);
                    protocol_val_y = abs(protocol_val_y);
                    protocol_val_x= app.Cells(icell).data(ifile).Data.StepTime(Data_range);
                    ylimit = [0 ; max(protocol_val_y)];
                    xlimit = [ 0 ; max(protocol_val_x)+0.5];
                    ylab = 'Capacity (Ah)';
                    
                    
                case 3
                    protocol_val_y= app.Cells(icell).data(ifile).Data.Potential(Data_range);
                    protocol_val_x= app.Cells(icell).data(ifile).Data.StepTime(Data_range);
                    ylab = 'Voltage (V)';
                    ylimit = [ min(protocol_val_y); max(protocol_val_y)];
                    xlimit = [ 0 ; max(protocol_val_x)+0.5];
                    
                case 4
                    protocol_val_y= app.Cells(icell).data(ifile).Data.Current(Data_range);
                    protocol_val_x= app.Cells(icell).data(ifile).Data.StepTime(Data_range);
                    ylab = 'Current (A)';
                    ylimit = [min(protocol_val_y); max(protocol_val_y)];
                    xlimit = [ 0 ; max(protocol_val_x)+0.5];
                    
                case 5
                    protocol_val_y= app.Cells(icell).data(ifile).Data.Temperature(Data_range);
                    protocol_val_x= app.Cells(icell).data(ifile).Data.StepTime(Data_range);
                    ylab= ['Temperature',' ', '(', (char(176)) 'C', ')'];
                    ylimit = [min(protocol_val_y) ; max(protocol_val_y)];
                    xlimit = [ 0 ; max(protocol_val_x)+0.5];
                    
            end
            
            
            if app.stepPlot_val ~= 6
                plot(ax1(iicell), protocol_val_x,protocol_val_y,'LineWidth',linewidth,'DisplayName',legend_text)
                ax1(iicell).XLim = xlimit;
                ax1(iicell).YLim =ylimit;
                hold(ax1(iicell),'on')
               
            end
            
        end
    end
    if app.stepPlot_val ~= 6
        xlabel(ax1(iicell),xlab)
        ylabel(ax1(iicell),ylab)
        title(ax1(iicell),['Cell:',' ', cell_serial_No])
        legend(ax1(iicell),'NumColumns',1,"FontSize",font,'Orientation',"horizontal","Location","best")
        ax1(iicell).XGrid = 'on';
        ax1(iicell).YGrid = 'on';
        hold(ax1(iicell),'off')
        
    else
        %legend_text = ['Cell:',' ', cell_serial_No];
        bar(ax1(iicell),[1:numFiles],cap,0.6)
        ylabel(ax1(iicell),'Capacity (Ah)')
        xlabel(ax1(iicell),'Check-UP Number')
        title(ax1(iicell), cell_serial_No)
        %legend(ax1(iicell),'NumColumns',1,"FontSize",font,'Orientation',"horizontal")
    end
    
end


end