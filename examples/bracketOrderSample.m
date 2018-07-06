% init session with TWS
session = TWS.Session.getInstance();

% connect with TWS application
session.eClientSocket.eConnect('127.0.0.1',7496,0);

% init helper for next order id
nid = TWS.NextOrderId.getInstance();

% helpful if response from TWS is late for nextId
pause(0.5)

% init contract
contract = com.ib.client.Contract();

% configure contract
contract.m_symbol   = 'SPY'  ;
contract.m_secType  = 'STK'  ;
contract.m_exchange = 'SMART';
contract.m_currency = 'USD'  ;

% bracket order parameters
action        = 'BUY' ;
quantity      = 100   ;
limitPrice    = 273.00;
profitPrice   = 275.00;
lossPrice     = 271.00;

% init orders
parent     = com.ib.client.Order();
takeProfit = com.ib.client.Order();
stopLoss   = com.ib.client.Order();

% configure parent order
parent.m_orderId           = nid.nextOrderId ;
parent.m_account           = 'DU207406'      ;
parent.m_action            = 'BUY'           ;
parent.m_orderType         = 'LMT'           ;
parent.m_totalQuantity     = quantity        ;
parent.m_lmtPrice          = limitPrice      ;
parent.m_outsideRth        = true            ;
parent.m_transmit          = false           ;

% configure take profit order
takeProfit.m_orderId       = nid.nextOrderId ;
takeProfit.m_account       = 'DU207406'      ;
takeProfit.m_action        = 'SELL'          ;
takeProfit.m_orderType     = 'LMT'           ;
takeProfit.m_totalQuantity = quantity        ;
takeProfit.m_lmtPrice      = profitPrice     ;
takeProfit.m_parentId      = parent.m_orderId;
takeProfit.m_outsideRth    = true            ;
takeProfit.m_transmit      = false           ;

% configure the stop loss order
stopLoss.m_orderId         = nid.nextOrderId ;
stopLoss.m_account         = 'DU207406'      ;
stopLoss.m_action          = 'SELL'          ;
stopLoss.m_orderType       = 'STP'           ;
stopLoss.m_totalQuantity   = quantity        ;
stopLoss.m_auxPrice        = lossPrice       ;
stopLoss.m_parentId        = parent.m_orderId;
stopLoss.m_outsideRth      = true            ;
stopLoss.m_transmit        = true            ;

% package up the bracket order
bracketOrder = [parent,takeProfit,stopLoss];

% iterate over orders and place
for i = 1:numel(bracketOrder)
    
    % get the ith order
    order = bracketOrder(i);
    
    % place the order
    session.eClientSocket.placeOrder(order.m_orderId,contract,order)
end

