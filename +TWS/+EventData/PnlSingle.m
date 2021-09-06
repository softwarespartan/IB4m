classdef (ConstructOnLoad) PnlSingle < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = PnlSingle(e); this@TWS.EventData.EventWrapper(e); end
    end
end

