function Add_parameters_to_Novonix(app)


%%%%%%%%%%%%%%% Add Ah_step and internal Resistance in Novonix files %%%%%%%%%%%%%%%%%%%%%%%%%%
for icell= 1: size(app.Cells,2)
    StepLength_charge =[];
    StepLength_disch = [];
    stepdisch =[];
    stepch = [];
    current_ch =[];
    current_disch = [];
    for ifile = 1: size(app.Cells(icell).data ,2)
        
        State = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
        Ah_step = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
        R_dc = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
        R_ac = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
        IR = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);
        IR2 = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1);% uses step response
        Power_step2 = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1); % uses product of average voltage and current
        Power_step = nan(length(app.Cells(icell).data(ifile).Data.StepNumber),1); % uses energy step
        new_data = addvars(app.Cells(icell).data(ifile).Data, State, Ah_step, R_ac,R_dc,IR,Power_step, Power_step2, IR2);
        
 
        stepN = app.Cells(icell).data(ifile).Data.StepNumber;
        stepN= unique(stepN);
        
        Data_range =  find(app.Cells(icell).data(ifile).Data.StepNumber== stepN(1));
        new_data.State(Data_range(1)) = 3;
        new_data.State(Data_range(2:end))=2;
        new_data.R_ac(Data_range)=0;
        new_data.IR(Data_range)=0;
        new_data.Power_step(Data_range)=0;
        new_data.Ah_step(Data_range)=0;
        new_data.IR2(Data_range)=0;
        new_data.Power_step2(Data_range)=0;
        % new_data.R_dc(Data_range)=0
        for k5 = 2:length(stepN)
            k6 = stepN(k5);
            
            Data_range =  find(app.Cells(icell).data(ifile).Data.StepNumber==k6);
            Data_previous = find(app.Cells(icell).data(ifile).Data.StepNumber== stepN(k5-1));
            new_data.State(Data_range(1)) = 3;
            new_data.State(Data_range(2:end))=2;
            
            
            if ~isempty(Data_range)
                
                volt_step = app.Cells(icell).data(ifile).Data.Potential(Data_range);
                curr_step = app.Cells(icell).data(ifile).Data.Current(Data_range);
                steptime = app.Cells(icell).data(ifile).Data.StepTime(Data_range);
                energy = app.Cells(icell).data(ifile).Data.Energy(Data_range);
                capacity = app.Cells(icell).data(ifile).Data.Capacity(Data_range);
                capacity_step =capacity - capacity(1);
                new_data.Ah_step(Data_range)=capacity_step;
                energy_step = energy - energy(1);
                new_data.Power_step(Data_range) = energy_step./steptime;
                volt_ave = mean(volt_step);
                new_data.Power_step2(Data_range) = volt_ave* curr_step(end);
                
                
                volt1 =  volt_step(1);
                curr1 = curr_step(1);
                
                volt2 = volt_step(2);
                curr2 = curr_step(2);
                
                volt_end = volt_step(end);
                curr_end = curr_step(end);
                new_data.IR2(Data_range) = (volt_end - volt1)/curr_step(end);
                
                
                Curr_diff =(curr2 -curr1);
                new_data.R_ac(Data_range(2:end)) =  (volt2-volt1) /Curr_diff;
                new_data.IR(Data_range(2:end)) = (volt_end-volt1) /(curr_end -curr1);
                new_data.R_ac(Data_range(1)) = new_data.R_ac(Data_previous(end));
                new_data.IR(Data_range(1)) = new_data.IR(Data_previous(end));
                % new_data.R_dc(Data_range) = (volt_step-volt_step(1))./(curr_step-curr_step(1));
                
                if curr_step(2:end)==0 % for mid pause/rest steps
                    new_data.R_ac(Data_range) = new_data.R_ac(Data_previous(end));
                    new_data.IR(Data_range) = new_data.IR(Data_previous(end));
                    new_data.Power_step(Data_range) =0;
                    new_data.Ah_step(Data_range) =0;
                elseif Curr_diff==0  % for constant current steps
                    new_data.R_ac(Data_range) = new_data.R_ac(Data_previous(end));
                    new_data.IR(Data_range) = new_data.IR(Data_previous(end));
                elseif abs(new_data.R_ac(Data_range(2:end))) >= 1 % for constant current steps where first measure current values are erratic
                    new_data.R_ac(Data_range) = new_data.R_ac(Data_previous(end));
                    new_data.IR(Data_range) = new_data.IR(Data_previous(end));
                end
                
                
                if   curr_end >0
                    StepLength_charge = [StepLength_charge ;length(Data_range)];
                    stepch =  [stepch; k6];
                    current_ch = [current_ch;curr_end];
                elseif  curr_end<0
                    StepLength_disch = [StepLength_disch ;length(Data_range)];
                    stepdisch =  [stepdisch; k6];
                    current_disch = [current_disch;curr_end];
                    
                end
                %
            end
        end
        
        
        
        app.Cells(icell).data(ifile).Data.Ah_step=new_data.Ah_step;
        app.Cells(icell).data(ifile).Data.R_ac=new_data.R_ac;
        app.Cells(icell).data(ifile).Data.IR2=new_data.IR2;
        app.Cells(icell).data(ifile).Data.Power_step2=new_data.Power_step2;
        app.Cells(icell).data(ifile).Data.IR=new_data.IR;
        app.Cells(icell).data(ifile).Data.Power_step=new_data.Power_step;
        % app.Cells(icell).data(ifile).Data.R_dc=new_data.R_dc;
        app.Cells(icell).data(ifile).Data.State=new_data.State;
        [~,Ind_disch]= max(abs(current_disch));
        [~,Ind_ch]= max(abs(current_ch));
        app.Cells(icell).Discharge_Resistance_Step{ifile} =  stepdisch(Ind_disch);
        app.Cells(icell).Charge_Resistance_Step{ifile} =  stepch(Ind_ch);
        
    end
end
end