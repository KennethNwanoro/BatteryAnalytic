function All_cycle_data_capacity(app)

for icell= 1: size(app.Cells,2)
    Cap = [];
for ifile = 1: size(app.Cells(icell).data ,2)
        stepN = app.Cells(icell).data(ifile).Data.StepNumber;
        stepN= unique(stepN);
        stepN = stepN(2:end-1);
        discharge_steps = stepN(2:2:end);
        Ah = [];
        for istep = 1: length(discharge_steps)
            k7 = discharge_steps(istep);
            Data_range =  find(app.Cells(icell).data(ifile).Data.StepNumber==k7);
             Ah = [Ah; app.Cells(icell).data(ifile).Data.Ah_step(Data_range(end))];
        end
        Cap = [Cap; Ah];
       
end
 Capp = [];
 Capp = Cap/Cap(1);
Capp = abs(Cap);
%Capp= smoothdata(Capp, 'gaussian',200);
X = 1:length(Capp);
 %plot(X, Capp, 'LineWidth',2, 'Marker','o')
 scatter(X, Capp,15,'filled')
hold on
end

%legend ({'AGM 4628 : 0.3 Ah','AGM 5076 : 0.4 Ah','AGM 5789 : 0.2 Ah', })

%0.3 Ah cells
%legend ({'AGM 4636 : 0.10 MPa','AGM 4629 : 0.05 MPa' })
%0.4 Ah cells
%legend ({'AGM 5069 : 0.10 MPa','AGM 5070 : 0.05 MPa' })

%0.2 Ah cells
%legend ({'AGM 5791: 0.10 MPa' })
set(gcf,'color','w')
xlabel('Cycles')
ylabel('Relative Capacity (%)')
ylabel('Absolute Capacity (Ah)')
grid on
box on
%set(gca,'Ytick',0:50:400)
%xlim([-1 120])
%ylim([3.8 3.89])
legend('KOKAM 10')
