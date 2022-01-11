function[stepNum,cells,numCells,cyc_length] = Capacity_plot_Panel_contrl(app)
            cla(app.UIAxes,'reset')
            app.stepChange.Visible ='off';
            app.Align_right.Visible ='off';
            app.uilbl.Visible ='off';
            app.uidrp.Visible ='off';
            app.remove_limits.Visible ='off';
            app.Barplot.Visible ='off';
            cyc_length =0;
            numaxes = size(app.Panel.Children,1);
            if numaxes>1
                AxesControl(app,numaxes)
            end
            pos = [300,90,700,450];
            app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
            app.Panel_2.Visible ='off';
            app.Panel.Visible ='off';
            
%           switch app.data_source
 %              case 'Basytec'
            stepNum  = inputdlg('Enter StepNumber for analysis:', 'StepNumber', [1 50]);
            if isempty(stepNum)
                stepNum = [];
                cells = [];
                numCells =[];
                cyc_length =[];
                return
            end
            stepNum  = str2double( stepNum);
            
%                case 'Novonix'
%                    stepNum =[];
%            end
           
            if strcmp(app.Test_type,'Check-Up')
                cyc_length  = inputdlg('Enter cycling length value:', 'Cycle length', [1 50]);
                if isempty(cyc_length)
                    return
                end
                cyc_length  = str2double(cyc_length);
            end
            
            selected_cell(app);
            cells = app.selected_Cells;
            numCells= size(cells,1);
            app.Panel.Visible ='on';
            app.UIAxes.Visible='on';
            app.UIAxes.Box = 'on';
            app.UIAxes.BackgroundColor ='w';
            
        end
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%
        