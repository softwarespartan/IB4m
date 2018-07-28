%% Market Depth (Level II)
%
% Typically before a call for to subscribe to market data a request for 
% contract details is made to obtain a list of valid exchanges.
%
% Note that not all exchanges will provide level II data.
% Generally, only ARCA, BATS, ISLAND, BEX provide market depth.

%% Initialize session with Trader Workstation

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for market depth events with size 10,000 (default size is 32)
[buf,lh] = TWS.initBufferForEvent(TWS.Events.MARKETDEPTH,10000);

% create a callback to print error messages to the command window
lherr  = event.listener(                         ...
                        TWS.Events.getInstance  ,...
                        TWS.Events.ERROR        ,...
                        @(s,e)disp(e.event.data) ...
                       );

% connect to Trader Workstation
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%%
% A callback to print out error message to the command window is particularly useful here. There are many possible errors associated with requesting Market Depth in general and in particular the specified contract/exchange might not privide the requested data.
%
% The error message for symbol/type/exchagne mismatch typically looks like:
% _0 10092 Deep market data is not supported for this combination of security type/exchange_
%

%% Request level II market data for SPY
% Requesting L2 data is straight forward require only unique request ID, contract, and depth
% Note that accessing level II data requires activation within your Interactive Brokers Market Data Feed.
% See Interactive Brokers 
% <https://www.interactivebrokers.com/en/index.php?f=marketData&p=mdata market data feed page> for additional information.

%%
% First create a generic contract for SPY

% create a stock contract for symbol SPY
contract = com.ib.client.Contract();
contract.symbol('SPY')
contract.currency('USD');
contract.secType('STK');

%% 
% As mentioned above, not all exchanges offer market depth so care must be taken to specify the exact exchange for which to obtain data.
%
% For example, the default exchange for a GenericStockContract is "SMART" which will not work for market data requests.
% Therefore must set the exchange explicitly here.

% set the exchange for which to obtain market depth
contract.exchange('ISLAND');  contract.primaryExch('ISLAND');

%%
% The request ID is simply any positive integer as long as it is unique at the time the request is placed

% a unique integer identifier for this data request
reqId = 0;

%%
% Next specify the number of rows of market depth to return

% specify the depth of the market data returned
numRows = 10;

%%
% Finally, request level II market data

% request numRows of market depth for specified contract.   
session.eClientSocket.reqMktDepth(reqId,contract,numRows,[]);

%%
% In the event your request ID is not unique you can expect an error event/message which looks like: _0 322 Error processing request:-'wd' : cause - Duplicate ticker id_

%% 
% To cancel market data subscription simply call session.eClientSocket.cancelMktDepth(0) 
% with the associated request ID you wish to cancel.  For this example the request ID is 0.
%
% If an attempt is made to cancel a market depth request for a nonexistent reqID an error event/message will be produced: _0 310 Can't find the subscribed market depth with tickerId:0_

%% Processing Market Depth Events (Part 1)
% Market depth requests will produce a very large amount of data (100 or even 1000 events per second) during regular trading hours.  Keep in mind that the buffer initialized above is circular and once full will remove the oldest events to make room for new events.

%% 
% After a few second the buffer will contain many market depth events.  To check the number of events in the buffer call the size() method.
pause(5); buf.size()

%%
% The number of simultanious market depth subscriptions active is limited by Interactive Brokers to something like 3 to 5 at at any one time.
% Therefore, if multiple market depth subscriptions are active, it is important to check the request id associated with the event.  

% get the reqId associated with a market depth event
buf.get().data.reqId

%% 
% Note here that the buf is a FIFO buffer such that _buf.get()_ returns the least recently added (i.e. oldest) event from the event buffer. 

%%
% Pull out events from the buffer to cell array

% create cell array of market depth events
events = collection2cell(buf);

%%
% Since there are likely many events only print more recent ones to the command window
for i = 1:10; disp(events{end-10+i}.data); end
%%
% The format here is {reqID} {row} {marketmaker} {operation} {side} {price} {size} where size has units of 100 shares. That is, size = 1 means 100 shares and so on.  Check out the references below for full details.

%% Processing Market Depth Events (Part 2)
% With mktDepth subscriptions it is important to note that there are two callbacks associated with EClientSocket::reqMktDepth
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/updatemktdepth.htm updateMktDepth>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/updatemktdepthl2.htm udpateMktDepthL2>
%
% which can be a little confusing at first.  When specifying an echange where multiple market makers are active the market maker must be identified explicitly using the _updateMktDepthL2_ callback.
% Currently, only ISLAND exchange has multiple active market makers, namely itself (ISLAND) and NASDAQ (NSDQ).  Otherwise all market depth information is fed through the _updateMktDepth_ callback where the marketMaker is defined by the contract provided in the reqMktDepth call.
%
% For example, if the contract exchange is specified as 

contract.m_exchange = 'ARCA';  contract.m_primaryExch = 'ARCA';

%%
% then market depth information is provided by the _updateMktDepth_ callback and would show up something like
%
% _0 4 null 0 0 205.69 9_ 
%
% where there is a "null" since the market maker (ARCA) is "implied" as ARCA is the only market maker on the ARCA exchange.
%
% Therefore additional book keeping is required to match/map market depth reqID to an appropriate market maker string.
% This can be accomplished using MATLAB's built-in containers.Map or java.util.HashMap.  

%%
% A java HashMap can be initialized as
map = java.util.HashMap();

%%
% For each market depth request/subscription make an entry in the map to keep track of which reqId goes with which exchange
map.put(reqId,contract.m_exchange);

%%
% and translate back each event as 
map.get(buf.get().data.reqId)

%% See Also
% <matlab:showdemo('TWSMarketDataExample') TWSMarketDataExample> | <matlab:showdemo('TWSContractDetails') TWSContractDetails>

%% References
%
% Interactive Brokers API: 
%
%    https://interactivebrokers.github.io/tws-api/market_depth.html