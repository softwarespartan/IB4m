classdef (ConstructOnLoad) MarketMetadata < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = MarketMetadata(e); this@TWS.EventData.EventWrapper(e); end
    end
end

