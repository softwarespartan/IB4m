classdef (ConstructOnLoad) OrderStatus < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = OrderStatus(e); this@TWS.EventData.EventWrapper(e); end
    end
end

