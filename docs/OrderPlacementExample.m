% initialize a message handler for servers callbacks
handler = com.tws.Handler();

% create a connection objects to TWS linked to our message handler
eClientSocket = com.ib.client.EClientSocket(handler);

% connect to TWS
eClientSocket.eConnect('127.0.0.1',7496,0);

% create a stock contract for symbol SPY
contract = com.tws.ContractFactory.GenericStockContract('SPY');

% create an order 
order = com.tws.OrderFactory.GenericLimitOrder('DU207406', 'BUY', 100, 198.5);

% place the order
eClientSocket.placeOrder(8844,contract,order);