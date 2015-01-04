%% Contract Details

%% Initialize session with TWS and request contract details for SPY
%
% Typically before a call for to subscribe to market data a request for 
% contract details is made to obtain a list of valid exchanges.
%
% Furthermore, note that not all exchanges will provide level II data.
% Generally, only ARCA, BATS, ISLAND, BEX provide market depth.
%

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for contract details events 
[buf,lh] = TWS.initBufferForEvent(TWS.Events.CONTRACTDETAILS);

% create an empty stock contract
contract = com.tws.ContractFactory.GenericStockContract('SPY');

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);
              
% request account attributes
session.eClientSocket.reqContractDetails(0,contract); pause(0.5);

%% Process contract details events
%
% Contract details have a lot going on so make sure to look through the reference listed below
buf.get().data

%% See Also
% <matlab:showdemo('TWSMarketDepthExample') TWSMarketDepthExample> | <matlab:showdemo('TWSMarketDataExample') TWSMarketDataExample>


%% References
% Interactive Brokers API: 
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/reqcontractdetails.htm EClientSocket:reqContractDetails>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/contractdetails.htm EWrapper:contractDetails>
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/contract.htm com.ib.client.Contract>
% 
% TWS@Github:
%
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/ib/client/Contract.java com.ib.client.Contract>
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/ib/client/ContractDetails.java com.ib.client.ContractDetails>
%
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/tws/ContractFactory.java com.tws.ContractFactory>
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/tws/ContractDetails.java com.tws.ContractDetails>
%
% Apache Commons:
%
% * <https://commons.apache.org/proper/commons-collections/javadocs/api-3.2.1/org/apache/commons/collections/buffer/CircularFifoBuffer.html CircularFifoBuffer>
%