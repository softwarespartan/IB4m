classdef (ConstructOnLoad) Time < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = Time(e); this@TWS.EventData.EventWrapper(e); end
    end
end