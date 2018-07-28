%% Open Orders 

%% Initialize session with Trader Workstation

% get TWS session instance
session = TWS.Session.getInstance();

% create local buffer for open order and order status events 
[buf,lh] = TWS.initBufferForEvent(                        ...
                                  {                       ...
                                   TWS.Events.OPENORDER  ,...
                                   TWS.Events.ORDERSTATUS ...
                                  }                       ...
                                 );

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);
              
%% Requesting Open Orders

% request all open orders and order status
session.eClientSocket.reqAllOpenOrders();

%% Process OpenOrder and OrderStatus Events
% After requesting all open orders there are two callbacks which can be triggered
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/openorder.htm openOrder>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/orderstatus.htm orderStatus>
%
% The EWrapper::openOrder callback is fired once for each open order.  That is, there is one OpenOrderEvent delivered for each open order.
%
% The EWrapper::orderStatus callback is invoked whenever the status of an order changes and is also fired after reconnecting to TWS if the client has any open orders.
% 

%%
% If not feeling particularly adventurous, simply print out the events to the Command Window
cellfun(@(e)disp(e.data),collection2cell(buf))

%% 
% On the other hand, if feeling zesty, probe each event for class type and data type

% get the events from the buffer and convert to cell array
events = collection2cell(buf);

% do some important analysis
for i = 1:numel(events)
    
    % get the i'th event
    e = events{i};
    
    % figure out the class type of the event
    fprintf('Event class type is: %s \n',class(e));
    
    % figure out the class type of the data enclosed
    fprintf('Event data type is: %s with fields: \n',class(e.data));
    
    % display fields associated with the event.data type
    disp(fields(e.data));
end

%%
% Note that the com.tws.OpenOrder fields *contract*, *order*, and *orderState* correspond to API objects:
%
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/contract.htm com.ib.client.Contract>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/order.htm com.ib.client.Order>
% * <https://www.interactivebrokers.com/en/software/api/apiguide/java/orderstate.htm com.ib.client.OrderState>
%

%%
% Working with heterogeneous event queue is no problem.  Use _switch_ to disposition different events based on class type
for i = 1:numel(events)
    
    % get the i'th event
    e = events{i};
    
    switch class(e)

        % process OpenOrder events
        case 'com.tws.Handler$OpenOrderEvent'
            fprintf('OpenOrder: action=%s\n',char(e.data.order.action));

        % process OrderStatus events
        case 'com.tws.Handler$OrderStatusEvent'
            fprintf('OrderStatus: %s\n',char(e.data.status));
            
        % default case
        otherwise
            fprintf(                                                              ...
                    [                                                             ...
                     'The major difference between a thing that might go wrong '  ...
                     'and a thing that cannot possibly go wrong is '              ...
                     'that when a thing that cannot possibly go wrong goes wrong '...
                     'it usually turns out to be impossible to get at or repair\n'...
                    ]                                                             ...
                   );
    end
end

%% See Also
% <matlab:showdemo('TWSOrderPlacementExample') TWSOrderPlacementExample> | <matlab:showdemo('TWSExecutionDetailsExample') TWSExecutionDetailsExample>

%% References
%
% Interactive Brokers API: 
%
%    https://interactivebrokers.github.io/tws-api/open_orders.html
