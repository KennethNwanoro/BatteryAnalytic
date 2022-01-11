
function Novonix_files(app)

prompt = {'Enter number of cell ids to analyse:'};
dlgtitle = 'Input';
dims = [1 50];
definput = {'1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
val = str2double(answer);
if isempty(answer)
    app.Nov_status =0;
    return
end

File_count= {}; % initial file count for each cell id

app.Cells = ([]);

for icell = 1:val
    str_op = num2str(icell);
    str1 = ['Enter the name of cell id:',' ',str_op];
    prompt1 = {str1};
    dlgtitle1 = 'Cell name';
    dims = [1 50];
    definput2 = {'AGM 001'};
    cell_name = inputdlg(prompt1,dlgtitle1,dims,definput2);
    if isempty(cell_name)
        app.Nov_status =0;
        return
    end
    %name_cell=convertCharsToStrings(cell_name );
    app.Cells(icell).name = cell_name;
    
    
    
    [files, pathname] = uigetfile({'*.csv', 'CSV Files (*.csv)'; ...
        '*.*', 'All Files (*.*)'}, ...
        'Data Import', 'MultiSelect', 'on');
    if isequal(files,0)
        app.Nov_status =0;
        return
    end
    
    d = uiprogressdlg(app.BatteryAnalyticUIFigure,'Title','Please Wait',...
        'Message','Loading files...','ShowPercentage',"on");
    
    if iscell(files)
        number_files= size(files,2);
    else
        number_files=1;
    end
    cell_id = struct([]);
    
    app.File_count{icell} =num2str(number_files);
    for ifille = 1: number_files
        d.Value = ifille/number_files;
        
        if iscell(files)
            file = files(ifille);
            file=char(file);
            filename = fullfile(pathname,file);
        else
            filename = fullfile(pathname,files);
        end
        cell_id(ifille).Data = readtable(filename, 'PreserveVariableNames',true);
        
        if size(cell_id(ifille).Data,2)>15  % Some files add additional empty column
         cell_id(ifille).Data = cell_id(ifille).Data(:,1:15);   
        end
        cell_id(ifille).Data.Properties.VariableNames= {'DateAndTime','CycleNumber',...
            'StepType','RunTime','StepTime','Current','Potential','Capacity',...
            'Temperature','CircuitTemperature','Energy','dVdt','dIdt',...
            'StepNumber','StepPosition'};
       
        
    end
    app.Cells(icell).data = cell_id ;
end


Add_parameters_to_Novonix(app)
%Couloumbic_charge_slippage(app)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

% Sort files according to cell serial numbers/name
value ={};
numcells= size(app.Cells,2);
for cell_id = 1: numcells
    val= [app.Cells(cell_id).name];
    vall = char(val);
    value =[value; vall];
end
app.uniqcellname = value;

app.UniqSerial = value; % may be ask user to manually add it
if size(app.Cells,2)>1 || size(app.Cells.data,2)>1
    appState(app)
end
app.Nov_status =1;




end