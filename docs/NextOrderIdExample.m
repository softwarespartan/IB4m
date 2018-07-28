%% NextOrderId

%% Initialize session with Trader Workstation
%

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for contract details events 
[buf,lh] = TWS.initBufferForEvent(TWS.Events.NEXTORDERID);

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0); pause(0.5)

%% Request Next Order ID
% When first connecting to Trader Workstation or after placing an order EWrapper::nextValidId() is called which provides the last orderId+1.
%
% It is also possible to request the next orderId with EClientSocket::reqIds().
%
% For API orders a unique orderId must be provided and furthermore orderId must not have been used to place an order previously.  That is, orderIds can only be used once.
% This is a much more strict requirement than other reqId (historical data, market depth etc) which must only be unique at the time of the request and can be used over and over.
% 

% request the next order id
session.eClientSocket.reqIds(true); pause(1);

%% Processing NextValidId Events

% blab about it
fprintf('the next order id is: %d\n',buf.get().data.nextOrderId);

%% See Also
% <matlab:showdemo('TWSOrderPlacementExample') TWSOrderPlacementExample>

%% References
% Interactive Brokers API: 
%
%    https://interactivebrokers.github.io/tws-api/order_submission.html
