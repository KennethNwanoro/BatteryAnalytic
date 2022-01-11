 %%% Adapted from Peter Kiel's code
        function [ImportData ] = read_basytec_files(app,filename)
            
            info_fields = {'Battery_id'; 'Serial_nr'; 'Testname'; 'Testplan'; 'Channel_id'; 'Starttime'; 'Endtime'};
            header_strings = {'Battery: '; 'Battery serial: ' ; 'Name of Test: '; 'Testplan: '; 'Testchannel: '; 'Start of Test: '; 'End of Test: '};
            info_table = table(info_fields, header_strings, 'VariableNames', {'fieldnames','header_strings'});
            
            % Check number of input arguments
            assert(nargin >= 1, 'Not engough input arguments.');
            
            % Initialize output variables
            TestInfo.Header = cell(0,1);
            Variables = cell(0,0);
            Units = cell(0,0);
            ControlChars = struct();
            
            % Open file for read access
            [fileID,errmsg] = fopen(filename,'r');
            
            % Check for errors in file opening
            if fileID == -1
                TestInfo.error = ['Error for ' filename ': Could not be loaded for header extraction. (' errmsg ')'];
                disp(TestInfo.error);
                return
            end
            
            % Read first line&character to obtain comment char
            tline = fgetl(fileID);
            if ~ischar(tline)
                TestInfo.error = ['Error for ' filename ': No comment char could be identified.'];
                disp(TestInfo.error);
                fclose(fileID);
                return
            else
                comment_char = tline(1);
                ControlChars.Comment = comment_char;
            end
            
            % Analyze all comment lines
            while(tline(1)==comment_char)
                for k1 = 1:height(info_table)
                    n_pos = strfind(tline,info_table.header_strings{k1});
                    if (min(n_pos) == 2)
                        len_str = length(info_table.header_strings{k1});
                        TestInfo.(info_table.fieldnames{k1}) = tline(len_str+2:end);  % 1-1 for the comment char, +2 to skip the space after the header_string
                    end
                end
                TestInfo.Header{end+1,1} = tline;
                tline = fgetl(fileID);  % read next line
            end
            
            ImportData = TestInfo;
            
            % Inspect last header line, which must contain the column names
            tline = TestInfo.Header{end,1};
            
            % Find delimiter char in the line containing the column headers
            % The delimiter char can be found after a ']'
            n_pos = strfind(tline,']');
            if isempty(n_pos)
                TestInfo.error = ['Error for "' filename '": No delimiter char could be identified.'];
                disp(TestInfo.error);
            else
                delimiter_char = tline(min(n_pos)+1);
                ControlChars.Delimiter = delimiter_char;
                
                % Check for correct time format: no colons are allowed to be used
                if contains(tline,':')
                    TestInfo.error = ['Error for "' filename '": Colons detected -> probably exported with wrong time format.'];
                    disp(TestInfo.error);
                else
                    % Extract variable names and variable units
                    tmpVariables = textscan(tline(2:end),'%s','Delimiter',delimiter_char);
                    BST_Names = tmpVariables{1};
                    VariableNames = BST_Names;
                    VariableUnits = BST_Names;
                    % convert all name entries and separate units
                    for k1 = 1:length(BST_Names)
                        [idx_start, idx_end] = regexp(BST_Names{k1},'\[.*\]');
                        VariableNames{k1}(idx_start:idx_end) = [];
                        VariableUnits{k1} = BST_Names{k1}(idx_start:idx_end);
                    end
                    
                    % capitalize only first letter of variable names and eliminate forbidden
                    % characters
                    for k1 = 1:length(VariableNames)
                        tmp_name = lower(VariableNames{k1});
                        tmp_name(1) = upper(tmp_name(1));
                        VariableNames{k1} = matlab.lang.makeValidName(tmp_name);
                    end
                    
                    % Convert Individual Variable Names to Standard Names
                    NamesOldBst = {'Time';'U';'I';'Ah';'T_step';'T1';'Line';'Cyc_count'};
                    NamesNewBst = {'RunTime';'Potential';'Current';'Capacity';'StepTime';'Temperature';'StepNumber';'CycleNumber'};
                    
                    for k1 = 1:length(NamesOldBst)
                        bool = strcmp(VariableNames,NamesOldBst{k1});
                        if sum(bool)
                            VariableNames(bool) = NamesNewBst(k1);
                        end
                    end
                    
                    Variables =     VariableNames;
                    Units = VariableUnits;
                end
            end
            
            % Close file
            fclose(fileID);
            
            
            if ~isempty(Variables)
                % Read data
                ImportData.Data = readtable(filename,  'FileType', 'text', ...
                    'Delimiter',ControlChars.Delimiter, ...
                    'HeaderLines', length(ImportData.Header), ...
                    'ReadVariableNames',false);
                
                % Complete Table Properties
                ImportData.Data.Properties.VariableNames = matlab.lang.makeUniqueStrings(Variables);
                ImportData.Data.Properties.VariableUnits = Units;
                
                % Add DateTime column and convert table to timetable
                start_time = datetime(ImportData.Starttime,'Locale','de_DE');
                Date_Time = start_time + ImportData.Data.RunTime/24;
                ImportData.Data = table2timetable(ImportData.Data,'RowTimes',Date_Time);
            end
            
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%