classdef (ConstructOnLoad) MarketDepth < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = MarketDepth(e); this@TWS.EventData.EventWrapper(e); end
    end
end

