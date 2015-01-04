classdef (ConstructOnLoad) Positions < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = Positions(e); this@TWS.EventData.EventWrapper(e); end
    end
end

