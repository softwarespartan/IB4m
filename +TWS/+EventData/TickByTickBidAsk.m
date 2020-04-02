classdef (ConstructOnLoad) TickByTickBidAsk < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = TickByTickBidAsk(e); this@TWS.EventData.EventWrapper(e); end
    end
end

