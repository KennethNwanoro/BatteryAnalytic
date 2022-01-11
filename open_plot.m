function open_plot(app)           
fig = figure;
            fig.Visible = 'off';
            fig.NumberTitle ='off';
            
            
            % Copy all UIAxes children, also check multi-cell plots using
            % panel
            if strcmp(app.UIAxes.Visible,'off')
                % get positions of the figure axes
                % according to the number of axes
                % currently in UIPanel
                Numplots= size(app.Panel.Children,1)-1;
                switch Numplots
                    case 1
                        pos{1} = [0.2 0.3 0.5 0.5];
                        
                    case 2
                        pos{1} = [0.1 0.3 0.35 0.6];
                        pos{2} = [0.55 0.3 0.35 0.6];
                        
                    case 3
                        pos{1} = [0.05 0.3 0.25 0.6];
                        pos{2} = [0.35 0.3 0.25 0.6];
                        pos{3} = [0.65 0.3 0.25 0.6];
                        
                    case 4
                        pos{1} = [0.1 0.15 0.35 0.3];
                        pos{2} = [0.55 0.15 0.35 0.3];
                        pos{3} = [0.1 0.55 0.35 0.3];
                        pos{4} = [0.55 0.55 0.35 0.3];
                        
                end
                for iax= 1: size(app.Panel.Children,1)
                    if app.Panel.Children(iax).Position ==[0 0 0 0]
                        
                    else
                        
                        figAxes(iax) = axes('Parent',fig,'Position',pos{iax});
                        figAxes(iax).Box = 'on';
                        figAxes(iax).Visible = 'on';
                        
                        % figAxes(iax).Position= posi;
                        allChildren = app.Panel.Children(iax).XAxis.Parent.Children;
                        copyobj(allChildren, figAxes(iax))
                        
                    end
                end
                
            else
                figAxes = axes(fig);
                figAxes.Box ='on';
                allChildren = app.UIAxes.XAxis.Parent.Children;
                copyobj(allChildren, figAxes)
                
            end
            fig.Visible = 'on';
end