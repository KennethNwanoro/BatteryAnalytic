function relative_capacity_SOC_plot(app)


[stepNum,cells,numCells,~] =Capacity_plot_Panel_contrl(app);
linewidth = app.DVA_plot_line_width;
app.Panel.Title ='Relative Capacity Plot';
app.UIAxes.FontWeight ='B';
storage_period=  {'0 month', '1 month','2 months', '3 months','4 months',...
    '5 months','6 months','7 months', '12 months','18 months', '23 months'};
AH = [];
for iicell = 1: numCells
    icell = cells(iicell );
%     cell_serial_No = storage_period(iicell);
%     cell_serial_No =char(cell_serial_No);
    Ah=[];    
    
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
        Data_range = find(app.Cells(icell).data(ifille).Data.StepNumber == 11);
        Ah0 =  app.Cells(icell).data(ifille).Data.Ah_step(Data_range(end));
        end
        
        Ah = [Ah;Ah0];
    end
    Ah = Ah/Ah(1);
    AH = [AH Ah];
   % AH = flip(AH,2);
end
    numColor = size( AH ,1);
    customJet = jet(numColor);
     for isoc = 1: size(AH,1)
        custom_colour = customJet(isoc,:);
        legend_text =  char(storage_period(isoc));
         x= [0,20,40,60,80,100]';
         plot(app.UIAxes,x,AH(isoc,:)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10,'Color',custom_colour)
         hold(app.UIAxes,'on')
       
     end
        %plot(app.UIAxes,x, Ah/ Ah(1)*100,'LineWidth',linewidth,'DisplayName',legend_text,'Marker','.',"MarkerSize",10)
        xlabel(app.UIAxes,'Storage SOC (%)'); ylabel(app.UIAxes,'Relative Capacity (%)')
        
        
       
        legend(app.UIAxes,'Orientation','horizontal','Location','southeast','NumColumns',3)
    end
    
