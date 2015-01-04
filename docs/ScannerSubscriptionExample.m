%% Market Scanner Subscriptions

%% Introduction
% Market Scanners allow you to quickly and easily scan global markets for the top performing contracts.
% Variables, filters and parameters allow you to create unique, completely customized scans. 
% For example, you may want to find the top ten most active US stocks with a price of USD 30.00 or lower, 
% but only in the Real Estate industry. Or, search for all exchange-listed US Corporate Bonds with an A1 Moody's 
% rating or better. The search definitions are practically limitless.
% 
% Interactive Brokers provides API access to many preconfigured scanner definitions such as: 
%
% * Most Active
% * Top % Gainers and Losers  
% * Hot by Price and Volume 
% * Top Trade Rate 
% * Highest and Lowest Option Implied Volatility 
% * 13-, 26- and 52-week High and Low
% * High Dividend Yield 
%
% and many more.  See 
% <https://www.interactivebrokers.com/en/software/api/apiguide/tables/available_market_scanners.htm Market Scanner Definitions> 
% for all avaliable preconfigured scanners and associated "scanCodes".

%% Initialize session with Trader Workstation

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for market depth events 
[buf,lh] = TWS.initBufferForEvent(TWS.Events.SCANNERDATA);

% connect to Trader Workstation
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%% Create Scanner Subscription Definition

% create new scanner subscription specification
scannerSubscription = com.ib.client.ScannerSubscription();

% configure the scanner definition 
scannerSubscription.numberOfRows(15           );
scannerSubscription.abovePrice  (1            );
scannerSubscription.instrument  ('STK'        );
scannerSubscription.scanCode    ('MOST_ACTIVE');

%% Request Scanner Subscription

% request the scanner subscription with reqId 0
session.eClientSocket.reqScannerSubscription(0,scannerSubscription,[]); pause(0.5);

%%
% To cancel a scanner subscription use the EClientSocket::cancelScannerSubscription method with the associated reqId to terminate (in this case reqId = 0).

%% Process Market Scanner Events

% create print function for scanner data objects (sd)
f = @(sd)fprintf('%5s: %3d\n',char(sd.contractDetails.m_summary.m_symbol),sd.rank);

% print out all scanner events in the local buffer
cellfun(@(e)f(e),collection2cell(buf.get.data));

%%
% From here make a few ContractDetails request to obtain exchange information.  Then fire up MarketData + MarketDepth subscriptions.

%% See Also
% <matlab:showdemo('TWSContractDetailsExample') TWSContractDetailsExample> | <matlab:showdemo('TWSMarketDataExample') TWSMarketDataExample> | <matlab:showdemo('TWSMarketDepthExample') TWSMarketDepthExample>
%

%% References
%
% Interactive Brokers:
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/tables/available_market_scanners.htm Market Scanner Definitions>
%
% Interactive Brokers API: 
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/reqscannersubscription.htm EClientSocket::reqScannerSubscription>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/cancelscannersubscription.htm EClientSocket::cancelScannerSubscription>
% 
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/scannerdata.htm EWrapper::scannerData>
%
% TWS@Github:
%
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/tws/ScannerData.java com.tws.ScannerData>
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/ib/client/ScannerSubscription.java com.ib.client.ScannerSubscription>
%
% Apache Commons:
%
% * <https://commons.apache.org/proper/commons-collections/javadocs/api-3.2.1/org/apache/commons/collections/buffer/CircularFifoBuffer.html CircularFifoBuffer>
%
% Oracle:
%
% * <http://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html HashSet>
%