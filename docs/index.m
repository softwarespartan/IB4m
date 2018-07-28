%% Welcome to IB4m
%
% Interactive Brokers API for Matlab
%
% For the latest src and docs visit  
% <http://softwarespartan.github.io/IB4m IB4m at github>
%  

%% Quick Start Guide
%
% Getting started with IB4m is easy.  Follow the steps below assuming you already have an IB tradding account and Trader Workstation installed.
%
% # Enable API access in TWS for "Active X and Socket Clients" (_File -> GlobalConfiguration -> API -> Settings_)
% # Add trusted IP address for local host 127.0.0.1 in TWS (_File -> GlobalConfiguration -> API -> Settings_)
% # Clone IB4m on Github: *git clone https://github.com/softwarespartan/IB4m.git* or download from Matlab File Central

%% 
% Navigate to the IB4m directory in Matlab
cd /some/path/to/IB4m

%%
% OK, now add _IB4m_ and _IB4m/docs_ to your matlab path 
addpath(path,pwd);  addpath(path,fullfile(pwd,'docs'))

%%
% Finally, add TWS.jar to the (dynamic) java classpath
javaaddpath(fullfile(pwd,'Jar','TWS973.jar'))

%%
% You're all set!  Do a quick test to get summary of your IB account
AccountSummaryExample 

%%
% To save your matlab path use "savepath" or "pathtool".  
% Also, consider adding TWS.jar to your static java classpath ("edit classpath.txt").  
% Otherwise, will need to add the jar file after each matlab restart.

%%
% Have fun!

%% Getting More Help
% Email brown.2179-at-gmail.com with questions, suggestions, comments etc.  

%% References
%
%    https://interactivebrokers.github.io/tws-api/index.html

%% System Requirements 
%
% IB4m has been tested on OSX 10.10, Windows 7, and Windows 8 with both Java 7 and Java 8 using the latest versions of Trader Workstation 