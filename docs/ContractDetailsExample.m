%% Contract Details

%% Initialize session with TWS 
%
% Typically, before a call to subscribe to market data, a request for 
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
contract = com.ib.client.Contract();
contract.symbol('SPY')
contract.exchange('SMART');
contract.primaryExch('ISLAND');
contract.currency('USD');
contract.secType('STK');

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);
           
%% Make request for contract details for SPY
session.eClientSocket.reqContractDetails(0,contract); pause(2);

%% Process contract details events

% Contract details have a lot going on so make sure to look through the references listed below.
% There are instances when contract details returns many details objects therefore a HashSet<ContractDetails> is returned. 
buf.get().data

% the hash set of com.tws.ContractDetails objects can be easily converted to a cell array
details = collection2cell(buf.get().data);

%%
% the buffer can be purged of all events using clear 
buf.clear();

%% Request contract details for Options
%
%  In a similar way, contract details for options can be requested. 

% create generic contract for IBM
%contract = com.tws.ContractFactory.GenericStockContract('IBM');

contract = com.ib.client.Contract();
contract.symbol('IBM')
contract.exchange('SMART');
contract.primaryExch('');
contract.currency('USD');
contract.secType('OPT');

% configure the contract for options
%contract.m_secType = 'OPT'; contract.m_primaryExch = [];

% get all the details for this option
session.eClientSocket.reqContractDetails(0,contract); pause(10)

%%
% Note that a contract details object with be returned for each strike price and expiry!
%
% Sometimes can take a long time to get options contract details back so busy wait ...
while(buf.isEmpty); pause(1); end
    
% turn hashset of ContractDetails into cell array of ContractDetails
details = collection2cell(buf.get().data);

% check out how many contract details events were returned
numel(details)

%% 

% get a list of all expiry dates for this option
expiryDates = cellfun(@(d)char(d.contractDetails.realExpirationDate),details,'UniformOutput',0);

% get list of unique expiry dates for this option
unique(expiryDates)

%% See Also
% <matlab:showdemo('TWSMarketDepthExample') TWSMarketDepthExample> | <matlab:showdemo('TWSMarketDataExample') TWSMarketDataExample>


%% References
% Interactive Brokers API: 
%
%    http://interactivebrokers.github.io/tws-api/basic_contracts.html
%
%    https://interactivebrokers.github.io/tws-api/contract_details.html
%
