%%
% For more information, see the official site:
% <https://github.com/softwarespartan github.io>

%% Initialize session with Trader Workstation

% initialize session with TWS
session = TWS.Session.getInstance();

% create local buffer for historical data events 
[buf,lh] = TWS.initBufferForEvent(TWS.Events.HISTORICALDATA);

% connect to TWS
session.eClientSocket.eConnect('127.0.0.1',7496,0);

%% Requesting historical data from IB/TWS

% create an empty stock contract
contract = com.ib.client.Contract();
contract.symbol('FB')
contract.exchange('SMART');
contract.primaryExch('ISLAND');
contract.currency('USD');
contract.secType('STK');

% request historical data for our contract for a year w/ 1-day bars
session.eClientSocket.reqHistoricalData(1000001,contract,'20141230 16:00:00','1 Y','1 day','TRADES',1,1,false,[]); pause(0.5);

%% Process historical data event
%
% Under the hood, Trader Workstation returns one bar at a time.  That is, EWrapper:historicalData() is
% called once for each bar.  Each bar associated with the request ID, 1000001 in this case, is aggregated
% into a single event (i.e. event.data = HashSet<com.tws.Bar>)

%% 
% Retreive the historical data event from the buffer
hde = buf.get();

%% 
% Convert the HashSet<Bar> into more native cell array of bars
bars = collection2cell(hde.data);

%%
% Figure out how many bars were returned
numel(bars)

%% 
% but could also call size() method on event.data directly without cell conversion
numel(bars) == hde.data.size()

%%
% Print out bars to the screen
for i = 1:min(numel(bars),10); disp(bars{i}); end

%%
% Extract close and volume info from each bar
close = cellfun(@(b)b.close,bars);  vol = cellfun(@(b)b.volume,bars);

%% 
% Convert the string time of the bars to matlab datenum
dt = datenum(cellfun(@(b)char(b.dtstr),bars,'UniformOutput',false),'yyyymmdd HH:MM:SS');

%%
% The bars might not be in order once extracted from the HashSet
[~,indx] = sort(dt);

%%
% Now, finally, plot the data
subplot(5,1,1:3); plot(dt(indx),close(indx),'Marker','.'); xlim([min(dt),max(dt)]); datetick; grid on; ylabel('close' );
subplot(5,1,4:5); bar (dt(indx),vol  (indx)             ); xlim([min(dt),max(dt)]); datetick; grid on; ylabel('volume');

%%
% From here, it is easy to move on to candel plots and other technical indicators etc.

%% See Also
%
% <matlab:candle candle> | <matlab:highlow highlow> | <matlab:bolling bolling> | <matlab:movavg movavg> 
%

%% References
%
% Mathworks Financial Toolbox:
%
% * <http://www.mathworks.com/help/finance/chart-technical-indicators.html Technical Indicators>
%
% Matlab File Exchange:
%
% * <http://www.mathworks.com/matlabcentral/fileexchange/33430-technical-indicators Technical Indicators>
%
% Interactive Brokers API: 
%
%    https://interactivebrokers.github.io/tws-api/historical_data.html
%