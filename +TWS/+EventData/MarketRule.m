classdef (ConstructOnLoad) MarketRule < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = MarketRule(e); this@TWS.EventData.EventWrapper(e); end
    end
end