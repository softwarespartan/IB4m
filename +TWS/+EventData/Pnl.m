classdef (ConstructOnLoad) Pnl < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = Pnl(e); this@TWS.EventData.EventWrapper(e); end
    end
end

