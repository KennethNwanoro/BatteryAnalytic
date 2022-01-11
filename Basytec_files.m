        function Basytec_files(app)
            
            [files, pathname] = uigetfile({'*.txt', 'Text Files (*.txt)'; ...
                '*.*', 'All Files (*.*)'}, ...
                'Data Import', 'MultiSelect', 'on');
            
            cell_id = struct([]);
            %if files~=0
            
            if iscell(files)
                number_files= size(files,2);
            else
                number_files=1;
            end
            d = uiprogressdlg(app.BatteryAnalyticUIFigure,'Title','Please Wait',...
                'Message','Loading files...','ShowPercentage',"on");
            
            for ifille = 1: number_files
                d.Value = ifille/number_files;
                if iscell(files)
                    file = files(ifille);
                    file=char(file);
                    app.filename = fullfile(pathname,file);
                else
                    app.filename = fullfile(pathname,files);
                end
                
                [ImportData] = read_basytec_files(app,app.filename );
                
                %save file data, battery name and serial number
                cell_id(ifille).name = ImportData.Battery_id;
                cell_id(ifille).serialNo =ImportData.Serial_nr;
                cell_id(ifille).Data = ImportData.Data;
                
                % Ensure that cell serial number is not missing
                if isempty(cell_id(ifille).serialNo )
                    mesg =['File:',' ',file,' ','has no serial number.',' ', 'Add serial number and load again.'];
                    uialert(app.BatteryAnalyticUIFigure, mesg ,'Missing Serial Number','Icon','error');
                    
                    return
                end
                
            end
            
           
            
            
            % Group files according to cell serial number
            numCell = size(cell_id,2);   % total of imported files
            serialNo={};
            cellname={};
            
            % get serial number for each imported file
            for id = 1: numCell
                seriall=cell_id(id).serialNo;
                cellname=[ cellname; cell_id(id).name];
                serialNo = [serialNo; seriall ];
            end
            
            % get the unique serial number
            UniqSerial = unique(serialNo); % use this for creating listbox
            app.UniqSerial = UniqSerial;
            uniqcellname = unique(cellname);
            app.uniqcellname=uniqcellname;
            
            % assign each file to its unique cee serial number
            Uniq_Num = size(UniqSerial,1);
            File_count= {};
            for iuniq = 1 :  Uniq_Num
                uniqVal = UniqSerial(iuniq);
                uniqVal = char(uniqVal);
                
                idd =0;
                for id = 1: numCell
                    
                    
                    if cell_id(id).serialNo == uniqVal
                        idd= idd+1;
                        cell_id_files.Data{idd} = cell_id(id).Data;
                        cell_serial_id = cell_id(id).serialNo;
                        cell_name = cell_id(id).name;
                        
                    end
                    %number of files in serial no
                end
                %                   app.Cells(iuniq).data = cell_id_files;
                % change data to struct
                cell_data =[];
                
                Num = size(cell_id_files.Data,2);
                for ifille = 1: Num
                    cell_data(ifille).Data =  cell_id_files.Data{ifille};
                end
                app.File_count{iuniq} =num2str(Num);
                app.Cells(iuniq).serialNumber = cell_data;
                app.Cells(iuniq).data = cell_data;
                app.Cells(iuniq).name = cell_name;
                
                
            end
            
            
            %%%%%%%%%%%%%% Add Power in the data
            
            for icell= 1: size(app.Cells,2)
                for ifile = 1: size(app.Cells(icell).data ,2)
                    Power_step = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
                    Power_step2 = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
                    IR2 = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
                    new_data = addvars(app.Cells(icell).data(ifile).Data,Power_step,Power_step2,IR2);
                    stepN = app.Cells(icell).data(ifile).Data.StepNumber;
                    stepN= unique(stepN);
                    
                    Data_range =  find(app.Cells(icell).data(ifile).Data.StepNumber== stepN(1));
                    new_data.Power_step(Data_range)=0;
                    new_data.Power_step2(Data_range)=0;
                    new_data.IR2(Data_range)=0;
                    
                    for k5 = 2:length(stepN)
                        k6 = stepN(k5);
                        Data_range =  find(app.Cells(icell).data(ifile).Data.StepNumber==k6);
                        new_data.Power_step(Data_range)=new_data.Wh_step(Data_range)./new_data.StepTime(Data_range);
                        volt_step = app.Cells(icell).data(ifile).Data.Potential(Data_range);
                        curr_step = app.Cells(icell).data(ifile).Data.Current(Data_range);
                        volt_ave = mean(volt_step);
                        new_data.Power_step2(Data_range) = volt_ave* curr_step(end);
                      
                        new_data.IR2(Data_range) = (volt_step(end) - volt_step(1))/curr_step(end);
                    end
                    app.Cells(icell).data(ifile).Data.Power_step =  new_data.Power_step;
                    app.Cells(icell).data(ifile).Data.Power_step2 =  new_data.Power_step2;
                    app.Cells(icell).data(ifile).Data.IR2 =  new_data.IR2;
                end
            end
            
                           
                           
    % Couloumbic_charge_slippage(app)                      
                           
                           
            
            
            if size(app.Cells,2)>1 || size(app.Cells(1).data,2)>1
                appState(app)
            end
            
            uialert(app.BatteryAnalyticUIFigure,"Files loaded","Import files","Icon",'success')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%