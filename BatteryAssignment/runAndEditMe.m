    %%Initialization, Do Nothing Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Battery Simulation, Excercise 1
%
%Rickard Arvidsson, arvidssr@chalmers.se 
clc; clear all;
load 'cycle.mat'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Edit Below This Line%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Create the Input Power Needed from the Drivecycle
PowerInputVector = [TimeTot, PowerRequest/1000];


%Select your Design Of Experiments Here for Cells in Series and Parallel The Grid below is an
%example. Select a Proper Grid Size: Don't use the example stated below with 


n_cell_series_DOE = round(linspace(50,120,30));

%Number of Cells in Parallell Select
n_cell_parallel_DOE = round(linspace(1,10,7));

%Do not change this
n_cell_series = Simulink.Parameter;
n_cell_series.CoderInfo.StorageClass = 'ExportedGlobal';
n_cell_parallel = Simulink.Parameter;
n_cell_parallel.CoderInfo.StorageClass = 'ExportedGlobal';


%% Run the Model for all Above Configurations to find the Optimum Combination
for i=1:length(n_cell_series_DOE)
    for j=1:length(n_cell_parallel_DOE)
        init_SOC = 0.9;
        n_cell_series.Value = n_cell_series_DOE(i);
        n_cell_parallel.Value = n_cell_parallel_DOE(j);
        warning off;
        [bat, becm] = batteryparameter(n_cell_series_DOE(i), n_cell_parallel_DOE(j), init_SOC);
        simulation = sim('batterymodel', 'SimulationMode','Accelerator');
        SIMOUT = simulation.get('yout');

        %%Fulfilling Requirement; Your DOE Simulation Output is Stored in
        %%the Struct SIM for each Type of Cell Configuration you choosed
        
        %Current Output
        SIM{i,j}.Current = SIMOUT(:,2); %[A]
        %Voltage Output
        SIM{i,j}.Voltage = SIMOUT(:,4); %[V]
        %SOC Output
        SIM{i,j}.SOC = SIMOUT(:,3)*100; %[%]
        %And all comes with a price:
        SIM{i,j}.cost = 2*n_cell_series_DOE(i)*n_cell_parallel_DOE(j);
 
        
        %Add check to see if the Output are inside the configuration
 
    end
end


%% Maybe add some more content here?
%% First Define and Check the Current Limitations 

%Voltage Limitaions?
%Maybe a For-Loop similar to the one above?

