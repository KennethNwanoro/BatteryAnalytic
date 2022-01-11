function save_plot(app)

fig = figure;
fig.Visible = 'off';
fig.Color ='w';

if strcmp(app.UIAxes.Visible,'off')
    % get positions of the figure axes
    % according to the number of axes
    % currently in UIPanel
    app.UIAxes.Position =[0 0 0 0];
    Numplots= size(app.Panel.Children,1)-1;
    switch Numplots
        case 1
            
            pos{1} = [0.2 0.3 0.5 0.5];
            col= 1;
            font = 7;
        case 2
            pos{1} = [0.1 0.3 0.35 0.6];
            pos{2} = [0.55 0.3 0.35 0.6];
            col= 1;
            font = 7;
        case 3
            pos{1} = [0.05 0.3 0.25 0.6];
            pos{2} = [0.35 0.3 0.25 0.6];
            pos{3} = [0.65 0.3 0.25 0.6];
            col= 1;
            font = 5;
        case 4
            pos{1} = [0.1 0.15 0.35 0.3];
            pos{2} = [0.55 0.15 0.35 0.3];
            pos{3} = [0.1 0.55 0.35 0.3];
            pos{4} = [0.55 0.55 0.35 0.3];
            col= 1;
            font = 5;
    end
    for iax= 1: size(app.Panel.Children,1)
        if app.Panel.Children(iax).Position ==[0 0 0 0]
            
        else
            
            figAxes(iax) = axes('Parent',fig,'Position',pos{iax});
            figAxes(iax).Box = 'on';
            figAxes(iax).Visible = 'on';
            figAxes(iax).FontWeight ='B';
            
            % figAxes(iax).Position= posi;
            allChildren = app.Panel.Children(iax).XAxis.Parent.Children;
            copyobj(allChildren, figAxes(iax))
            
            xlab= app.Panel.Children(iax).XLabel.String;
            ylab= app.Panel.Children(iax).YLabel.String;
            leg=app.Panel.Children(iax).Legend.String;
            
            if strcmp(app.retention_type,'Power')
                legend(figAxes(iax), leg, 'NumColumns',col,'FontSize',font,'Orientation',"horizontal",'Location','northwest');
            elseif strcmp(app.retention_type,'Capacity')
                legend(figAxes(iax), leg, 'NumColumns',col,'FontSize',font,'Orientation',"horizontal",'Location','northeast');
            elseif strcmp(app.retention_type,'Resistance')
                legend(figAxes(iax), leg, 'NumColumns',col,'FontSize',font,'Orientation',"horizontal",'Location','northwest');
            else
                figAxes(iax).FontWeight ='normal';
                grid(figAxes(iax), 'on')
                legend(figAxes(iax), leg, 'NumColumns',2,'FontSize',font, 'FontWeight','normal','Orientation',"horizontal",'Location','best');
            end
            
            figAxes(iax).YLabel.String=ylab ;
            %xlim(figAxes(iax), [-5 250])
            figAxes(iax).XLabel.String=xlab;
            figAxes(iax).LineWidth = 0.5;
            figAxes(iax).XLim = app.Panel.Children(iax).XLim;
            figAxes(iax).YLim = app.Panel.Children(iax).YLim;
            figAxes(iax).ZLim = app.Panel.Children(iax).ZLim;
            figAxes(iax).Title.String = app.Panel.Children(iax).Title.String;
            figAxes(iax).Title.FontSize = 6;
        end
    end
else
    figAxes = axes('Parent',fig);
    figAxes.Box = 'on';
    figAxes.Visible = 'on';
    grid(figAxes,'on')
    xlab= app.UIAxes.XLabel.String;
    ylab=app.UIAxes.YLabel.String;
    figAxes.YLabel.String=ylab ;
    figAxes.XLabel.String=xlab;
    figAxes.Title.String = app.UIAxes.Title.String;
    figAxes.LineWidth = 1;
    % Copy all UIAxes children,
    allChildren = app.UIAxes.XAxis.Parent.Children;
    copyobj(allChildren, figAxes)
    figAxes.XLim = app.UIAxes.XLim;
    figAxes.YLim = app.UIAxes.YLim;
    figAxes.ZLim = app.UIAxes.ZLim;
    %figAxes.FontWeight ='B';
    leg=app.Panel.Children.Legend.String;
    if strcmp(app.retention_type,'Power')
        legend(figAxes, leg, 'NumColumns',1,'FontSize',7,'Orientation',"horizontal", 'Location','northwest');
    elseif strcmp(app.retention_type,'Capacity')
        legend(figAxes, leg, 'NumColumns',1,'FontSize',7,'Orientation',"horizontal", 'Location','northeast');
    elseif strcmp(app.retention_type,'Resistance')
        legend(figAxes, leg, 'NumColumns',1,'FontSize',7,'Orientation',"horizontal",'Location','northwest');
    else
        legend(figAxes, leg, 'NumColumns',1,'FontSize',7,'Orientation',"horizontal",'Location','best');
    end
end

filter = {'*.fig';'*.png';'*.jpg';'*.*'};

fillename = uiputfile(filter, "Save Message" );
if fillename
    saveas(fig,fillename );
end

% Delete figure.
delete(fig);
end