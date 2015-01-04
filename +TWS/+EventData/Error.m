classdef (ConstructOnLoad) Error < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = Error(e); this@TWS.EventData.EventWrapper(e); end
    end
end
