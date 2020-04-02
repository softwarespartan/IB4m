classdef (ConstructOnLoad) TickByTickAllLast < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = TickByTickAllLast(e); this@TWS.EventData.EventWrapper(e); end
    end
end

