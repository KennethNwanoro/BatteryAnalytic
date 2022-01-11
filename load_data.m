function load_data(app)

app.File_count =[];
cla(app.UIAxes,'reset')
app.Panel.Visible = 'off';
app.Panel_2.Visible = 'off';
app.Panel_3.Visible = 'off';
app.stepChange.Visible= 'off';
app.Align_right.Visible ='off';
app.remove_limits.Visible ='off';
app.uilbl.Visible ='off';
app.uidrp.Visible ='off';
app.Barplot.Visible = 'off';
app.QuickProfileplotsForSpecificStepNumbersPanel.Visible = 'off';
app.RunCheckupAnalysisQuickButtonsPanel.Visible = 'off';
fillename = uigetfile('*.mat', "Load Message");
if fillename
    uiprogressdlg(app.BatteryAnalyticUIFigure,'Title','Please Wait...',...
                    'Message','Loading Data...')
    load(fillename,'Cell_data','uniqSerial','Uniqcellname','file_count','Data_source');
    app.Cells = Cell_data;
    app.UniqSerial = uniqSerial;
    app.uniqcellname = Uniqcellname;
    app.File_count = file_count;
    app.data_source = Data_source;
    if size(app.Cells,2)>1 || size(app.Cells(1).data,2)>1        
        appState(app)
    end
    StateHandle(app)
    app.Panel_3.Title = ['Loaded',' ',Data_source, ' ', 'files'];
    uialert(app.BatteryAnalyticUIFigure, 'File Imported' ,'FData File','Icon','success');
end
end