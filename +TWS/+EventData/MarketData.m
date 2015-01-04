classdef (ConstructOnLoad) MarketData < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = MarketData(e); this@TWS.EventData.EventWrapper(e); end
    end
end

