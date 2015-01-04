%% Welcome to IB4m
%
% Interactive Brokers API in Matlab
%
% For the latest src and docs visit  
% <http://softwarespartan.github.io/IB4m IB4m at github>
%  

%% Quick Start Guide
%
% Getting up and running with IB4m is easy.  Follow the steps below assuming you already have an IB tradding account and Trader Workstation installed.
%
% # Enable API access in TWS for "Active X and Socket Clients" (_File -> GlobalConfiguration -> API -> Settings_)
% # Add trusted IP address for local host 127.0.0.1 in TWS (_File -> GlobalConfiguration -> API -> Settings_)
% # Clone IB4m on Github: *git clone https://github.com/softwarespartan/IB4m.git* 

%% 
% Navigate to the IB4m directory in Matlab
cd ~/Dropbox/IB4m

%%
% OK, now add IB4m and IB4m/docs to your matlab path 
addpath(path,pwd);  addpath(path,fullfile(pwd,'docs'))

%%
% Finally, add TWS.jar to your (dynamic) java classpath
javaaddpath(fullfile(pwd,'Jar','TWS.jar'))

%%
% Get summary of your IB account
AccountSummaryExample