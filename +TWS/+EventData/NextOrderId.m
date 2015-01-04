classdef (ConstructOnLoad) NextOrderId < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = NextOrderId(e); this@TWS.EventData.EventWrapper(e); end
    end
end

