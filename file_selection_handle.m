function file_selection_handle(app,cells,numfiles,mesg)

 fileOption = uiconfirm(app.BatteryAnalyticUIFigure,'Select file options to plot','Selection',"Options",{'Plot all files','Select files to plot','Cancel'});
        
        switch fileOption
            case 'Plot all files'
                app.files = numfiles(cells);
                app.fileOption_status =1;
            case 'Select files to plot'
                 app.files  =[];
                for ii = 1 : size(cells,1)
                     iice = cells(ii);
                    cell_serial_No = app.UniqSerial(iice);
                    cell_serial_No = char(cell_serial_No);
                  files  = inputdlg(['Enter file number for:', ' ',cell_serial_No],mesg , [1 75]);
                if isempty(files )
                    return
                end
                files = str2num(files{1});
                app.files{ii} = files;
                
%                 if max(cell2mat(app.getfiles))> max(str2double(app.File_count))
%                     uialert(app.BatteryAnalyticUIFigure,['File number must be within File count range'],"File count","Icon",'error')
%                     return
%                 end
                end
                app.fileOption_status =0;
            case 'Cancel'
                return
        end
end