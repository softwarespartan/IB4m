%%
% For more information, see the official site:
% <https://github.com/softwarespartan github.io>


%% Initialize session with TWS

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for account summary events 
[buf,lh] = TWS.initBufferForEvent(TWS.Events.POSITIONS);

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%% Request Positions

% request current positions
session.eClientSocket.reqPositions(); pause(0.5)

%% Process account update events
%
% The message handler aggregates positions until EWrapper:positionsEnd() is called
% All positions up to that point are returned in a single event (i.e. event.data = HashSet<Positions>)

%%
% To check how many events have been returned
buf.get().data.size()

%%
% Keep it simple, print out each event in the buffer to the command window.
cellfun(@(e)cellfun(@(p)disp(p),collection2cell(e.data)),collection2cell(buf));

%% References
% Interactive Brokers API: 
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/econnect.htm EClientSocket:eConnect>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/reqpositions.htm EClientSocket:reqPositions>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/position.htm EWrapper:position>
% 
% TWS@Github:
%
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/tws/Position.java com.tws.Position>
% * <https://github.com/softwarespartan/TWS/blob/master/src/com/ib/client/Contract.java com.ib.client.Contract>
%