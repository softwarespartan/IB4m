classdef (ConstructOnLoad) OpenOrder < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = OpenOrder(e); this@TWS.EventData.EventWrapper(e); end
    end
end

