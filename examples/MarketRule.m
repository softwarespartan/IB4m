

% init session with TWS
session = TWS.Session.getInstance();

% connect with TWS application
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%init buffer for MarketRule events
[buf,lh] = TWS.initBufferForEvent(TWS.Events.MARKETRULE);

% market rule id
mrid = 26;

% request market rule
session.eClientSocket.reqMarketRule(mrid);

% wait for event
pause(0.2)

% get the event from the event buffer
event = buf.get();

% get the size of the array list of price increments
num_increments = size(event.data);

% extract price increment 
pi = event.data.get(0);

% have a look at methods/fields for this object
methods(pi)

% blab about it
fprintf('id: %d, increment: %0.3f, lowEdge: %f\n',mrid,pi.increment,pi.lowEdge)
