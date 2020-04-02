classdef (ConstructOnLoad) TickByTickMidPoint < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = TickByTickMidPoint(e); this@TWS.EventData.EventWrapper(e); end
    end
end