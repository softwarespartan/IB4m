%%
% For more information, see the official site:
% <https://github.com/softwarespartan github.io>

%% Initialize session with TWS and create buffer for errors

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for error events
[buf,lh] = TWS.initBufferForEvent(TWS.Events.ERROR);

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%% Print out error events 

% yammer about errors on the command window
cellfun(@(e)disp(e.data),collection2cell(buf));

%% References
% Interactive Brokers API: 
%
%    https://interactivebrokers.github.io/tws-api/error_handling.html
%