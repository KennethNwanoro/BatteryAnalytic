function [stepNum,posit,txt_state]= dva_plot(app)

state= app.Diff_analysis;
switch state
    case 'DVA'
        txt_state= 'DVA.';
        ylab= 'dV/dQ (V/Ah)';
        xlab = 'Capacity (Ah)';
    case 'ICA'
        txt_state= 'ICA.';
        xlab= 'Voltage (V)';
        ylab= 'dQ/dV (Ah/V)';
end
numaxes = size(app.Panel.Children,1);
if numaxes>1
    AxesControl(app,numaxes)
end

numfiles = str2double(app.File_count);
if max(numfiles) >1
    pos = [300,90,700,450];
    app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
    selected_cell(app);
    cells = app.selected_Cells;
    numCells= size(cells,1);
    posit= 500;
    mesg= [txt_state];
    
    if strcmp (app.DVA_Alightment,'left') && ~strcmp (app.StepSource,'user') && ~strcmp (app.remove_limits_state,'true')
       file_selection_handle(app,cells,numfiles,mesg)
    end
    
    
else
    app.getfiles  =1;
    app.files={1 };
    icell = 1;
    if numfiles==1 & size(app.Cells,2)>1
        selected_cell(app);
        cells = app.selected_Cells;
        numCells= size(cells,1);
        posit= 500;
    else
        posit= 300;
        numCells=1;
        cells=1;
    end
    
    pos = [50,90,700,450];
    app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
    app.fileOption_status =0;
end

pos = app.UIAxes.Position;

font =(app.DVA_plot_line_width);






switch app.fileOption_status
    case 0
        
        switch app.Cell_cluster_plot
            case 'False' % Plot each cell data in a single axes
                [col,~,ax1]=multiAxes(app,numCells,pos);
                if col==0
                    return
                end
                numColor = size( app.getfiles ,2);
                customJet = jet(numColor);
                for iicell = 1: numCells
                  app.getfiles =  cell2mat(app.files(iicell));
                    icell = cells(iicell );
                    cell_serial_No = app.UniqSerial(icell);
                    cell_serial_No = char(cell_serial_No);
                    app.Panel.Visible ='on';
                    ax1(iicell).BackgroundColor ='w';
                    ax1(iicell).FontWeight ='B';
                    ax1(iicell).Box = 'on';
                    txt = app.DVA_legend_Title;
                    tit = ['Cell:', ' ',cell_serial_No];
                    switch app.DVA_Alightment
                        
                        case 'left'
                            for ifille = 1:size( app.getfiles(iicell) ,2)
                                custom_colour = customJet(ifille,:);
                                ifile =  app.getfiles (ifille);
                                legend_text = ['Test', ' ', num2str(ifile)];
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                plot(ax1(iicell),abs(cap(1:end-1)),(DV),'DisplayName',legend_text, 'Color',custom_colour,'LineWidth',font)
                                hold(ax1(iicell),'on')
                            end
                            
                        case 'right'
                            
                            for ifille = 1:size( app.getfiles ,2)
                                colour = customJet(ifille,:);
                                ifile = app.getfiles(ifille);
                                legend_text = ['Test', ' ', num2str(ifile)];
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                cap = cap - cap(end);
                                cap = cap(1:end-1);
                                plot(ax1(iicell),cap,DV,'DisplayName',legend_text, 'Color',colour,'LineWidth',font)
                                hold(ax1(iicell),'on')
                            end
                    end
                    
                    ax1(iicell).Title.String= tit;
                    ax1(iicell).Title.FontSize = str2double(app.DVA_plot_font_size);
                    xlabel(ax1(iicell),xlab)
                    ylabel(ax1(iicell),ylab)
                    
                    legend(ax1(iicell),'NumColumns',1,'FontSize',str2double(app.DVA_plot_legend_size),'Orientation','horizontal',"Location","best")
                    
                    if ~isempty (app.Xlimit) || ~isempty (app.Ylimit)
                        ax1(iicell).XLim =app.Xlimit;
                        ax1(iicell).YLim=app.Ylimit;
                    end
                    
                    hold(ax1(iicell),'off')
                    
                end
                
                
                
            case 'True'  %%%% Plot all cells in one axes
                
             app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
             app.UIAxes.BackgroundColor ='w';
             app.UIAxes.Visible = 'on';
             app.UIAxes.Box = 'on';
             app.UIAxes.LineWidth =0.7;
             app.UIAxes.FontWeight ='B';
             app.UIAxes.XGrid ='on';
             ifil =0;
              numColor = size(app.getfiles,2)*size(cells,1);
              customJet = jet(numColor);
                for iicell = 1: numCells
                    app.getfiles =  cell2mat(app.files(iicell));
                    icell = cells(iicell );
                    cell_serial_No = app.UniqSerial(icell);
                    cell_serial_No = char(cell_serial_No);
                    app.Panel.Visible ='on';
                    txt = app.DVA_legend_Title;
                    tit = ['Cell:', ' ',cell_serial_No];
                    txt = {'0.05 MPa', '0.1 MPa', 'Control'};
                    %txt = {'0.1 MPa', 'Control'};
                    switch app.DVA_Alightment
                        
                        case 'left'
                            for ifille = 1:size( app.getfiles ,2)
                                ifil = ifil+1;
                                custom_colour = customJet(ifil,:);
                                ifile =  app.getfiles(ifille);
                                legend_text = [cell_serial_No, ' ','RPT', ' ', num2str(ifile)];
                                %legend_text = char(txt (iicell));
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                plot( app.UIAxes,abs(cap(1:end-1)),(DV),'DisplayName',legend_text, 'Color',custom_colour,'LineWidth',10)
                                hold( app.UIAxes,'on')
                            end
                            
                        case 'right'
                            
                            for ifille = 1:size( app.getfiles ,2)
                                ifil = ifil+1;
                                colour = customJet(ifil,:);
                                ifile = app.getfiles(ifille);
                                legend_text = [cell_serial_No,':', ' ','RPT', ' ', num2str(ifile)];
                                %legend_text = char(txt (iicell));
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                cap = cap -cap(end);
                                plot( app.UIAxes,cap(1:end-1),DV,'DisplayName',legend_text, 'Color',colour,'LineWidth',font)
                                hold(app.UIAxes,'on')
                            end
                    end
                    
                    %ax1.Title.String= tit;
                    %ax1.Title.FontSize = str2double(app.DVA_plot_font_size);
                    xlabel( app.UIAxes,xlab)
                    ylabel( app.UIAxes,ylab)
                    
                    legend( app.UIAxes,'NumColumns',1,'FontSize',str2double(app.DVA_plot_legend_size),'Orientation','horizontal',"Location","best")
                    
                    if ~isempty (app.Xlimit) || ~isempty (app.Ylimit)
                         app.UIAxes.XLim =app.Xlimit;
                         app.UIAxes.YLim=app.Ylimit;
                    end
                    
                 
                    
                end
                
                
                
        end
        
        
        
    case 1
        
        
        switch app.Cell_cluster_plot
            case 'False'
                [col,~,ax1]=multiAxes(app,numCells,pos);
                if col==0
                    return
                end
               
                dat = {};
                for iicell = 1: numCells
                   
                    app.getfiles = 1: app.files(iicell);
                    numColor = size( app.getfiles ,2);
                    customJet = jet(numColor);
                    icell = cells(iicell );
                    cell_serial_No = app.UniqSerial(icell);
                    cell_serial_No = char(cell_serial_No);
                    app.Panel.Visible ='on';
                    ax1(iicell).BackgroundColor ='w';
                    ax1(iicell).Box = 'on';
                    ax1(iicell).FontWeight ='B';
                    txt = app.DVA_legend_Title;
                    tit = ['Cell:', ' ',cell_serial_No];
                    switch app.DVA_Alightment
                        
                        case 'left'
                            for ifille = 1:size(app.getfiles,2)
                                custom_colour = customJet(ifille,:);
                                ifile =  app.getfiles (ifille);
                                legend_text = ['Test', ' ', num2str(ifile)];
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                if strcmp(app.Cell_cluster_plot,'False')
                                    plot(ax1(iicell),abs(cap(1:end-1)),(DV),'DisplayName',legend_text, 'Color',custom_colour,'LineWidth',font)
                                    hold(ax1(iicell),'on')
                                else
                                    plot(ax1,abs(cap(1:end-1)),(DV),'DisplayName',legend_text, 'Color',custom_colour,'LineWidth',font)
                                    hold(ax1,'on')
                                end
                            end
                            
                        case 'right'
                            
                            for ifille = 1:size( app.getfiles ,2)
                              
                                colour = customJet(ifille,:);
                                ifile = app.getfiles(ifille);
                                legend_text = ['Test', ' ', num2str(ifile)];
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                 cap = cap - cap(end);
                                 
                                % Store DV and cap data
%                                  capp = cap(1:end-1);
%                                  Cap = [capp DV];
%                                  dat(ifile).values = Cap;

                                
                                if strcmp(app.Cell_cluster_plot,'False')
                                    plot(ax1(iicell),cap(1:end-1),DV,'DisplayName',legend_text, 'Color',colour,'LineWidth',font)
                                    hold(ax1(iicell),'on')
                                else
                                    plot(ax1,cap(1:end-1),DV,'DisplayName',legend_text, 'Color',colour,'LineWidth',font)
                                    hold(ax1,'on')
                                end
                            end
              
                    end
                    
                    
                    ax1(iicell).Title.String= tit;
                    ax1(iicell).Title.FontSize = str2double(app.DVA_plot_font_size);
                    xlabel(ax1(iicell),xlab)
                    ylabel(ax1(iicell),ylab)
                    
                    legend(ax1(iicell),'NumColumns',1,'FontSize',str2double(app.DVA_plot_legend_size),'Orientation','horizontal',"Location","best")
                    
                    if ~isempty (app.Xlimit) || ~isempty (app.Ylimit)
                        ax1(iicell).XLim =app.Xlimit;
                        ax1(iicell).YLim=app.Ylimit;
                    end
                    
                    hold(ax1(iicell),'off')
                    
                end
                
            case 'True'
               app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
               app.UIAxes.BackgroundColor ='w';
               app.UIAxes.Visible = 'on';
               app.UIAxes.FontWeight ='B';
               app.UIAxes.Box = 'on';
               app.UIAxes.XGrid = 'on';
                ifil =0;
                 numColor = sum( app.files);
                 customJet = jet(numColor);
                for iicell = 1: numCells
                    
                    app.getfiles = 1: app.files(iicell);
                    icell = cells(iicell );
                    cell_serial_No = app.UniqSerial(icell);
                    cell_serial_No = char(cell_serial_No);
                    app.Panel.Visible ='on';
                  
                    txt = app.DVA_legend_Title;
                   % tit = ['Cell:', ' ',cell_serial_No];
                   % tit = ['Cell:', ' ',cell_serial_No];
                    switch app.DVA_Alightment
                        
                        case 'left'
                            
                            for ifille = 1:size(app.getfiles,2)
                                ifil = ifil+1;
                                custom_colour = customJet(ifil,:);
                                ifile =  app.getfiles (ifille);
                                legend_text = [cell_serial_No,':', ' ','RPT', ' ', num2str(ifile)];
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                plot( app.UIAxes,abs(cap(1:end-1)),(DV),'DisplayName',legend_text, 'Color',custom_colour,'LineWidth',font)
                                hold( app.UIAxes,'on')
                                
                            end
                            
                        case 'right'
                             nu =[1 6];
                            for ifille = 1:size( app.getfiles ,2)
                                ifil = ifil+1;
                                colour = customJet(ifil,:);
                                ifile = app.getfiles(ifille);
                                 legend_text = [cell_serial_No,':', ' ','RPT', ' ', num2str(ifile)];
                                %legend_text = ['Test', ' ', num2str(ifile)];
                                [cap,DV,stepNum] = DifferenFun(app,ifile,icell);
                                cap = cap -cap(end);
                                
                                plot( app.UIAxes,cap(1:end-1),DV,'DisplayName',legend_text, 'Color',colour,'LineWidth',font,'Marker','.','MarkerSize',8)
                                hold( app.UIAxes,'on')
                                
                            end
                    end
                    
                 
                end
                
                if ~isempty (app.Xlimit) || ~isempty (app.Ylimit)
                    app.UIAxes.XLim =app.Xlimit;
                    app.UIAxes.YLim=app.Ylimit;
                end
                    
                   % app.UIAxes.Title.String= tit;
                    %app.UIAxes.Title.FontSize = str2double(app.DVA_plot_font_size);
                    xlabel( app.UIAxes,xlab)
                    ylabel( app.UIAxes,ylab)
                    legend( app.UIAxes,'NumColumns',1,'FontSize',str2double(app.DVA_plot_legend_size),'Orientation','horizontal',"Location","best")
                    
                    if ~isempty (app.Xlimit) || ~isempty (app.Ylimit)
                         app.UIAxes.XLim =app.Xlimit;
                         app.UIAxes.YLim=app.Ylimit;
                    end
                
                
                
        end
end
end