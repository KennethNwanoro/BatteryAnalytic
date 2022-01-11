function  detect_DVA_steps(app)
numcells = size(app.Cells,2);

for icell = 1 : numcells
    
    for ifile= 1: size(app.Cells(icell).data,2)
        ichar = 0; idisch = 0;
        StepNumbas = app.Cells(icell).data(ifile).Data.StepNumber;
        uniqstepNumba = unique(StepNumbas);
        app.UniqueStepNumber = uniqstepNumba;
        
        for istep = 1:length(uniqstepNumba)
            stepnum = uniqstepNumba(istep);
            stepLength = (app.Cells(icell).data(ifile).Data.StepNumber==stepnum);
            stepCurrent = app.Cells(icell).data(ifile).Data.Current(stepLength);
            if stepCurrent(4:end) == 0
                
            elseif stepCurrent(3:end)>0
                ichar = ichar+1;
                File(ifile).Charge_stepNumber(ichar) = stepnum;
                File(ifile).Charge_Current{ichar} = stepCurrent;
                
            elseif stepCurrent(3:end)<0
                idisch = idisch+1;
                File(ifile).Discharge_stepNumber(idisch) = stepnum;
                File(ifile).Discharge_Current{idisch} =stepCurrent;
            end
            
        end
        getChargCurrents = File(ifile).Charge_Current;
        getChargeLengths= cellfun('size', getChargCurrents,1);
        [~,chr_idx] = max(getChargeLengths);
        app.Cells(icell).Charge_DVAstep{ifile} =File(ifile).Charge_stepNumber(chr_idx);
        
        
        getDishargCurrents = File(ifile).Discharge_Current;
        getdischargeLengths= cellfun('size', getDishargCurrents,1);
        [~,disch_idx] = max(getdischargeLengths);
        app.Cells(icell).Discharge_DVAstep{ifile} = File(ifile).Discharge_stepNumber(disch_idx);
        
        
    end
    
    
end

end