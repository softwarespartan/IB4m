%% Market Data (Level I) 

%% Initialize session with Trader Workstation

% get TWS session instance
session = TWS.Session.getInstance();

% create local buffer for market data events with size 10,000 (default size is 32)
[databuf,datalh] = TWS.initBufferForEvent(TWS.Events.MARKETDATA,10000);

% create local buffer for market metadata events with size 1000
[metabuf,metalh] = TWS.initBufferForEvent(TWS.Events.MARKETMETADATA,1000);

% create a callback to print error messages to the command window
lherr  = event.listener(                         ...
                        TWS.Events.getInstance  ,...
                        TWS.Events.ERROR        ,...
                        @(s,e)disp(e.event.data) ...
                       );

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);
 
%%
% A callback to print out error message to the command window is particularly useful here. There are many possible errors associated with requesting Market Depth in general and in particular the specified contract/exchange might not privide the requested data.
%

%% Requesting Level 1 Market Data
% There is a slight deviation from the native IB Java API here.  Namely, level 1 market data callbacks are separated into:
%
% * MarketDataEvents
% * MarketMetadataEvents
%
% MarketDataEvents are produced when the market data changes.  A change in market data corresponds to changes in the size and/or price of the best ask/bid offer avaliable on the subscribed exchange.  
%
% Changes in market data (best ask/bid offer) are communicated through _MarketDataEvents_ associated with EWrapper callbacks:
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/ticksize.htm EWrapper::tickSize>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/tickprice.htm EWrapper::tickPrice>
%
% Many axuillary types of market data ticks can be requested as a part of the market data request.  These data are refered to as 
% <https://www.interactivebrokers.com/en/software/api/apiguide/tables/generic_tick_types.htm _Generic Ticks_>  
% and are communicated through _MarketMetadataEvents_.  
%
% See
% <https://www.interactivebrokers.com/en/software/api/apiguide/tables/tick_types.htm Tick Types>
% for additional descriptions of tick types and associated EWrapper callback.  The bottom line is that *tickValue/field < 10 are MarketDataEvents* and everything else is MarketMetadata. 
%

%%
% The first step in constructing a market data request is to specify a contract which encapsulates the equity symbol and exchange information.

% create an empty stock contract
contract = com.tws.ContractFactory.GenericStockContract('SPY');

%% 
% By default the exchange for GenericStockContract is 'SMART' which is only appropriate when placing an order request.
%
% There are many different exchanges to choose from for data subscriptions such as:
%
% * <http://en.wikipedia.org/wiki/Island_ECN ISLAND>
% * <http://en.wikipedia.org/wiki/NYSE_Arca ARCA>
% * <http://www.batstrading.com BATS>
% * <http://en.wikipedia.org/wiki/Direct_Edge DRCTEDGE>
% * <https://www.lavaflowecn.com LAVA>
% 
% and many more.  
%
% Operationally, it is advisable to make a Contract Details request for a complete list of valid exchanges. 
%
% For additional information of avaliable market data accessable through Interactive Brokers see <https://www.interactivebrokers.com/en/index.php?f=marketData&p=mdata Market Data Feed Options>.

%%
% All of the exchanges listed above list 'SPY' so any one of them will work for this example.

% set the exchange for which to obtain market data
contract.m_exchange = 'ARCA';  contract.m_primaryExch = 'ARCA';

%%
% Specify the <https://www.interactivebrokers.com/en/software/api/apiguide/tables/generic_tick_types.htm Generic Tick Tags> (metadata) for subscription.  Note that generic ticks cannot be specified if using a _Snapshot_ market data subscription.

% list of metadata ticks
genericTickList = [                                      ...
                   '100,101,105,106,107,125,165,166,'    ...
                   '225,232,221,233,236,258, 47,291,'    ...
                   '293,294,295,318,370,370,377,377,'    ...
                   '381,384,384,387,388,391,407,411,'    ...
                   '428,439,439,456, 59,459,460,499,'    ...
                   '506,511,512,104,513,514,515,516,517' ...
                  ];
            
%%
% Since multiple market data subscriptions can be active simultaniously it is important to provide a unique request Id for each market data request
reqId = 0;

%% 
% Having a unique request ID, contract to specify symbol and exchange, and a list of metadata we're ready to make a market data request.

% request market data subscription.  Note that arg4 is read as "snapshot=false"
session.eClientSocket.reqMktData(reqId,contract,genericTickList,false,[]); pause(1);

%% 
% It is important to keep in mind that a continuous data subscription has been started so that MarketDataEvents will be streamed until disconnected from TWS or the subscription is cancelled. 
% Alternatively, provide _true_ (read 'snapshot=true') to only take an instantanious peak at the market data without spining up a subscription.  
% That is, market data snapshots are one-time thing providing a single instance of top of the book market data for the equity on the specified exchange. 

%%
% To cancel a market data subscription simply call EClientSocket::cancelMktData method with the associated request Id.

%% Processing Market Data Events (Part 1)
% Depending on the symbol and exchange, market data events can be vary numerous.  
% At the time of current writting, market data rate range from 45 to 5 per second: 
%
% <html>
% <table border=1>
% <tr><td>Exchange</td><td>msg rate</td></tr>
% <tr><td>ISLAND</td><td>45</td></tr>
% <tr><td>BATS</td><td>20</td></tr>
% <tr><td>LAVA</td><td>17</td></tr>
% <tr><td>TPLUS2</td><td>5</td></tr>
% </table>
% </html>
% 
%
% Market metadata events are generally fewer than data events.
%

%%
% First, have a look at the market data events by printing them out to the Command Window:

% dump market data events to the screen
cellfun(@(e)disp(e.data),collection2cell(databuf))
 
%%
% Simillarly, lets have a look at a few metadata events

% print out string representation of market metadata objects
cellfun(@(e)disp(e.data),collection2cell(metabuf))

%%
% It is fairly straight forward to process market data events based on tickId.
% For ease of use, create cell array of market data events from the data buffer

% aggregate market data events in the buffer to cell array
mktDataEvents = collection2cell(databuf);

%%
% Rough outline for processing events by tickId:

for i = 1:min(numel(mktDataEvents),10)
    
    e = mktDataEvents{i};
    
    switch e.data.tickId
        
        case 0
            % bid size 
        case 1
            % bid price 
        case 2 
            % ask price 
        case 3
            % ask size 
        case 4
            % last sale price
        case 5
            % last sale size
        case 8 
            % total volume
        otherwise
            % no op
    end
end

%% Processing Market Data Events (Part 2)
% When multiple market data subscriptions are active simultaniously, additional book keeping is required to match/map market data reqId to the exchange associated with the subscription.
%
% This can be accomplished using MATLAB's built-in containers.Map or java.util.HashMap.  

%%
% A java HashMap can be initialized as
map = java.util.HashMap();

%%
% For each market data request/subscription make an entry in the map to keep track of which reqId goes with which exchange
map.put(reqId,contract.m_exchange);

%%
% Then when processing events, translate the subscription request Id into a human readable exchange name
map.get(databuf.get().data.reqId)
map.get(metabuf.get().data.reqId)

%%
% Using hash map ensure constant time retreival of the exchange string.  Solutions involving _strcmp_ can be tedious and do not generally scale well for processing many events quickly.

%% See Also
% <matlab:showdemo('TWSMarketDepthExample') TWSMarketDepthExample> | <matlab:showdemo('TWSContractDetailsExample') TWSContractDetailsExample>

%% References
% Interactive Brokers:
%
% * <https://www.interactivebrokers.com/en/index.php?f=marketData&p=mdata Market Data Feed Options>
%
% Interactive Brokers API: 
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/tables/tick_types.htm Tick Types>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/tables/generic_tick_types.htm Generic Tick Tags>
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/econnect.htm EClientSocket::eConnect>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/reqmktdata.htm EClientSocket::reqMktData>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/cancelmktdata.htm EClientSocket::cancelMktData>
% 
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/tickprice.htm EWrapper::tickPrice>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/ticksize.htm EWrapper::tickSize>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/tickstring.htm EWrapper::tickString>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/tickgeneric.htm EWrapper::tickGeneric>
%
% TWS@Github:
%
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/tws/MarketData.java com.tws.MarketData>
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/tws/MarketMetadata.java com.tws.MarketMetadata>
%
% Apache Commons:
%
% * <https://commons.apache.org/proper/commons-collections/javadocs/api-3.2.1/org/apache/commons/collections/buffer/CircularFifoBuffer.html CircularFifoBuffer>
%