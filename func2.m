 
        function func2(app)
            app.stepChange.Visible= 'off';
            app.Align_right.Visible ='off';
            app.remove_limits.Visible ='off';
            app.uilbl.Visible ='off';
            app.uidrp.Visible ='off';
            app.Barplot.Visible = 'off';
            numaxes = size(app.Panel.Children,1);
            if numaxes>1
                AxesControl(app,numaxes)
            end
            pos = [300,90,700,450];
            app.UIAxes.Position=[10 5 pos(3)-10 pos(4)-25];
            app.Panel.Visible = 'on';
            app.UIAxes.Box= 'on';
            app.UIAxes.BackgroundColor='W';
            axis(app.UIAxes, 'on');
            app.Panel.Title = 'Full Check-Up Test Profile';
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        