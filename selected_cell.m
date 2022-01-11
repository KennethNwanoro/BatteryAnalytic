  % get index of user selected cell ids/serial no/names
        function selected_cell(app)
            switch app.data_source
                case 'Basytec'
                    cellSerial = app.UniqSerial;
                   
                    selected_Cells =[];
                    if size(app.Cells,2)==1 && size(app.Cells(1).data,2)==1
                        value = cellSerial;
                    else
                    value= app.lbx.Value;
                    end
                    
                    for ii =1: size(value,2)
                        selected_Cells = [selected_Cells;find(strcmp(cellSerial,value(ii)))];
                    end
                    
                case 'Novonix'
                    cellSerial = app.uniqcellname;
                    selected_Cells =[];
                    
                    if size(app.Cells,2)==1 && size(app.Cells.data,2)==1
                        selected_Cells =  1;
                    else
                        
                        value= app.lbx.Value;
                        for ii =1: size(value,2)
                            selected_Cells = [selected_Cells;find(strcmp(cellSerial,value(ii)))];
                        end
                    end
            end
            app.selected_Cells = selected_Cells;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%