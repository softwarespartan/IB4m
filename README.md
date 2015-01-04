```html

<!DOCTYPE html
  PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
   <!--
This HTML was auto-generated from MATLAB code.
To make changes, update the MATLAB code and republish this document.
      --><title>Welcome to IB4m</title><meta name="generator" content="MATLAB 8.4"><link rel="schema.DC" href="http://purl.org/dc/elements/1.1/"><meta name="DC.date" content="2015-01-04"><meta name="DC.source" content="index.m"><style type="text/css">
html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}:focus{outine:0}ins{text-decoration:none}del{text-decoration:line-through}table{border-collapse:collapse;border-spacing:0}

html { min-height:100%; margin-bottom:1px; }
html body { height:100%; margin:0px; font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#000; line-height:140%; background:#fff none; overflow-y:scroll; }
html body td { vertical-align:top; text-align:left; }

h1 { padding:0px; margin:0px 0px 25px; font-family:Arial, Helvetica, sans-serif; font-size:1.5em; color:#d55000; line-height:100%; font-weight:normal; }
h2 { padding:0px; margin:0px 0px 8px; font-family:Arial, Helvetica, sans-serif; font-size:1.2em; color:#000; font-weight:bold; line-height:140%; border-bottom:1px solid #d6d4d4; display:block; }
h3 { padding:0px; margin:0px 0px 5px; font-family:Arial, Helvetica, sans-serif; font-size:1.1em; color:#000; font-weight:bold; line-height:140%; }

a { color:#005fce; text-decoration:none; }
a:hover { color:#005fce; text-decoration:underline; }
a:visited { color:#004aa0; text-decoration:none; }

p { padding:0px; margin:0px 0px 20px; }
img { padding:0px; margin:0px 0px 20px; border:none; }
p img, pre img, tt img, li img, h1 img, h2 img { margin-bottom:0px; } 

ul { padding:0px; margin:0px 0px 20px 23px; list-style:square; }
ul li { padding:0px; margin:0px 0px 7px 0px; }
ul li ul { padding:5px 0px 0px; margin:0px 0px 7px 23px; }
ul li ol li { list-style:decimal; }
ol { padding:0px; margin:0px 0px 20px 0px; list-style:decimal; }
ol li { padding:0px; margin:0px 0px 7px 23px; list-style-type:decimal; }
ol li ol { padding:5px 0px 0px; margin:0px 0px 7px 0px; }
ol li ol li { list-style-type:lower-alpha; }
ol li ul { padding-top:7px; }
ol li ul li { list-style:square; }

.content { font-size:1.2em; line-height:140%; padding: 20px; }

pre, code { font-size:12px; }
tt { font-size: 1.2em; }
pre { margin:0px 0px 20px; }
pre.codeinput { padding:10px; border:1px solid #d3d3d3; background:#f7f7f7; }
pre.codeoutput { padding:10px 11px; margin:0px 0px 20px; color:#4c4c4c; }
pre.error { color:red; }

@media print { pre.codeinput, pre.codeoutput { word-wrap:break-word; width:100%; } }

span.keyword { color:#0000FF }
span.comment { color:#228B22 }
span.string { color:#A020F0 }
span.untermstring { color:#B20000 }
span.syscmd { color:#B28C00 }

.footer { width:auto; padding:10px 0px; margin:25px 0px 0px; border-top:1px dotted #878787; font-size:0.8em; line-height:140%; font-style:italic; color:#878787; text-align:left; float:none; }
.footer p { margin:0px; }
.footer a { color:#878787; }
.footer a:hover { color:#878787; text-decoration:underline; }
.footer a:visited { color:#878787; }

table th { padding:7px 5px; text-align:left; vertical-align:middle; border: 1px solid #d6d4d4; font-weight:bold; }
table td { padding:7px 5px; text-align:left; vertical-align:top; border:1px solid #d6d4d4; }





  </style></head><body><div class="content"><h1>Welcome to IB4m</h1><!--introduction--><p>Interactive Brokers API for Matlab</p><p>For the latest src and docs visit <a href="http://softwarespartan.github.io/IB4m">IB4m at github</a></p><!--/introduction--><h2>Contents</h2><div><ul><li><a href="#1">Quick Start Guide</a></li><li><a href="#7">Tutorials</a></li><li><a href="#9">Getting More Help</a></li><li><a href="#10">References</a></li><li><a href="#11">System Requirements</a></li></ul></div><h2>Quick Start Guide<a name="1"></a></h2><p>Getting started with IB4m is easy.  Follow the steps below assuming you already have an IB tradding account and Trader Workstation installed.</p><div><ol><li>Enable API access in TWS for "Active X and Socket Clients" (<i>File -&gt; GlobalConfiguration -&gt; API -&gt; Settings</i>)</li><li>Add trusted IP address for local host 127.0.0.1 in TWS (<i>File -&gt; GlobalConfiguration -&gt; API -&gt; Settings</i>)</li><li>Clone IB4m on Github: <b>git clone https://github.com/softwarespartan/IB4m.git</b> or download from Matlab File Central</li></ol></div><p>Navigate to the IB4m directory in Matlab</p><pre class="codeinput">cd <span class="string">~/Dropbox/IB4m</span>
</pre><p>OK, now add <i>IB4m</i> and <i>IB4m/docs</i> to your matlab path</p><pre class="codeinput">addpath(path,pwd);  addpath(path,fullfile(pwd,<span class="string">'docs'</span>))
</pre><p>Finally, add TWS.jar to the (dynamic) java classpath</p><pre class="codeinput">javaaddpath(fullfile(pwd,<span class="string">'Jar'</span>,<span class="string">'TWS.jar'</span>))
</pre><p>You're all set!  Do a quick test to get summary of your IB account</p><pre class="codeinput">AccountSummaryExample
</pre><pre class="codeoutput">added interface method: TWSNotification
notification listener has been added
Server Version:75
TWS Time at connection:20150104 18:32:00 EST
DU207406: RegTEquity = 1003650.61 (USD)
DU207406: LookAheadInitMarginReq = 0.00 (USD)
DU207406: RegTMargin = 0.00 (USD)
DU207406: GrossPositionValue = 0.00 (USD)
DU207406: LookAheadNextChange = 0 ()
DU207406: SMA = 1003650.62 (USD)
DU207406: ExcessLiquidity = 1003650.61 (USD)
DU207406: FullMaintMarginReq = 0.00 (USD)
DU207406: InitMarginReq = 0.00 (USD)
DU207406: FullAvailableFunds = 1003650.61 (USD)
DU207406: MaintMarginReq = 0.00 (USD)
DU207406: LookAheadMaintMarginReq = 0.00 (USD)
DU207406: FullExcessLiquidity = 1003650.61 (USD)
DU207406: LookAheadAvailableFunds = 1003650.61 (USD)
DU207406: LookAheadExcessLiquidity = 1003650.61 (USD)
DU207406: DayTradesRemaining = -1 ()
DU207406: FullInitMarginReq = 0.00 (USD)
DU207406: Cushion = 1 ()
DU207406: AvailableFunds = 1003650.61 (USD)
</pre><p>To save your matlab path use "savepath" or "pathtool". Also, consider adding TWS.jar to your static java classpath ("edit classpath.txt"). Otherwise, will need to add the jar file after each matlab restart.</p><h2>Tutorials<a name="7"></a></h2><p>Tutorials for MarketData, Scanner Subscriptions, Execution Details, and more.  Everything you need to get up and running.</p><div><ul><li><a href="http://softwarespartan.github.io/IB4m/docs/html/ScannerSubscriptionExample.html">Market Scanner Subscriptions</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/MarketDataExample.html">Real-time Market Data (Level I)</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/MarketDepthExample.html">Real-time Market Depth (Level II)</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/HistoricalDataExample.html">Historical Data Requests</a></li></ul></div><div><ul><li><a href="http://softwarespartan.github.io/IB4m/docs/html/ContractDetailsExample.html">Obtain Contract Details</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/ExecutionDetailsExample.html">Subscribe to Order Execution Details</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/OpenOrdersExample.html">Request OpenOrders</a></li></ul></div><div><ul><li><a href="http://softwarespartan.github.io/IB4m/docs/html/AccountSummaryExample.html">Get Account Summary</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/AccountUpdatesExample.html">Subscribe to Account Updates</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/PortfolioUpdateExample.html">Configure real-time Portfolio Updates</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/PositionsExample.html">Request current positions</a></li></ul></div><div><ul><li><a href="http://softwarespartan.github.io/IB4m/docs/html/ErrorExample.html">Processing API error events</a></li><li><a href="http://softwarespartan.github.io/IB4m/docs/html/NextOrderIdExample.html">Request and listen for NextOrderId</a></li></ul></div><p>Have fun!</p><h2>Getting More Help<a name="9"></a></h2><p>Email brown.2179-at-gmail.com with questions, suggestions, comments etc.</p><h2>References<a name="10"></a></h2><div><ul><li><a href="http://www.interactivebrokers.com/download/newMark/PDFs/APIprintable.pdf">IB API Reference</a></li><li><a href="https://www.interactivebrokers.com/download/JavaAPIGettingStarted.pdf">Java API Getting Started Guide</a></li></ul></div><div><ul><li><a href="https://www.interactivebrokers.com/en/?f=%2Fen%2Fcontrol%2Fsystemstandalone.php%3Fos%3Dwin%26amp%3Bib_entity%3D">TraderWorkstation Download (Windows)</a></li><li><a href="https://www.interactivebrokers.com/en/?f=%2Fen%2Fcontrol%2Fsystemstandalone.php%3Fos%3Dmac%26amp%3Bib_entity%3D">TraderWorkstation Download (Mac)</a></li><li><a href="https://www.interactivebrokers.com/en/?f=%2Fen%2Fcontrol%2Fsystemstandalone.php%3Fos%3Dunix%26amp%3Bib_entity%3D">TraderWorkstation Download (Unix)</a></li></ul></div><div><ul><li><a href="https://www.interactivebrokers.com/en/?f=%2Fen%2Fsoftware%2FinstallationInstructions.php">TraderWorkstation Install Instructions</a></li></ul></div><div><ul><li><a href="https://www.interactivebrokers.com/en/index.php?f=tws&amp;p=papertrader">IB PaperTrader</a></li><li><a href="http://ibkb.interactivebrokers.com/node/663">IBKB: Open Paper Trading Account</a></li></ul></div><h2>System Requirements<a name="11"></a></h2><p>IB4m has been tested on OSX 10.10, Windows 7, and Windows 8 with both Java 7 and Java 8 using the latest versions of Trader Workstation (Dec 19, 2014, Server versions 75 and 76)</p><p class="footer"><br><a href="http://www.mathworks.com/products/matlab/">Published with MATLAB&reg; R2014b</a><br></p></div><!--
##### SOURCE BEGIN #####
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
##### SOURCE END #####
--></body></html>
```
