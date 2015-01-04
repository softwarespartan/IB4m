classdef (ConstructOnLoad) RealTimeBar < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = RealTimeBar(e); this@TWS.EventData.EventWrapper(e); end
    end
end