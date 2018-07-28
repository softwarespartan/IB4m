%%
% For more information, see the official site:
% <https://github.com/softwarespartan github.io>

%% Initialize session with Trader Workstation

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for protfolio update events 
[buf,lh] = TWS.initBufferForEvent(TWS.Events.PORTFOLIOUPDATE);

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%% Request Portfolio Updates
%
% Note here that the IB API associates 3 callbacks with reqAccountUpdates()
%
% * updatePortfolio()
% * updateAccountTime()
% * updateAccountValue()
%
% However, TWS.Events.PORTFOLIOUPDATE is linked *only* to EWrapper:updatePortfolio() callback. 
%
% For events associated with updateAccountValue() see <matlab:showdemo('TWSAccountUpdatesExample') TWSAccountUpdatesExample>.
%

% request account updates [*USE YOUR IB ACCOUNT NUMBER HERE*]
session.eClientSocket.reqAccountUpdates(true,'DU207406');

%% Process PortfolioUpdate events
% Print out updates to the screen
cellfun(@(e)disp(e.data),collection2cell(buf))

%%
% Note that to cancel portfolio updates call reqAccountUpdates(*false*,'DU207406')

%% References
% Interactive Brokers API: 
%
%    https://interactivebrokers.github.io/tws-api/account_updates.html
