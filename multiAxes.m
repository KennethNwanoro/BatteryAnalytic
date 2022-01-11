function [col,font,ax1]=multiAxes(app,numCells,pos)
%This function determines number of axes to use for multiple
% axes plots
if numCells>4
    uialert(app.BatteryAnalyticUIFigure,'Maximum of 4 cell ids can be plotted at once','Cell ids','Icon','error')
    col =0;
    ax1 =0;
    font =0;
    return
end
switch numCells
    case 1
        ax1(1) = uiaxes('Parent',app.Panel,'Position',app.Panel.Children.Position);
        app.UIAxes.Position=[0 0 0 0];
        col =1;
        font= 8;
    case 2
        col =1;
        font= 8;
        hei= pos(4);
        wid= (pos(3)/2) - 20;
        app.UIAxes.Position=[0 0 0 0];
        ax1(1) = uiaxes('Parent',app.Panel,'Position',[pos(1) pos(2)  wid hei]);
        ax1(2) = uiaxes('Parent',app.Panel,'Position',[wid+20 pos(2)  wid hei]);
    case 3
        col =1;
        font= 7;
        hei= pos(4);
        wid= (pos(3)/3) - 10;
        app.UIAxes.Position=[0 0 0 0];
        ax1(1) = uiaxes('Parent',app.Panel,'Position',[pos(1) pos(2)  wid hei]);
        ax1(2) = uiaxes('Parent',app.Panel,'Position',[wid+10 pos(2)  wid hei]);
        ax1(3) = uiaxes('Parent',app.Panel,'Position',[2*wid+10 pos(2) wid hei]);
    case 4
        app.UIAxes.Position=[0 0 0 0];
        col =1;
        font= 7;
        hei= pos(4)/2-10;
        wid= (pos(3)/2) - 20;
        app.UIAxes.Position=[0 0 0 0];
        ax1(1) = uiaxes('Parent',app.Panel,'Position',[pos(1) pos(2)+hei+10  wid hei]);
        ax1(2) = uiaxes('Parent',app.Panel,'Position',[wid+20 pos(2)+hei+10  wid hei]);
        ax1(3) = uiaxes('Parent',app.Panel,'Position',[pos(1) pos(2)  wid hei]);
        ax1(4) = uiaxes('Parent',app.Panel,'Position',[wid+20 pos(2)  wid hei]);
end

end