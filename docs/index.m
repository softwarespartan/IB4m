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
cd ~/Dropbox/IB4m

%%
% OK, now add _IB4m_ and _IB4m/docs_ to your matlab path 
addpath(path,pwd);  addpath(path,fullfile(pwd,'docs'))

%%
% Finally, add TWS.jar to the (dynamic) java classpath
javaaddpath(fullfile(pwd,'Jar','TWS.jar'))

%%
% You're all set!  Do a quick test to get summary of your IB account
AccountSummaryExample 

%%
% To save your matlab path use "savepath" or "pathtool".  
% Also, consider adding TWS.jar to your static java classpath ("edit classpath.txt").  
% Otherwise, will need to add the jar file after each matlab restart.

%% Tutorials
%
% Tutorials for MarketData, Scanner Subscriptions, Execution Details, and more.  Everything you need to get up and running.
%
% * <http://softwarespartan.github.io/IB4m/docs/html/ScannerSubscriptionExample.html Market Scanner Subscriptions>
% * <http://softwarespartan.github.io/IB4m/docs/html/MarketDataExample.html Real-time Market Data (Level I)>
% * <http://softwarespartan.github.io/IB4m/docs/html/MarketDepthExample.html Real-time Market Depth (Level II)>
% * <http://softwarespartan.github.io/IB4m/docs/html/HistoricalDataExample.html Historical Data Requests>
%
% * <http://softwarespartan.github.io/IB4m/docs/html/ContractDetailsExample.html Obtain Contract Details>
% * <http://softwarespartan.github.io/IB4m/docs/html/ExecutionDetailsExample.html Subscribe to Order Execution Details>
% * <http://softwarespartan.github.io/IB4m/docs/html/OpenOrdersExample.html Request OpenOrders>
%
% * <http://softwarespartan.github.io/IB4m/docs/html/AccountSummaryExample.html Get Account Summary>
% * <http://softwarespartan.github.io/IB4m/docs/html/AccountUpdatesExample.html Subscribe to Account Updates>
% * <http://softwarespartan.github.io/IB4m/docs/html/PortfolioUpdateExample.html Configure real-time Portfolio Updates>
% * <http://softwarespartan.github.io/IB4m/docs/html/PositionsExample.html Request current positions>
%
% * <http://softwarespartan.github.io/IB4m/docs/html/ErrorExample.html Processing API error events>
% * <http://softwarespartan.github.io/IB4m/docs/html/NextOrderIdExample.html Request and listen for NextOrderId>
%%
% Have fun!

%% Getting More Help
% Email brown.2179-at-gmail.com with questions, suggestions, comments etc.  

%% References
%
% * <http://www.interactivebrokers.com/download/newMark/PDFs/APIprintable.pdf IB API Reference>
% * <https://www.interactivebrokers.com/download/JavaAPIGettingStarted.pdf Java API Getting Started Guide>
%
% * <https://www.interactivebrokers.com/en/?f=%2Fen%2Fcontrol%2Fsystemstandalone.php%3Fos%3Dwin%26amp%3Bib_entity%3D  TraderWorkstation Download (Windows)>
% * <https://www.interactivebrokers.com/en/?f=%2Fen%2Fcontrol%2Fsystemstandalone.php%3Fos%3Dmac%26amp%3Bib_entity%3D  TraderWorkstation Download (Mac)>
% * <https://www.interactivebrokers.com/en/?f=%2Fen%2Fcontrol%2Fsystemstandalone.php%3Fos%3Dunix%26amp%3Bib_entity%3D TraderWorkstation Download (Unix)>
%
% * <https://www.interactivebrokers.com/en/?f=%2Fen%2Fsoftware%2FinstallationInstructions.php TraderWorkstation Install Instructions>
%
% * <https://www.interactivebrokers.com/en/index.php?f=tws&p=papertrader IB PaperTrader>
% * <http://ibkb.interactivebrokers.com/node/663 IBKB: Open Paper Trading Account>

%% System Requirements 
%
% IB4m has been tested on OSX 10.10, Windows 7, and Windows 8 with both Java 7 and Java 8 using the latest versions of Trader Workstation (Dec 19, 2014, Server versions 75 and 76)