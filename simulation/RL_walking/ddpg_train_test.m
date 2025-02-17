% Walking Robot -- DDPG Agent Training Script (3D)
% Copyright 2019 The MathWorks, Inc.
close all;
%% SET UP ENVIRONMENT
% Speedup options
useFastRestart = true;
useGPU = false;
useParallel = false;

% Create the observation info
numObs = 26;
observationInfo = rlNumericSpec([numObs 1]);
observationInfo.Name = 'observations';
Ts = 0.2;
Tf = 5;
init_height = 0.54;

% create the action info
numAct = 8;
actionInfo = rlNumericSpec([numAct 1],'LowerLimit',-pi/2,'UpperLimit', pi/2);
actionInfo.Name = 'foot_angle';

% Environment
mdl = 'RLrobot';
load_system(mdl);
blk = [mdl,'/RL Agent'];
env = rlSimulinkEnv(mdl,blk,observationInfo,actionInfo);
env.ResetFcn = @(in)walkerResetFn(in);
if ~useFastRestart
   env.UseFastRestart = 'off';
end

%% CREATE NEURAL NETWORKS
createDDPGNetworks;
                
%% CREATE AND TRAIN AGENT
createDDPGOptions;
agent = rlDDPGAgent(actor,critic,agentOptions);
trainingResults = train(agent,env,trainingOptions)

%% SAVE AGENT
reset(agent); % Clears the experience buffer
curDir = pwd;
saveDir = 'savedAgents';
cd(saveDir)
save(['trainedAgent_3D_' datestr(now,'mm_DD_YYYY_HHMM')],'agent');
save(['trainingResults_3D_' datestr(now,'mm_DD_YYYY_HHMM')],'trainingResults');
cd(curDir)