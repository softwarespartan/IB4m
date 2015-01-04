%%
% For more information, see the official site:
% <https://github.com/softwarespartan github.io>


%% Initialize session with Trader Workstation
%
% Note here that the IB API associates 3 callbacks with reqAccountUpdates()
%
% * updateAccountValue()
% * updateAccountTime()
% * updatePortfolio()
%
% However, TWS.Events.ACCOUNTUPDATES is linked *only* to updateAccountValue(). 
%
% For events associated with updatePortfolio() see <matlab:showdemo('TWSPortfolioUpdateExample') TWSPortfolioUpdateExample>.
%

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for account summary events 
[buf,lh] = TWS.initBufferForEvent(TWS.Events.ACCOUNTUPDATE);

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%% Request Account Updates

% request account updates [USE YOUR ACCOUNT NUMBER HERE INSTEAD]
session.eClientSocket.reqAccountUpdates(true,'DU207406'); pause(0.5)

%% 
% AccountUpdate(s) are published as individual/separate events
% Here, for accountUpdate subscription, AccountAttributes are published as individual/separate 
% events. This is in contrast to AccountSummary event where AccountAttributes are aggregated
% into a single event (i.e. event.data = HashSet<AcountAttributes>).
% Trader Workstation pushes all attributes when subscription is started but individually there after.
buf.size()

%% Process account update events
%
% For simplicity, just print out each event in the buffer to the command window.
% See link to IB API updateAccountValue in Reference section for more information about account attributes 
cellfun(@(e)disp(e.data),collection2cell(buf));

%% References
% Interactive Brokers API: 
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/econnect.htm eConnect>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/reqaccountupdates.htm EClientSocket:reqAccountUpdates>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/updateaccountvalue.htm EWrapper:updateAccountValue>
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/updateportfolio.htm EWrapper:updatePortfolio>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/updateaccounttime.htm EWrapper:updateAccountTime>
% 
% TWS@Github:
%
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/tws/AccountAttribute.java AccountAttributes>
%
% Apache Commons:
%
% * <https://commons.apache.org/proper/commons-collections/javadocs/api-3.2.1/org/apache/commons/collections/buffer/CircularFifoBuffer.html CircularFifoBuffer>
%