function Full_test_profile_plots(app,cells,numCells)

cla(app.UIAxes,'reset')
linewidth = app.DVA_plot_line_width;
numaxes = size(app.Panel.Children,1);
if numaxes>1
    AxesControl(app,numaxes)
end
app.Panel.Visible = 'on';
app.UIAxes.Box= 'on';
app.UIAxes.XGrid ='on';
pos = [300,90,700,450];
app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];

app.UIAxes.BackgroundColor='W';
app.UIAxes.Visible ='off';
app.uilbl.Visible ='off';
app.uidrp.Visible ='off';
app.remove_limits.Visible ='off';
app.Barplot.Visible ='off';
pos = app.UIAxes.Position;
[col,font,ax1]=multiAxes(app,numCells,pos);
if col==0
    return
end
app.Panel.Title = 'Full Check-Up Test Profile';
str2l = char(app.Cells(1).name);


xlab = 'RunTime (hr)';

for iicell = 1: numCells
    icell = cells(iicell );
    ax1(iicell).Box = 'on';
    ax1(iicell).BackgroundColor='W';
    ax1(iicell).FontWeight ='B';
    cell_serial_No = app.UniqSerial(icell);
    cell_serial_No = char(cell_serial_No);
    
    if app.fileOption_status==0
        if ~iscell(app.files)
            app.getfiles = app.files;
        else
        app.getfiles =  cell2mat(app.files(iicell));
        end
    elseif app.fileOption_status==1
        app.getfiles = 1: app.files(iicell);
    end
    
    for ifille = 1:size( app.getfiles,2)
        
        ifile = app.getfiles(ifille);
        
        plot_val_x =  app.Cells(icell).data(ifile).Data.RunTime;
        legend_text = ['Test No',' ',num2str(ifile)];
        legend_text = ['Cycle No',' ',num2str(ifile)];
        
        
        switch app.plotVal
            case 1
             
                plot_val_y = app.Cells(icell).data(ifile).Data.Potential;
                ylab = 'Voltage (V)';
                
            case 2
               
                plot_val_y = app.Cells(icell).data(ifile).Data.Current;
                ylab = 'Current (A)';
                
            case 3
               
                plot_val_y = app.Cells(icell).data(ifile).Data.Ah_step;
                ylab = 'Current (Ah)';
                
                
            case 4
               
                plot_val_y = app.Cells(icell).data(ifile).Data.Temperature;
                ylab=['Temperature',' ', '(', (char(176)) 'C', ')'];
                
                
            case 5
                
                curr = app.Cells(icell).data(ifile).Data.Current;
                plot_val_y =  curr/app.rated_capacity(icell);
                
        end

      
        plot(ax1(iicell), plot_val_x, plot_val_y ,'LineWidth',1.5,'DisplayName',legend_text)
       
        % Edit for line thicknes, marker type
        plot( plot_val_x, plot_val_y ,'LineWidth',3,'DisplayName',legend_text)

        hold on
        set(gcf,'color','w')
        xlabel(xlab)
        ylabel(ylab)
        grid on
        box on
      

         
%         if app.plotVal==4
%         xlim(ax1(iicell),[-5 (max( plot_val_x)+10)])
%         end
        hold(ax1(iicell),'on')
    end
    
   
    
    xlabel(ax1(iicell),xlab)
    ylabel(ax1(iicell),ylab)
    legend(ax1(iicell),'NumColumns',1,"FontSize",font,'Orientation',"horizontal","Location","best")
    strl=  ['Cell:',' ', cell_serial_No];
    ax1(iicell).Title.String = strl;
    ax1(iicell).YGrid = 'on';
    ax1(iicell).XGrid = 'on';
    hold(ax1(iicell),'off')
    
%     legend('Uncompressed','Novel rig','Two plate rig','Inhomogenous compression')
%     xlim([-0.5 35])
    
    
      % edit for y and x axes limits and legend
%         legend('Voltage1', 'Voltage2')
%         xlim([ -1 80])
%         ylim([2.1 4.5])
end




end





