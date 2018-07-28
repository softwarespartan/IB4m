% configure buffers for contract details
[detailsBuf , detailslh] = TWS.initBufferForEvent(TWS.Events.CONTRACTDETAILS);
[dataBuf    , datalh   ] = TWS.initBufferForEvent(TWS.Events.HISTORICALDATA );

% initialize session with TWS
session = TWS.Session.getInstance();

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);

% create contract object
contract = com.ib.client.Contract();
contract.symbol('IBM')
contract.exchange('SMART');
contract.primaryExch('ISLAND');
contract.currency('USD');
contract.secType('STK');


% change security type to "option"
contract.m_primaryExch = []; contract.m_secType='OPT';

% get all the details for this option (each strike price has own details!)
session.eClientSocket.reqContractDetails(0,contract); pause(2)

% extract each deatils object into a cell array 
e = collection2cell(detailsBuf.get().data);

% print out expiry and strike price for each result
for i = 1:numel(e)
    
    % get expiry 
    expiry = e{i}.contractDetails.m_summary.m_expiry;
    
    % get the strike price
    strike = e{i}.contractDetails.m_summary.m_strike;
    
    % blab about it ...
    fprintf('%s %7.2f\n',char(expiry),strike); 
end

% choose any expiry and strik price and create a contract
contract.m_expiry = '20160909';  contract.m_strike = 155.00; contract.m_right = 'CALL';

% ask for historical data for this contract
session.eClientSocket.reqHistoricalData(1000001,contract,'20160909 16:00:00','1 W','5 mins','TRADES',1,1,[]); pause(2);

% pop server response from buffer
response = dataBuf.get();

% get historical bars
data = collection2cell(response.data);

% Extract close and high low ave info from each bar`
close = cellfun(@(b)b.close ,data);   
vol   = cellfun(@(b)b.volume,data);  
high  = cellfun(@(b)b.high  ,data);  
low   = cellfun(@(b)b.low   ,data);  
open  = cellfun(@(b)b.open  ,data);
wap   = cellfun(@(b)b.wap   ,data);
count = cellfun(@(b)b.count ,data);
hla   = cellfun(@(b)(b.high+b.low)/2,data); 

% Convert the string time of the bars to matlab datenum
dt = datenum(cellfun(@(b)char(b.dtstr),data,'UniformOutput',false),'yyyymmdd HH:MM:SS');

% The bars might not be in order once extracted from the HashSet
[~,indx] = sort(dt);  

% sort time stamps and get unique
dt = dt(indx);  [~,uix] = unique(dt); 

% init bars
bars = struct();

% sort and assign 
                      bars.dt     = dt   (uix); 
close = close(indx);  bars.close  = close(uix);
hla   = hla  (indx);  bars.hla    = hla  (uix);
high  = high (indx);  bars.high   = high (uix);    
low   = low  (indx);  bars.low    = low  (uix);  
open  = open (indx);  bars.open   = open (uix); 
vol   = vol  (indx);  bars.volume = vol  (uix);
wap   = wap  (indx);  bars.wap    = wap  (uix);
count = count(indx);  bars.count  = count(uix);

% sort the data (just incase)
data = data(indx);  data = data(uix);

% plot some data
plot(bars.dt,bars.close); datetick;

% clear data buffer
dataBuf.clear();
