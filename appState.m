        function appState(app)
            app.BatteryAnalyticUIFigure.Position =[150,100,1050,550];
            app.Panel_3.Visible = 'on';
            app.QuickProfileplotsForSpecificStepNumbersPanel.Visible = 'on';
            app.RunCheckupAnalysisQuickButtonsPanel.Visible = 'on';
            app.Panel.Position=[300,90,700,450];
            app.Panel_2.Position=[300,15,700,70];
            detect_DVA_steps(app)
            uilabel(app.Panel_3,'Position',[20 260 120 20],'Text','Battery Name(s)')
            uilistbox(app.Panel_3,'Position',[20 240 120 20],'Items',app.uniqcellname)
            app.lbx=uilistbox(app.Panel_3,'Position',[20 125 90 80],'MultiSelect','on','Items',app.UniqSerial);
            uilistbox(app.Panel_3,'Position',[125 125 90 80],'MultiSelect','on','Items',app.File_count);%new
            uilabel(app.Panel_3,'Position',[20 205 215 20],'Text','Serial Numbers')
            uilabel(app.Panel_3,'Position',[125 205 120 20],'Text','File count') % new
            uilabel(app.Panel_3,'Position',[10 100 250 20],'Text','Select Serial Number(s) to plot or analyse')
            numbas = cellstr(num2str(app.UniqueStepNumber));
            app.DropDown.Items = numbas;
            
        end