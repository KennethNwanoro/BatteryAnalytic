      function AxesControl(app,numaxes)
            %This function deletes additional axes created for mult plots
            % This is a temporary solution, better solution is to use
            %  find to get the positional values of axes in the panel
            
            for iaxs= 1: numaxes
                iax =1;
                axisPos = app.Panel.Children(iax).Position;
                num=size(app.Panel.Children,1);
                if axisPos == [0 0 0 0] & num~=1
                    delete (app.Panel.Children(iax+1:end))
                    break
                    
                else
                    delete ( app.Panel.Children(iax))
                    if iaxs>1
                        iax=iaxs-1;
                    end
                    
                    if size(app.Panel.Children,1)==1
                        break
                    end
                end
            end
            
        end